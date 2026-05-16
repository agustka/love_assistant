# Skill: use-case-generation

## Purpose

Use cases are domain-layer orchestrators. They coordinate repositories and domain logic to fulfill a single business intent. They are injectable and return results through domain wrappers (`Payload`, `StreamPayload`).

---

## File Location

```
lib/domain/<feature>/use_cases/<verb>_<intent>_use_case.dart
```

---

## The Four Contracts

Every use case implements exactly one contract from `lib/domain/core/use_cases/use_case.dart`:

```dart
// One-shot, no input
abstract interface class IUseCase<Output> {
  Future<Payload<Output>> execute();
}

// One-shot, with input
abstract interface class IUseCaseWith<Input, Output> {
  Future<Payload<Output>> execute(Input input);
}

// Streaming, no input
abstract interface class IStreamUseCase<Output> {
  Stream<StreamPayload<Output>> subscribe();
  Future<void> reload();
  Future<void> refresh({required bool forceGet});
}

// Streaming, with input
abstract interface class IStreamUseCaseWith<Input, Output> {
  Stream<StreamPayload<Output>> subscribe(Input input);
  Future<void> reload();
  Future<void> refresh({required bool forceGet});
}
```

| Situation | Interface |
|---|---|
| Fetch/mutate, no params | `IUseCase<Output>` |
| Fetch/mutate, with params | `IUseCaseWith<Input, Output>` |
| Live stream, no params | `IStreamUseCase<Output>` |
| Live stream, parameterised | `IStreamUseCaseWith<Input, Output>` |

---

## Pattern 1 — Simple one-shot (thin delegation)

Most `IUseCaseWith` implementations are a single-method delegation. No try/catch needed when the repository already returns `Payload`:

```dart
@injectable
class DeleteKnownForeignRecipientUseCase implements IUseCaseWith<IntIdValueObject, void> {
  final IKnownForeignRecipientsRepository _repo;

  const DeleteKnownForeignRecipientUseCase(this._repo);

  @override
  Future<Payload<void>> execute(IntIdValueObject input) {
    return _repo.deleteForeignRecipient(id: input.get);
  }
}
```

---

## Pattern 2 — One-shot with error handling

When the use case must catch exceptions or add logic around the repository call, wrap in `try/catch` and use `err()` from `ErrorHandler`:

```dart
@injectable
class GetActorKennitalaUseCase implements IUseCase<KennitalaValueObject> {
  final IAuthRepository _authRepository;

  GetActorKennitalaUseCase(this._authRepository);

  @override
  Future<Payload<KennitalaValueObject>> execute() async {
    try {
      final KennitalaValueObject result = await _authRepository.getActorKennitala();
      return Payload.success(result);
    } catch (ex) {
      err(ex, location: "GetActorKennitalaUseCase.execute");
      return Payload.failure(Failure("Failed to get actor kennitala"));
    }
  }
}
```

---

## Pattern 3 — Simple stream (single repository)

```dart
@injectable
class WatchAccountsUseCase implements IStreamUseCase<AccountsV2> {
  final IAccountsRepositoryV2 _repo;

  const WatchAccountsUseCase(this._repo);

  @override
  Stream<StreamPayload<AccountsV2>> subscribe() => _repo.subscribe();

  @override
  Future<void> refresh({required bool forceGet}) => _repo.refresh(forceGet: forceGet);

  @override
  Future<void> reload() => _repo.reload();
}
```

---

## Pattern 4 — Combined stream (multiple repositories)

Inject repositories directly — **not** other use cases. Use `combineTwoLatestStreams` or `combineThreeLatestStreams` from `lib/domain/core/streams/wrapper.dart`. Write a `_combiner` method that iterates payloads in priority order — **first non-success state wins**. Only return `StreamPayload.success(combined)` when all sources delivered successfully.

```dart
@injectable
class WatchLoyaltyPointsSummaryUseCase implements IStreamUseCase<LoyaltyPointsSummary> {
  final ILoyaltyPointsRepository _pointsRepo;
  final ILoyaltyScoreRepository _scoreRepo;

  const WatchLoyaltyPointsSummaryUseCase(this._pointsRepo, this._scoreRepo);

  @override
  Stream<StreamPayload<LoyaltyPointsSummary>> subscribe() {
    return combineTwoLatestStreams(
      streamA: _scoreRepo.subscribe(),
      streamB: _pointsRepo.subscribe(),
      combiner: _combiner,
    );
  }

  StreamPayload<LoyaltyPointsSummary> _combiner(
    StreamPayload<LoyaltyScore> scorePayload,
    StreamPayload<LoyaltyPoints> pointsPayload,
  ) {
    // Build combined value using best-available data regardless of state
    final LoyaltyScore score = scorePayload.dataOrNull ?? const LoyaltyScore.invalid();
    final LoyaltyPoints points = pointsPayload.dataOrNull ?? const LoyaltyPoints.invalid();
    final LoyaltyPointsSummary summary = LoyaltyPointsSummary(score: score, points: points);

    // First non-success state wins
    for (final StreamPayload payload in [scorePayload, pointsPayload]) {
      switch (payload) {
        case DataRefreshPayload():
          return StreamPayload.refresh(summary);
        case DataResetPayload():
          return StreamPayload.reset();
        case final DataDeliveryErrorPayload errorPayload:
          return StreamPayload.failure(errorPayload.failure, fallback: summary);
        case DataDeliveredPayload():
          continue;
      }
    }

    return StreamPayload.success(summary);
  }

  @override
  Future<void> refresh({required bool forceGet}) => Future.wait([
    _pointsRepo.refresh(forceGet: forceGet),
    _scoreRepo.refresh(forceGet: forceGet),
  ]);

  @override
  Future<void> reload() => Future.wait([
    _pointsRepo.reload(),
    _scoreRepo.reload(),
  ]);
}
```

---

## Pattern 5 — Multi-input params (record types)

When `execute` needs more than one parameter, use a Dart record as `Input`:

```dart
typedef GetLoanInput = ({int loanId, bool forceGet});

@injectable
class GetLoanUseCase implements IUseCaseWith<GetLoanInput, Loan> {
  final ILoansRepository _repo;

  const GetLoanUseCase(this._repo);

  @override
  Future<Payload<Loan>> execute(GetLoanInput input) {
    return _repo.getLoan(loanId: input.loanId, forceGet: input.forceGet);
  }
}

// Call site:
final payload = await _getLoanUseCase.execute((loanId: loanId, forceGet: forceGet));
```

---

## Naming Conventions

| Prefix | Meaning | Interface |
|---|---|---|
| `Watch` | Live stream | `IStreamUseCase` / `IStreamUseCaseWith` |
| `Get` | Single fetch (read) | `IUseCase` / `IUseCaseWith` |
| `Create` | POST / create | `IUseCaseWith` |
| `Update` | PUT / update | `IUseCaseWith` |
| `Delete` | DELETE | `IUseCaseWith` |
| `Set` | Write a preference/config | `IUseCaseWith` |
| `Accept` | Accept terms / confirm action | `IUseCaseWith` |
| `RefreshDataAfter` | Orchestrate cache invalidation post-mutation | `IUseCaseWith` |

The verb expresses **business intent**, not implementation details.

---

## Input Modeling

| Scenario | Input type |
|---|---|
| Single primitive | Pass directly: `IUseCaseWith<bool, Output>` |
| Multiple parameters | Named Dart record: `IUseCaseWith<({TypeA a, TypeB b}), Output>` |
| No input | Use `IUseCase<Output>` or `IStreamUseCase<Output>` |

---

## Composite Use Cases (exception, not the rule)

Some use cases coordinate several repositories or other use cases and carry mutable state (subscriptions, subjects). When a use case needs to own mutable state:

- Add a `dispose()` method that cancels subscriptions and closes `BehaviorSubject`s.
- The cubit/BLoC that owns the use case is responsible for calling `dispose()`.
- Use `BehaviorSubject` (from `rxdart`) only when bridging a non-stream data source into a `subscribe()` stream.
- Do **not** use `const` constructor.
- Never inject other use cases unless the class is a deliberate composite — prefer composing at the cubit level.

---

## Structural Rules

| Rule | Detail |
|---|---|
| `@injectable` | Always — DI registration via get_it/injectable |
| Single contract | Implement exactly one of the four interfaces |
| Constructor injection | Dependencies via constructor — never `getIt<T>()` inside the body |
| Repository interfaces only | Inject `I<Name>Repository`, never concrete classes |
| `const` constructor | Use when no mutable state (no `late`, `BehaviorSubject`, or subscriptions) |
| Domain types only | Accept and return entities, value objects, `Payload<T>`, `StreamPayload<T>` |
| No infrastructure leakage | Never expose models, HTTP responses, or raw JSON |
| Never throw | Catch exceptions and return `Payload.failure(...)` |

---

## Checklist for a New Use Case

1. Choose the right interface (`IUseCase`, `IUseCaseWith`, `IStreamUseCase`, `IStreamUseCaseWith`).
2. Name the file and class with the correct verb prefix.
3. Add `@injectable`.
4. Constructor-inject only repository interfaces; use `const` if no mutable state.
5. Return `Payload.success` / `Payload.failure` — never throw.
6. For streams: implement all three methods (`subscribe`, `refresh`, `reload`).
7. For combined streams: inject repos directly, use `combineTwoLatestStreams`/`combineThreeLatestStreams`, apply first-non-success-wins combiner.
8. No UI logic, no direct network calls, no concrete repository types.

---

## Comment Discipline

- Use case files must be lean and self-documenting.
- Do not add method/property/function doc comments (`///`).
- Do not add section headers, banner comments, or obvious explanatory inline comments.
- Use comments only for rare, non-obvious business rationale that cannot be expressed via naming.

---

## What NOT to Do

- Do not implement more than one contract interface
- Do not inject other use cases in a combined stream — inject repositories directly
- Do not use `combineLatestStreams` — use `combineTwoLatestStreams` or `combineThreeLatestStreams`
- Do not introduce UI or state management concerns (cubits, widgets)
- Do not instantiate dependencies — inject via constructor
- Do not return raw `Future<T>` or nullable data — use `Payload<T>` / `StreamPayload<T>`
- Do not expose infrastructure models through use case interfaces
- Do not use `Get*UseCase` naming for stream-based use cases — use `Watch*`
- Do not use `Map` or `dynamic` bundles as input — use records or value objects
- Do not add mutable flags that change behavior across calls
- Do not duplicate validation logic — extract to shared domain validators and compose
- Do not enforce screen-flow required-field checks in persistence use cases — those belong in cubits
