import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:noveru/sharedPreferencesInstance.dart';
import 'package:noveru/src/app.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesInstance.initialize();
  runApp(
    const ProviderScope(
      child: MyApp()
    )
  );
}