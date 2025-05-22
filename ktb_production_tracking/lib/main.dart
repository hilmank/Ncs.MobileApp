import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:flutter/foundation.dart'; // kIsWeb, defaultTargetPlatform

import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ ONLY run this on desktop (not mobile, not web)
  if (!kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.windows ||
          defaultTargetPlatform == TargetPlatform.macOS ||
          defaultTargetPlatform == TargetPlatform.linux)) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  await initializeDateFormatting('id_ID', null);

  runApp(const ProviderScope(child: App()));
}
