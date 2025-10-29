import 'package:flutter/material.dart';

debugLog(String log, {bool disabled = false}) => disabled == true ? null : debugPrint(log);
releaseLog(String log, {bool disabled = false}) => disabled == true ? null : print(log);
