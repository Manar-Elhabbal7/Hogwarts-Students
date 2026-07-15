import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_system/core/theme/app_colors.dart';
import 'package:student_system/core/theme/app_text_styles.dart';
import 'package:student_system/core/widgets/app_form_field.dart';
import 'package:student_system/features/students/cubit/home_cubit.dart';

import '../cubit/home_state.dart';

class AddStudentScreen extends StatefulWidget {
  const AddStudentScreen({super.key});

  @override
  State<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  String? _selectedHouse;

  final List<String> _houses = ['Gryffindor', 'Hufflepuff', 'Ravenclaw', 'Slytherin'];

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state is StudentAddedSuccessfully) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.primary,
            ),
          );
          Navigator.pop(context);
        } else if (state is HomeError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),

        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(
                'assets/images/students.png',
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 200,
                  color: AppColors.surface,
                  child: const Icon(Icons.group, size: 100, color: AppColors.accent),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const _DecorativeHeader(title: 'Enroll Student'),
                      const SizedBox(height: 32),
                      AppFormField(
                        label: 'Student Full Name',
                        controller: _nameController,
                        hintText: 'e.g. Harry Potter',
                        prefixIcon: const Icon(Icons.person_outline),
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Please enter the name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      AppFormField(
                        label: 'Age',
                        controller: _ageController,
                        hintText: 'e.g. 11',
                        keyboardType: TextInputType.number,
                        prefixIcon: const Icon(Icons.calendar_today_outlined),
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Please enter the age';
                          }
                          final age = int.tryParse(val);
                          if (age == null || age <= 0) {
                            return 'Please enter a valid age';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      const Text('HOUSE', style: AppTextStyles.labelStyle),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        initialValue: _selectedHouse,
                        dropdownColor: AppColors.surface,
                        style: AppTextStyles.bodyRegular,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColors.surface,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: const BorderSide(color: AppColors.border),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: const BorderSide(color: AppColors.primary),
                          ),
                        ),
                        items: _houses.map((house) {
                          return DropdownMenuItem(
                            value: house,
                            child: Text(house),
                          );
                        }).toList(),
                        onChanged: (val) => setState(() => _selectedHouse = val),
                        validator: (val) => val == null ? 'Please select a house' : null,
                        hint: const Text('Select Hogwarts House', style: AppTextStyles.hintStyle),
                      ),
                      const SizedBox(height: 40),
                      BlocBuilder<HomeCubit, HomeState>(
                        builder: (context, state) {
                          final isLoading = state is AddingStudentInProgress;
                          return ElevatedButton(
                            onPressed: isLoading
                                ? null
                                : () {
                                    if (_formKey.currentState?.validate() ?? false) {
                                      context.read<HomeCubit>().addStudent(
                                            name: _nameController.text.trim(),
                                            age: int.parse(_ageController.text.trim()),
                                            house: _selectedHouse!,
                                          );
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              minimumSize: const Size(double.infinity, 55),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: isLoading
                                ? const CircularProgressIndicator(color: Colors.white)
                                : const Text('ENROLL STUDENT', style: AppTextStyles.buttonTextStyle),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
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
              const Icon(Icons.auto_awesome, color: Colors.white38, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.auto_awesome, color: Colors.white38, size: 20),
            ],
          ),
        ),
        const Expanded(child: Divider(color: Colors.white54)),
      ],
    );
  }
}
