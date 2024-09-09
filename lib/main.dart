import 'package:device_preview/device_preview.dart';
import 'package:edu_vista/blocs/cart/cart_bloc.dart';
import 'package:edu_vista/blocs/course/course_bloc.dart';
import 'package:edu_vista/blocs/course_options/course_options_bloc.dart';
import 'package:edu_vista/blocs/lecture/lecture_bloc.dart';
import 'package:edu_vista/cubit/auth_cubit.dart';
import 'package:edu_vista/firebase_options.dart';
import 'package:edu_vista/screens/splash_screen.dart';
import 'package:edu_vista/services/pref.service.dart';
import 'package:edu_vista/utils/app_routes.dart';
import 'package:edu_vista/utils/colors_utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  PreferncesService.init();
  await dotenv.load(fileName: ".env");
  try {
    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await FlutterDownloader.initialize();
  } catch (e) {
    print('Failed to initialize services: $e');
  }

  runApp(DevicePreview(
    enabled: !kReleaseMode,
    builder: (context) {
      return MultiBlocProvider(
        providers: [
          BlocProvider(create: (ctx) => AuthCubit()),
          BlocProvider(create: (ctx) => CourseBloc()),
          BlocProvider(create: (ctx) => LectureBloc()),
          BlocProvider(create: (ctx) => CartBloc()),
          BlocProvider(create: (ctx) => CourseOptionsBloc()),
        ],
        child: const MyApp(),
      );
    },
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Edu Vista',
          theme: ThemeData(
            fontFamily: "PlusJakartaSans",
            colorScheme:
                ColorScheme.fromSeed(seedColor: ColorUtility.primaryColor),
            scaffoldBackgroundColor: ColorUtility.pageBackgroundColor,
            useMaterial3: true,
          ),
          onGenerateRoute: AppRouter.generateRoute,
          initialRoute: SplashScreen.route,
        );
      },
    );
  }
}
