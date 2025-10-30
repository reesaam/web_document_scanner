import 'package:flutter/material.dart';
import '../resources/package_defaults.dart';

debugLog(String log, {bool disabled = false}) =>
    disabled == true && PackageDefaults.printDebugLogs != true ? null : debugPrint(log);

releaseLog(String log, {bool disabled = false}) =>
    disabled == true && PackageDefaults.printReleaseLogs != true ? null : print(log);
