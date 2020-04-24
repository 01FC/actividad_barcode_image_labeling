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
          data = await _barcodeScan(img);
        } else {
          // image labeling
          data = await _imgLabeling(img);
        }
        yield Results(result: data, chosenImage: img);
      }
    }
  }

  Future<String> _barcodeScan(File imageFile) async {
    var visionImage = FirebaseVisionImage.fromFile(imageFile);
    var barcodeDetector = FirebaseVision.instance.barcodeDetector();
    List<Barcode> codes = await barcodeDetector.detectInImage(visionImage);

    String data = "";
    for (var item in codes) {
      var code = item.rawValue;
      var type = item.valueType;
      var boundBx = item.boundingBox;
      var corners = item.cornerPoints;
      var url = item.url;

      data += ''' 
      > Codigo: $code\n
      > Formato: $type\n
      > URL titulo: ${url == null ? "No disponible" : url.title}\n
      > URL: ${url == null ? "No disponible" : url.url}\n
      > Area de cod: $boundBx\n
      > Esquinas: $corners\n
      --------------------\n
      ''';
    }

    return data;
  }

  Future<String> _imgLabeling(File imageFile) async {
    var visionImage = FirebaseVisionImage.fromFile(imageFile);
    var labelDetector = FirebaseVision.instance.imageLabeler();
    List<ImageLabel> labels = await labelDetector.processImage(visionImage);

    String data = "";
    for (var item in labels) {
      String id = item.entityId;
      String label = item.text;
      double prob = item.confidence;

      data += ''' 
      > Id: $id\n
      > Label: $label\n
      > Certeza: $prob\n
      --------------------\n
      ''';
    }

    return data;
  }

  Future<File> _chooseImage() async {
    return await ImagePicker.pickImage(
      source: ImageSource.camera,
      maxHeight: 720,
      maxWidth: 720,
    );
  }
}
