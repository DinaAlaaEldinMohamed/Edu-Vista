import 'package:edu_vista/cubit/auth_cubit.dart';
import 'package:edu_vista/firebase_options.dart';
import 'package:edu_vista/screens/splash_screen.dart';
import 'package:edu_vista/services/pref.service.dart';
import 'package:edu_vista/utils/app_routes.dart';
import 'package:edu_vista/utils/colors-utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  PreferncesService.init();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print('Failed to initialize Firebase: $e');
  }
  runApp(MultiBlocProvider(
    providers: [BlocProvider(create: (ctx) => AuthCubit())],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Edu Vista',
      theme: ThemeData(
        fontFamily: "PlusJakartaSans",
        colorScheme: ColorScheme.fromSeed(seedColor: ColorUtility.primaryColor),
        scaffoldBackgroundColor: ColorUtility.pageBackgroundColor,
        useMaterial3: true,
      ),
      onGenerateRoute: AppRouter.generateRoute,
      initialRoute: SplashScreen.route,
    );
  }
}
