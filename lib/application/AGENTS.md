**Location**: `lib/application/`

# Application Layer Rules

You are working in the **APPLICATION LAYER** - the orchestration and state management layer.

## Application Layer Responsibilities

- **Cubits** for state management (BLoC pattern)
- Orchestrate business workflows and use cases
- Coordinate between Domain and Infrastructure layers
- Handle application-specific business logic
- Manage application state and user interactions

## What BELONGS in Application

- Application-specific business workflows
- State classes for UI state representation
- Coordination between repositories and UI
- Input validation and transformation
- Submit-time required-field validation for a specific user flow (for example, "currency is required before save")
- Error handling and user feedback logic

## What NEVER belongs in Application

- UI widgets or presentation logic
- Direct database or HTTP calls
- Platform channels or low-level APIs (use Infrastructure abstractions instead)
- SharedPreferences or direct data persistence (use Infrastructure layer)
- Infrastructure implementations
- Raw maps or primitive bundles (prefer domain factories/value-object constructors)
- Platform-specific code
- Business rules (belongs in Domain)

## Cubit Rules

- ALWAYS extend BaseCubit (no exceptions)
- Cubits MUST be encapsulated and NEVER communicate directly with other cubits
- Use dependency injection (@injectable + generated wiring) - inject all dependencies via constructor
- Cubit use case/service dependencies must be required constructor params stored as `final` fields (no optional fallback patterns like `UseCase? dep` + `dep ?? ...`)
- Cubits must not resolve use case/service dependencies via `getIt` in field initializers, lazy getters, constructors, or methods
- Direct getIt<T>() is only acceptable for cross-cutting singletons (EventBus, IPollAndDebounce)
- Transient UI events like showing a dialog or a toast are handled by firing EventBus messages
- Keep methods focused and single-purpose

### Cubit Lifecycle

**Constructor Phase:**
- Inject all dependencies via constructor parameters
- Initialize with a clear initial state (often using named constructor like `.initial()`)
- NEVER emit states in the constructor
- NEVER perform async operations in the constructor
- Declare stream subscription variables as nullable instance fields

**Active Phase (after instantiation):**
- If necessary, initialize cubits immediately after creation using a dedicated `init()` method that emits state with initial data (like id, etc.)
- Expose public methods that handle user actions or external events
- Use `emit()` to update state in response to events or data changes
- Subscribe to repository streams and handle their payloads in private listener methods
- Use private helper methods (prefixed with `_`) for internal logic and stream handlers

**Important Lifecycle Rules:**
- Cubits should never hold references to UI objects like BuildContext or Controllers
- Avoid long-lived subscriptions that outlive the Cubit's lifecycle
- Clean separation: constructor for DI, public methods for actions, private methods for orchestration, close for cleanup

## State Management

- Define clear state classes for each Cubit
- Use immutable state objects
- State classes always extend Equatable
- Avoid nested state complexity
- **Never use nullable domain types (entities, value objects) as state fields.** The domain layer already encodes absence via `.empty()` / `.invalid()` factories; nullable fields re-introduce the ambiguity those factories exist to remove and force `== null` guards in every reader. Declare the field non-nullable, default it to `.empty()` / `.invalid()` in `.initial()`, and check `field.isInvalid` / `field.valid` in the cubit. Status and helper enums follow the same rule — add an explicit `none` / `idle` / `unknown` variant rather than making the enum field nullable. See the application-state-modeling skill for the full rule.

### State Copying Patterns

- Every state class MUST implement a `copyWith` method for creating modified copies
- The `copyWith` method should accept optional parameters for all state properties
- Use `copyWith` when emitting state updates to preserve immutability
- Only specify properties that are changing in the `copyWith` call
- Never mutate state properties directly - always create new state instances via `copyWith`
- When updating nested objects within state, consider providing copyWith on those objects as well

## Repository Usage

### Modern Approach (Preferred): Use Cases

- Use cases encapsulate business logic and orchestrate interactions with repositories
- Cubits/BLoCs should call use cases instead of repositories directly
- Each use case should have a single responsibility and focused purpose
- Use cases return domain entities or failures wrapped in appropriate result types

### Legacy Approach: Direct Repository Access

- **Note:** Direct repository access from Cubits is the legacy pattern. Prefer using use cases for new code.
- Always inject repository interfaces, never implementations
- Subscribe to repository streams for reactive updates
- Handle repository failures appropriately
- Cache application-level computed data

### Stream Subscription Management

- Store stream subscriptions as nullable instance variables (e.g., `StreamSubscription? _mySubscription`)
- Cancel existing subscriptions in a dedicated cleanup method before creating new ones to prevent memory leaks
- MUST override the `close()` method when managing stream subscriptions
- In `close()`, cancel all active subscriptions using `?.cancel()` before calling `super.close()` as the final statement
- Mark `close()` with `@override` annotation for clarity

## Error Handling

- Catch and transform domain failures to UI-friendly messages
- Emit appropriate error states
- Log errors for debugging. Error events stored at lib/domain/core/analytics/event.dart and related event files (part_of).
- Provide fallback mechanisms where appropriate
- Never let unhandled exceptions reach the UI

## ALWAYS use

- Cubits + BLoC pattern for state management
- Proper error handling and state transitions

## NEVER use

- StatefulWidget for business logic
- Manual instantiation of dependencies (use DI)
- setState() for complex state management
- Long-running/blocking sync operations (offload I/O and heavy compute to repositories/services)
