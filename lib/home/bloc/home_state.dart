part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();
}

class HomeInitial extends HomeState {
  @override
  List<Object> get props => [];
}

class Error extends HomeState {
  @override
  List<Object> get props => [];
}

class Results extends HomeState {
  final String result;
  final File chosenImage;

  Results({
    @required this.result,
    @required this.chosenImage,
  });
  @override
  List<Object> get props => [result, chosenImage];
}
