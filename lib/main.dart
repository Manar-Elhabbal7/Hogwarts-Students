import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:student_system/features/auth/cubit/auth_cubit.dart';
import 'package:student_system/features/auth/cubit/auth_state.dart';
import 'package:student_system/features/auth/ui/login_screen.dart';
import 'package:student_system/features/students/ui/students_screen.dart';
import 'package:student_system/features/students/cubit/home_cubit.dart';
import 'package:student_system/core/theme/app_colors.dart';
import 'package:student_system/core/theme/app_text_styles.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase initialization failed: $e');
  }
  runApp(const HogwartStudents());
}

class HogwartStudents extends StatelessWidget {
  const HogwartStudents({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (context) => AuthCubit(),
        ),
        BlocProvider<HomeCubit>(
          create: (context) => HomeCubit()..watchStudents(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Hogwarts Student Manager',
        theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: AppColors.primary,
          scaffoldBackgroundColor: AppColors.background,
          colorScheme: const ColorScheme.dark(
            primary: AppColors.primary,
            secondary: AppColors.accent,
            surface: AppColors.surface,
            onPrimary: Colors.white,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.background,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.white),
          ),
          textTheme: const TextTheme(
            headlineMedium: AppTextStyles.titlePrimary,
            titleMedium: AppTextStyles.bodyRegular,
            bodyMedium: AppTextStyles.bodyMedium,
          ),
        ),
        home: const AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is Authenticated) {
          return const Home();
        } else if (state is AuthLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
