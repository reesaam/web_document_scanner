import 'dart:ui';

class DetectionDocumentDetail {
  const DetectionDocumentDetail({
    this.size,
    this.docSize,
    this.docArea,
    this.imageArea,
    this.fillRatio,
    this.aspectRatio,
    this.whiteArea,
    this.imageDimensionString,
    this.docDimensionString,
  });
  final Size? size;
  final Size? docSize;
  final int? docArea;
  final int? imageArea;
  final int? fillRatio;
  final int? aspectRatio;
  final int? whiteArea;
  final String? imageDimensionString;
  final String? docDimensionString;

  DetectionDocumentDetail copyWith({
    Size? size,
    Size? docSize,
    int? docArea,
    int? imageArea,
    int? fillRatio,
    int? aspectRatio,
    int? whiteArea,
    String? imageDimensionString,
    String? docDimensionString,
  }) => DetectionDocumentDetail(
    size: size ?? this.size,
    docSize: docSize ?? this.docSize,
    docArea: docArea ?? this.docArea,
    imageArea: imageArea ?? this.imageArea,
    fillRatio: fillRatio ?? this.fillRatio,
    aspectRatio: aspectRatio ?? this.aspectRatio,
    whiteArea: whiteArea ?? this.whiteArea,
    imageDimensionString: imageDimensionString ?? this.imageDimensionString,
    docDimensionString: docDimensionString ?? this.docDimensionString,
  );
}
