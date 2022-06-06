import 'package:flutter/material.dart';

class Settings {

  ValueNotifier<Locale> language = new ValueNotifier(Locale('en', ''));

  ValueNotifier<Brightness> brightness = new ValueNotifier(Brightness.dark);

  Settings();

}