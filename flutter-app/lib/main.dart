import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'firebase_options.dart';
import 'features/api/api.dart';
import 'features/vocabulary/bloc/vocabulary_bloc.dart';
import 'features/vocabulary/view/vocabulary_screen.dart';

// Service Locator Definition
final sl = GetIt.instance;

Future<void> setupDependencyInjection() async {
  // Blocs
  sl.registerFactory(
    () => VocabularyBloc(
      apiService: sl(),
      firestore: sl(),
    ),
  );

  // Services
  sl.registerLazySingleton(() => ApiService(sl()));

  // External Clients
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Setup DI locator
  await setupDependencyInjection();
  
  // Initialize Firebase
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase initialization warning: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LingoBreeze - My Vocabulary',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1), // Premium Indigo
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),
          brightness: Brightness.dark,
        ),
      ),
      themeMode: ThemeMode.system, // Fully responsive system theme mode
      home: const VocabularyScreen(),
    );
  }
}
