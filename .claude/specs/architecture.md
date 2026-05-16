# Use Cases — Implementation Guide

This document describes how use cases are implemented in the `Channels.Flutter.Components` project. Its purpose is to help a coding agent in another Flutter project update that project's agents, skills, and instructions so the same approach is followed consistently.

---

## Overview

Use cases live in the **domain layer** and are the single point through which the application layer accesses business logic and data. They own the contract between application (Cubits/BLoCs) and infrastructure (repositories), and they may coordinate multiple repositories.

Directory convention: `lib/domain/<feature>/use_cases/<snake_case_name>_use_case.dart`

---

## The Four Interface Contracts

All use cases implement one of four abstract interfaces defined in `lib/domain/core/use_cases/use_case.dart`:

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

Pick the interface that fits:

| Situation | Interface |
|---|---|
| Fetch/mutate, no params | `IUseCase<Output>` |
| Fetch/mutate, with params | `IUseCaseWith<Input, Output>` |
| Live stream, no params | `IStreamUseCase<Output>` |
| Live stream, parameterised | `IStreamUseCaseWith<Input, Output>` |

---

## Return Types

### `Payload<T>` (one-shot)

`Payload<T>` is the return wrapper for `execute()`. It carries either a value or a `Failure`, never throws.

```dart
// Success
return Payload.success(value);

// Success with custom TTL
return Payload.successWithTimeToLive(payload: value, timeToLive: Duration(minutes: 5));

// Failure
return Payload.failure(Failure.exceptionThrown(exception: ex, message: "..."));
return Payload.failure(Failure.serverError(message: "Not found", httpCode: 404));
```

Consumers call `.fold()` to branch on success/failure:

```dart
final Payload<Foo> payload = await myUseCase.execute(input);
payload.fold(
  (Failure failure) { /* handle error */ },
  (Foo value)       { /* happy path   */ },
);
```

### `StreamPayload<T>` (streaming)

`StreamPayload<T>` is a sealed class emitted by `subscribe()`. Its four subtypes signal distinct states:

| Subtype | Meaning |
|---|---|
| `DataDeliveredPayload<T>` | Fresh data arrived |
| `DataRefreshPayload<T>` | Refresh in progress; `currentData` holds the last good value |
| `DataResetPayload<T>` | Stream cleared (e.g., after logout) |
| `DataDeliveryErrorPayload<T>` | Error; `cachedData` holds stale data if available |

Consumers call `.resolve()`:

```dart
payload.resolve(
  onData:        (T data)  { /* render */ },
  onDataRefresh: ()        { /* show spinner but keep current data */ },
  onFailure:     (DataDeliveryErrorPayload<T> p) { /* show error, optionally use p.cachedData */ },
  onDataCleared: ()        { /* optional: reset UI */ },
);
```

---

## Dependency Injection

Every use case is annotated `@injectable` (from the `injectable` package). Dependencies — always repository *interfaces* — are constructor-injected. Use `const` constructors when the class holds no mutable state.

```dart
@injectable
class GetForeignPaymentDetailsUseCase implements IUseCaseWith<int, ForeignPaymentDetails> {
  final ITransferRepository _transferRepository;

  const GetForeignPaymentDetailsUseCase(this._transferRepository);

  @override
  Future<Payload<ForeignPaymentDetails>> execute(int input) {
    return _transferRepository.getForeignPaymentDetails(paymentId: input);
  }
}
```

Rules:
- Inject only interfaces (`I<Name>Repository`), never concrete classes.
- Never inject other use cases unless the class is a **composite use case** (see below).
- `const` constructor if no `late`, `BehaviorSubject`, or mutable fields.

---

## Canonical Patterns

### Pattern 1 — Simple one-shot (thin delegation)

Most `IUseCaseWith` implementations are a single-method delegation:

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

### Pattern 2 — One-shot with error handling

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
      return Payload.failure(Failure.exceptionThrown(exception: ex, message: "Failed to get actor kennitala"));
    }
  }
}
```

### Pattern 3 — Simple stream (single repository)

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

### Pattern 4 — Combined stream (multiple repositories)

When a stream must merge data from several sources, use `combineTwoLatestStreams` / `combineThreeLatestStreams` from `lib/domain/core/streams/wrapper.dart` and write a `_combiner` method.

The combiner iterates the source payloads in priority order — the first non-success state wins. Only return `StreamPayload.success(combined)` when all sources delivered successfully.

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
    // Build the combined value using best-available data regardless of state
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
          continue; // check next source
      }
    }

    return StreamPayload.success(summary); // all sources delivered
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

### Pattern 5 — Multi-input params (record types)

When `execute` needs more than one parameter, use a Dart record as `Input`:

```dart
// Type alias defined inline or in a shared types file
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

---

## Composite and Orchestrating Use Cases

Some use cases coordinate several repositories or other use cases and may carry mutable state (subscriptions, subjects). These are the exception, not the rule.

Guidelines when a use case needs to own mutable state:
- Add a `dispose()` method that cancels subscriptions and closes `BehaviorSubject`s.
- The cubit/BLoC that owns the use case is responsible for calling `dispose()`.
- Use `BehaviorSubject` (from `rxdart`) only when bridging a non-stream data source into a `subscribe()` stream.
- Do not use `const` constructor.

---

## What Use Cases Must NOT Do

- Access Flutter widgets, BuildContext, or navigation directly.
- Contain UI state or formatting logic.
- Call other use cases unless acting as a deliberate composite (and this should be rare — prefer composing at the cubit level).
- Make network calls directly — that belongs in repositories.
- Throw exceptions — catch them and return `Payload.failure(...)`.

---

## File Layout Reference

```
lib/
  domain/
    core/
      use_cases/
        use_case.dart            ← the four interfaces
    <feature>/
      use_cases/
        get_<name>_use_case.dart
        watch_<name>_use_case.dart
        create_<name>_use_case.dart
        ...
```

---

## Checklist for a New Use Case

1. Choose the right interface (`IUseCase`, `IUseCaseWith`, `IStreamUseCase`, `IStreamUseCaseWith`).
2. Name the file and class with the correct verb prefix.
3. Add `@injectable`.
4. Constructor-inject only repository interfaces; use `const` if no mutable state.
5. Return `Payload.success` / `Payload.failure` — never throw.
6. For streams: implement all three methods (`subscribe`, `refresh`, `reload`).
7. For combined streams: use the combiner helper + iterate-and-check pattern.
8. No UI logic, no direct network calls, no concrete repository types.
