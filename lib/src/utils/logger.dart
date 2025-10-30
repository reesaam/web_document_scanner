import 'package:flutter/material.dart';
import '../resources/package_defaults.dart';
import '../resources/resources.dart';

debugLog(String log, {bool disabled = false}) =>
    disabled == true && PackageDefaults.printDebugLogs != true ? null : debugPrint('${PackageStrings.debugLog}  $log');

releaseLog(String log, {bool disabled = false}) =>
    disabled == true && PackageDefaults.printReleaseLogs != true ? null : print('${PackageStrings.releaseLog}  $log');
