import 'package:rxdart/rxdart.dart';

Stream<R> combineTwoLatestStreams<A, B, R>({
  required Stream<A> streamA,
  required Stream<B> streamB,
  required R Function(A a, B b) combiner,
}) {
  return CombineLatestStream.combine2(
    streamA,
    streamB,
    combiner,
  );
}

Stream<R> combineThreeLatestStreams<A, B, C, R>({
  required Stream<A> streamA,
  required Stream<B> streamB,
  required Stream<C> streamC,
  required R Function(A a, B b, C c) combiner,
}) {
  return CombineLatestStream.combine3(
    streamA,
    streamB,
    streamC,
    combiner,
  );
}

Stream<R> combineFourLatestStreams<A, B, C, D, R>({
  required Stream<A> streamA,
  required Stream<B> streamB,
  required Stream<C> streamC,
  required Stream<D> streamD,
  required R Function(A a, B b, C c, D d) combiner,
}) {
  return CombineLatestStream.combine4(
    streamA,
    streamB,
    streamC,
    streamD,
    combiner,
  );
}
