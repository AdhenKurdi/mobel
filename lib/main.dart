import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app/routes/app_pages.dart';
import 'di.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  di.init();

    await Supabase.initialize(
    url: 'https://jjcrlrbudwjzgkkhfjhv.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImpqY3JscmJ1ZHdqemdra2hmamh2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTc4Nzg2MTYsImV4cCI6MjAxMzQ1NDYxNn0.-UOMndqgVgvR_JCX2qBNP1g--Tw9KrNhh8NNuKs2GUk',
  );

  runApp(
    
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Telur",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      theme: ThemeData(
        textTheme:  GoogleFonts.poppinsTextTheme().apply(bodyColor: Colors.black),
        // Menggunakan 'Poppins' sebagai jenis huruf utama
      ),
    ),
  );
}
