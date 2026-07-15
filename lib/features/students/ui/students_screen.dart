import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_system/core/theme/app_colors.dart';
import 'package:student_system/core/theme/app_text_styles.dart';
import 'package:student_system/features/auth/cubit/auth_cubit.dart';
import 'package:student_system/features/students/cubit/home_cubit.dart';
import 'package:student_system/features/students/cubit/home_state.dart';
import 'package:student_system/features/students/ui/add_student_screen.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomeContent();
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  Widget _buildStudentList(List<Map<String, dynamic>> students) {
    if (students.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.school,
                size: 80,
                color: AppColors.accent,
              ),
              const SizedBox(height: 16),
              const Text(
                'No Students Enrolled Yet',
                style: AppTextStyles.titleSecondary,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Tap the "+" button below to enroll a new student to Hogwarts.',
                style: AppTextStyles.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      itemCount: students.length,
      itemBuilder: (context, index) {
        final student = students[index];
        final house = student['house'] ?? 'Unknown';
        Color houseColor;
        switch (house) {
          case 'Gryffindor': houseColor = const Color(0xFFFF3E56); break; // Scarlet Red
          case 'Hufflepuff': houseColor = const Color(0xFFFFC529); break; // Amber Gold
          case 'Ravenclaw': houseColor = const Color(0xFF3399FF); break;  // Sapphire Blue
          case 'Slytherin': houseColor = const Color(0xFF2ECC71); break;  // Emerald Green
          default: houseColor = AppColors.primary;
        }

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: houseColor.withAlpha(100), width: 1),
          ),
          color: AppColors.surface,
          elevation: 4,
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: CircleAvatar(
              backgroundColor: houseColor.withAlpha(50),
              child: Icon(Icons.person, color: houseColor),
            ),
            title: Text(
              student['name'],
              style: AppTextStyles.bodyRegular.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  'Age: ${student['age']}',
                  style: AppTextStyles.bodyMedium,
                ),
                Text(
                  'House: $house',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: houseColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            trailing: const Icon(Icons.auto_awesome, color: AppColors.accent, size: 20),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Image.asset(
          'assets/images/harry_poter.png',
          height: 40,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => const Text('HOGWARTS'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              context.read<AuthCubit>().signOut();
            },
            tooltip: 'Logout',
          ),
        ],
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          final isLoading = state is HomeLoading;
          List<Map<String, dynamic>> students = [];

          if (state is StudentsLoaded) {
            students = state.students;
          }

          if (isLoading && students.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          return Column(
            children: [
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: _DecorativeHeader(title: 'Hogwarts\'s Students'),
              ),
              const SizedBox(height: 10),
              Expanded(child: _buildStudentList(students)),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddStudentScreen()),
          );
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class _DecorativeHeader extends StatelessWidget {
  final String title;
  const _DecorativeHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: Colors.white54)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              const Icon(Icons.auto_awesome, color: Colors.white38, size: 16),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.auto_awesome, color: Colors.white38, size: 16),
            ],
          ),
        ),
        const Expanded(child: Divider(color: Colors.white54)),
      ],
    );
  }
}
