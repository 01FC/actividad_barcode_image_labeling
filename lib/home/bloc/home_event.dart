part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
}

class ScanPicture extends HomeEvent {
  final bool barcodeScan;

  ScanPicture({@required this.barcodeScan});
  @override
  List<Object> get props => [barcodeScan];
}
