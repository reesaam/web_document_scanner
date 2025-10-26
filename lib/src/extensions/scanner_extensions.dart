import '../models/detection_model.dart';

extension CheckScannerDocument on DetectionModel {
  bool get isFound => originalImageData != null && rect != null;
  DetectionModel clear() => DetectionModel();
}