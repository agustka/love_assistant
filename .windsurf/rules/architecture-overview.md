# Flutter Clean Architecture Rules

These rules guide every Windsurf agent suggestion in this repository.

## Layered Overview
| Layer | Responsibility                                                           | Key Tech |
|-------|--------------------------------------------------------------------------|---------|
| UI | Atomic Design widgets (atoms → molecules → organisms → templates → pages) | Flutter widgets |
| Application | Business orchestration                                                   | BLoC – Cubit |
| Repository | Cache & adapt external data                                              | Hive · RxDart |
| Model | External‑API DTOs                                                        | json_serializable |
| Service | External I/O                                                             | Chopper · Plugins |

---

## Dependency Injection
- Annotate every concrete class with `@injectable` and bind it to an interface.
- Resolve dependencies solely 1) through **GetIt**, 2) Constructor parameters - `new` is forbidden outside generated code

## State Management
- Cubits emit immutable states; UI observes via `BlocBuilder`.

## Reactive Streams
- Expose data as **`BehaviorSubject<T>`**; provide one hot stream per entity type.
- UI never pulls—always subscribes.

## Caching
- Repositories persist entities in **Hive** boxes.
- Streams emit cached value immediately, then update on fresh data.

## Testing Strategy
| Scope | Approach |
|-------|----------|
| Domain | BDD‑style tests with builder pattern and offline service implementations; no mocks required |
| Acceptance | Boundary‑controlled end‑to‑end tests |

## Always / Never
**Always**
- Value Objects for validation
- Strict null‑safety throughout
- Extract constants for literals

**Never**
- `setState()` in complex widgets
- Magic numbers/strings in code
- Direct HTTP without Chopper

---