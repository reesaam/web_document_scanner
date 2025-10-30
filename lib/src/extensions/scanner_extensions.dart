import 'package:flutter/material.dart';
import '../models/detection_model.dart';

/// [extensions] related to [Scanner] and [DetectionModel] functionalities

extension CheckScannerDocument on DetectionModel {
  bool get isFound => originalImageData != null && rect != Rect.zero;
  DetectionModel clear() => DetectionModel();
}