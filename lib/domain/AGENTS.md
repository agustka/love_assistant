**Location**: `lib/domain/`

# Domain Layer Rules

You are working in the **DOMAIN LAYER** - the core business logic layer.

## Domain Layer Responsibilities

The domain layer is the **invariant-enforcing "meaning" layer** of the application.
Every piece of data that enters the system — whether from a backend API, cached storage,
or user input — must be validated, normalized, and encapsulated into domain types before
the rest of the codebase can consume it.

- **Value Objects** are the first line of defense: they **parse, validate, and normalize**
  raw primitives at construction time, rejecting invalid data eagerly via `Failure`.
  They also expose derived formatting and semantic queries (e.g., `format()`,
  `isLegalEntity`, `fractionDigits`).
- **Entities** are composed entirely of Value Objects — never raw primitives — so that
  an entity instance is **always in a valid, meaningful state** by construction.
  Entities encapsulate **derived behavior and decision logic**: eligibility checks,
  filtering, sorting, computed properties (e.g., `canFreezeCard`, `isSavingsAccount`,
  `isPayoffAllowed`), keeping business rules collocated with the data they govern.
- **Use Cases** orchestrate repositories and apply domain transformations when a
  workflow spans multiple entities or requires coordination beyond a single object,
  returning results through domain wrappers (`Payload`, `StreamPayload`).
- The domain contains **pure business logic with NO external dependencies** — no UI,
  HTTP, database, or platform code.

## What BELONGS in Domain

- Entities with business rules and invariants
- Value Objects (EmailAddress, UserId, etc.)
- Domain events and business rules
- Enums and domain constants
- Domain wrappers: `Payload<T>`, `StreamPayload<T>`, `CacheWrapper<T>`, `Failure<T>`
- Domain entity interfaces (e.g., `ITransaction`, `ITransactions`, `IMarketChartData`)
- Use cases (`lib/domain/<feature>/use_cases/`)

## What NEVER belongs in Domain

- UI components or widgets
- HTTP clients or external APIs
- Database implementations
- Platform-specific code
- Cubits or state management
- Infrastructure implementations (repositories, services, caching)
- Model classes (DTOs) - these belong in infrastructure

## Value Objects Rules

- ALWAYS extend `ValueObject<T>` base class from `domain/core/value_objects/value_object.dart`
- **Strict null-safety throughout** - no nullable types unless absolutely necessary
- Use factory constructor for parsing/validation: `factory XxxValueObject(String? input)`
- Provide `.invalid()` factory for invalid instances - use `const` named constructor if possible
- Use private constructor `const XxxValueObject._(T super.input, super.failure)`
- Validate in static `_validate()` method returning `Failure?`
- Parse in static `_parse()` method returning the typed value
- Provide `get` accessor using `getOr()` with default fallback value
- Include parsing, formatting, and validation logic in the value object
- Can contain enums for valid values - e.g., `PaymentRequestStatus` enum in same file as `PaymentRequestStatusValueObject`
- Enums often have extensions with business logic (localized names, sorting indices, computed properties)
- Use `errEnum()` from error_handler for logging unrecognized enum values during parsing
- When adding a new `PageName` route in `lib/domain/core/navigation/named_route.dart`, also add its mapping in `AdobeSubSectionX.toAdobeSubsection()` (`lib/domain/core/adobe/entities/adobe_subsection.dart`) to keep the `switch` exhaustive and analytics classification complete

## Entity Rules

- Rich domain models with business logic (e.g., computed properties, business methods)
- ALWAYS extend `Equatable` for value equality
- Use `@immutable` annotation from foundation.dart
- Provide `.invalid()` factory for invalid instances - use `const` named constructor if possible
- Provide `.empty()` factory for valid but empty instances - use const named constructor if possible
- ALWAYS provide `fromModel` named constructor or factory for constructing domain entities from infrastructure models - domain objects should not have `toDomain()` methods on models
- Include `valid` or `isValid` boolean property (defaults to true) to indicate entity validity
- Provide `isInvalid` getter computed from validity property: `bool get isInvalid => !valid;`
- Use Value Objects as entity properties, not raw primitives
- NEVER use nullable fields on entities — every field must be a Value Object or another Entity (never a nullable type, never a raw primitive). Absence is modeled by a Value Object's `.empty()`/`.invalid()` state, not by `null`.
- Keep entities focused on single responsibility
- No infrastructure concerns (no caching, HTTP, database logic)
- Can contain domain logic methods (e.g., `findAccount()`, `hasWithdrawalAccount()`)
- Collections of entities typically as `List<T>` properties, not separate wrapper classes

## Use Case Rules

Use cases live in `lib/domain/<feature>/use_cases/` and are the **single point** through which the application layer (cubits) accesses business logic and data.

### The Four Contracts

Implement exactly one from `lib/domain/core/use_cases/use_case.dart`:

| Interface | Use when |
|---|---|
| `IUseCase<Output>` | One-shot, no input |
| `IUseCaseWith<Input, Output>` | One-shot, with input |
| `IStreamUseCase<Output>` | Live stream, no input |
| `IStreamUseCaseWith<Input, Output>` | Live stream, with input |

### Naming

| Prefix | Interface |
|---|---|
| `Watch` | `IStreamUseCase` / `IStreamUseCaseWith` |
| `Get` | `IUseCase` / `IUseCaseWith` |
| `Create` / `Update` / `Delete` | `IUseCaseWith` |
| `Set` / `Accept` | `IUseCaseWith` |
| `RefreshDataAfter` | `IUseCaseWith` — orchestrate cache invalidation post-mutation |

### Rules

- Annotate every use case with `@injectable`
- Constructor-inject only repository **interfaces** (`I<Name>Repository`) — never concrete classes
- Use `const` constructor when no mutable state
- Return `Payload<T>` / `StreamPayload<T>` — never throw, never return nullable raw data
- Multi-parameter input: use a named Dart record (`typedef FooInput = ({TypeA a, TypeB b})`)
- Combined streams: inject repos directly, use `combineTwoLatestStreams` / `combineThreeLatestStreams` from `lib/domain/core/streams/wrapper.dart`; apply first-non-success-wins combiner logic
- Composite use cases (mutable state): add `dispose()`, do not use `const` constructor
- Never access UI, BuildContext, or navigation
- Never call other use cases unless acting as a deliberate composite
- Never make network calls directly — that belongs in repositories
