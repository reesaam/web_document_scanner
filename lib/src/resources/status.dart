enum ScannerStatus {
  initializing,
  initialized,
  scanning,
  scanned(dispose: true),
  closed(dispose: true),
  unknown,
  error(dispose: true);

  final bool? dispose;
  const ScannerStatus({this.dispose});
}