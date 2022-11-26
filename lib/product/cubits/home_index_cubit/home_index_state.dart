part of 'home_index_cubit.dart';

@immutable
abstract class HomeIndexState {
  final int counter;
  const HomeIndexState(this.counter);
}

class HomeIndexInitial extends HomeIndexState {
  const HomeIndexInitial(int sayac) : super(sayac);
}
