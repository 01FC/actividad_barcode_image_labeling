import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  @override
  HomeState get initialState => HomeInitial();

  @override
  Stream<HomeState> mapEventToState(
    HomeEvent event,
  ) async* {
    if (event is ScanPicture) {
      File img = await _chooseImage();
      if (img == null)
        yield Error();
      else {
        String data = "";
        if (event.barcodeScan) {
          // barcode scanner

        } else {
          // image labeling

        }
        yield Results(result: data, chosenImage: img);
      }
    }
  }

  Future<File> _chooseImage() async {
    return await ImagePicker.pickImage(
      source: ImageSource.camera,
      maxHeight: 720,
      maxWidth: 720,
    );
  }
}
