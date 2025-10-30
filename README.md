
<p align="center">
  Getx Dependencies Binding Annotation Generator
</p>
<p align="center">
  <!-- Pub Version -->
  <a href="https://pub.dev/packages/web_document_scanner"><img src="https://img.shields.io/pub/v/web_document_scanner?logo=dart" alt="PubVersion"></a>
  <!-- Pub Points} -->
  <a href="https://pub.dev/packages/web_document_scanner"><img src="https://img.shields.io/pub/points/web_document_scanner?logo=dart" alt="PubPoints"></a>
  <!-- GitHub Repo -->
  <a href="https://github.com/reesaam/web_document_scanner"><img src="https://img.shields.io/badge/repo-Web_Document_Scanner-yellowgreen?logo=github" alt="build"></a>
  <!-- GitHub Stars -->
  <a href="https://github.com/reesaam/web_document_scanner"><img src="https://img.shields.io/github/stars/felangel/bloc.svg?style=flat&logo=github&colorB=deeppink&label=stars" alt="Star on Github"></a>
  <!-- DartDoc -->
  <a href="https://pub.dev/documentation/web_document_scanner/latest"><img src="https://img.shields.io/badge/dartdocs-latest-blue.svg" alt="Latest Dartdocs"></a>
</p>
<p align="center">
  <a href="https://github.com/reesaam/web_document_scanner"><img src="https://img.shields.io/badge/Web-black" alt="ios"></a>

</p>

A Flutter Package to Scan Document on WEB.

### Contents:
* [Getting Started](#Getting-Started)
* [Usage](#Usage)
* [Options](#Options)
* [Docs](#Docs)
* [About Author](#About-Author)
* [Packages and Dependencies](#Packages-and-Dependencies)
* [Testing](#Testing)

## Getting Started

Add dependencies in the `pubspec.yaml`:
```yaml
dependencies:
  web_document_scanner: ^latest
```

Get the Changes by:
```shell
flutter pub get
```
or
```shell
dart pub get
```

## Usage

```dart
import 'package:web_document_scanner/web_document_scanner.dart';
```

`Controller` must be initialized:
```dart
  void _controllerInitialization() async {
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
```

`Controller` Can be Initialized in page initialization OR triggered by a trigger such as tapping on a Button:
```dart
  void onInit() {
  _controllerInitialization();
  super.initState();
}
```
OR
```dart
Button(onPressed: () => _controllerInitialization(), child: Text('Controller Initialization'));
```

> **_NOTE:_**
> In either way, `Controller` must be initialized before having `Scanner` Widget.

Using Scanner Widget in your Screen:
```dart
WebDocumentScanner(scannerController!);
```

Controller will return the Captured Document:
```dart
ScannerResponse scannerResponse = await scannerController!.startAutoScan();
```

The `Status` of the `Scanner` can be controlled by setting the `ScannerStatus` of the `Controller`:
```dart
ScannerStatus scannerStatus = ScannerStatus.scanning;
```

### You can check the `/example` for a more complete example, more details and further information.

## Docs
<a href="https://github.com/reesaam/web_document_scanner/tree/main/generator/doc/api"><img src="https://img.shields.io/badge/GitHub-Docs_Repository-important?logo=github" alt="build"></a>

## About Author

### Resam Taghipour
<a href="https://www.resam.site"><img src="https://img.shields.io/badge/Website-resam.site-blue" alt="Pub"></a>
<a href="https://github.com/reesaam"><img src="https://img.shields.io/badge/GitHub-reesaam-black?style=flat&logo=github&link=https%3A%2F%2Fgithub.com%2Freesaam" alt="account"></a>
<a href="https://www.linkedin.com/in/resam"><img src="https://img.shields.io/badge/LinkedIn-resam-blue?logo=linkedin" alt="Pub"></a>
<a><img src="https://img.shields.io/badge/Email-resam@resam.site-important?logo=maildotru" alt="Pub"></a>


## Packages and Dependencies
<a href="https://dart.dev"><img src="https://img.shields.io/badge/Dart-red?logo=dart" alt="Pub"></a>
<a href="https://flutter.dev"><img src="https://img.shields.io/badge/Flutter-blue?logo=flutter" alt="Pub"></a>
<a href="https://pub.dev/packages/get"><img src="https://img.shields.io/badge/pub-GetX-blue?logo=dart" alt="Pub"></a>
<a href="https://pub.dev/packages/build_runner"><img src="https://img.shields.io/badge/pub-BuildRunner-red?logo=dart" alt="Pub"></a>
<a href="https://pub.dev/packages/dartdoc"><img src="https://img.shields.io/badge/pub-DartDoc-red?logo=dart" alt="Pub"></a>

## License
This project is licensed under the '**BSD-3-Clause**' License - see the LICENSE for details.

<a href="https://pub.dev/packages/web_document_scanner/license"><img src="https://img.shields.io/badge/LICENSE-blue" alt="Pub"></a>