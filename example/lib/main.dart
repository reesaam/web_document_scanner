import 'package:web_document_scanner/web_document_scanner.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Web Document Scanner',
        home: ScannerPage(),
      );
}

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  /// [Variables] to control and modify settings and functionalities
  ScannerController? scannerController;
  ScannerStatus scannerStatus = ScannerStatus.closed;
  ScannerResponse scannerResponse = ScannerResponse();

  @override
  void initState() {
    /// [ScannerController] should be Initialized Before showing it's widget
    /// [ScannerController] will initialize the Camera
    ///     Initialization procedure includes:
    ///       - Getting Permissions for Camera
    ///       - Variables Assignments (Status, Response, Detection Model, DetectionArguments, ...)
    ///       - Setting Controllers

    _cameraInitialization();

    /// [startAutoScan] of [ScannerController] can be either here to start by page initialization
    /// OR
    /// Use it by an action such as Tapping on a Button

    super.initState();
  }

  void _cameraInitialization() async {
    scannerStatus = ScannerStatus.initializing;
    final List<CameraDescription> cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      final CameraDescription selectedCamera = cameras.first;
      scannerController = ScannerController(description: selectedCamera);
      if (scannerController != null) {
        await scannerController?.initialize();
      } else {
        throw Exception(PackageStrings.throwErrorControllerInitialization);
      }
    } else {
      throw Exception(PackageStrings.throwErrorCameraAvailability);
    }
  }

  /// [AutoScan] can be triggered in many ways
  /// such as page initialization, which trigger [AutoScan] in page start
  /// Or by Tapping on a [Button]
  void startAutoScan() async {
    scannerStatus = ScannerStatus.scanning;
    scannerResponse = await scannerController!.startAutoScan();
  }

  void stopAutoScan() {
    scannerStatus = ScannerStatus.closed;
  }

  @override
  Widget build(BuildContext context) => Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        Text(PackageStrings.packageName),
        WebDocumentScanner(scannerController!),
        Image.memory(scannerResponse.imageData!, fit: BoxFit.contain),
        Image.memory(scannerResponse.croppedData!, fit: BoxFit.contain),
        Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
                onPressed: () => scannerController!.startAutoScan(), child: Text(PackageStrings.startAutoScan)),
            ElevatedButton(
                onPressed: () => scannerController!.stopAutoScan(), child: Text(PackageStrings.stopAutoScan)),
          ],
        )
      ]);
}
