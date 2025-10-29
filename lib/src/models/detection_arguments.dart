class DetectionArguments {
  const DetectionArguments({
    this.streamCaptureDelay = getDefaultStreamCaptureDelay,
    this.luminanceLimit = getDefaultLuminanceLimit,
    this.fillRatioMin = getDefaultFillRatioMin,
    this.fillRatioMax = getDefaultFillRatioMax,
    this.aspectRatioMin = getDefaultAspectRatioMin,
    this.aspectRatioMax = getDefaultAspectRatioMax,
    this.whiteAreaMin = getDefaultWhiteAreaMin,
    this.whiteAreaMax = getDefaultWhiteAreaMax,
  });

  final int streamCaptureDelay;
  final int luminanceLimit;
  final int fillRatioMin;
  final int fillRatioMax;
  final int aspectRatioMin;
  final int aspectRatioMax;
  final int whiteAreaMin;
  final int whiteAreaMax;
}

const int getDefaultStreamCaptureDelay = 1;
const int getDefaultLuminanceLimit = 200;
const int getDefaultFillRatioMin = 40;
const int getDefaultFillRatioMax = 90;
const int getDefaultAspectRatioMin = 60;
const int getDefaultAspectRatioMax = 150;
const int getDefaultWhiteAreaMin = 100;
const int getDefaultWhiteAreaMax = 1000000;
