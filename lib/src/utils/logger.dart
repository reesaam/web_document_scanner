import 'package:flutter/material.dart';
import 'package_defaults.dart';

debugLog(String log, {bool disabled = false}) =>
    disabled == true && PackageDefaults.printLogs != true ? null : debugPrint(log);

releaseLog(String log, {bool disabled = false}) =>
    disabled == true && PackageDefaults.printLogs != true ? null : print(log);
