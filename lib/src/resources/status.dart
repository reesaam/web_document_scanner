enum ScannerStatus {
  initializing,
  cameraInitializing,
  initialized,
  scanning,
  scanned(),
  disposing(dispose: true),
  closed(dispose: true),
  unknown,
  error(dispose: true);

  final bool? dispose;
  const ScannerStatus({this.dispose});
}