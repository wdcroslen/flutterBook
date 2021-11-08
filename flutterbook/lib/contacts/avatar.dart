import 'package:flutter/material.dart';
import 'package:flutterbook/notes/notes.dart';
import 'package:flutterbook/tasks/tasks.dart';
import 'package:flutterbook/appointments/appointments.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart';

mixin Avatar {
  static Directory docsDir = Directory('');

  File avatarTempFile() {
    return File(avatarTempFileName());
  }

  String avatarTempFileName() {
    return join(docsDir.path, "avatar");
  }

  String avatarFileName(int id) {
    return join(docsDir.path, id.toString());
  }
}
