import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_system/features/auth/cubit/auth_cubit.dart';
import 'package:student_system/features/auth/cubit/auth_state.dart';
import 'package:student_system/features/auth/controllors/signup_controllor.dart';
import 'package:student_system/core/theme/app_colors.dart';
import 'package:student_system/core/theme/app_text_styles.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _controllor = SignUpController();

  @override
  void dispose() {
    _controllor.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
            ),
          );
        } else if (state is SignedUpSuccessfully) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Successfully created account! Please log in.'),
              backgroundColor: AppColors.primary,
            ),
          );
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            color: AppColors.background,
          ),
          child: SafeArea(
            child: CustomScrollView(
              physics: const ClampingScrollPhysics(),
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 20),
                        
                        const Spacer(),
                        Image.asset(
                          'assets/images/harry_poter.png',
                          height: 80,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.bolt, color: AppColors.accent, size: 50),
                        ),
                        const SizedBox(height: 20),
                        const _DecorativeHeader(title: 'Sign Up'),
                        const Spacer(),
                        Form(
                          key: _controllor.formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('FULL NAME', style: AppTextStyles.labelStyle),
                              const SizedBox(height: 6),
                              TextFormField(
                                controller: _controllor.nameController,
                                style: AppTextStyles.bodyRegular,
                                decoration: _inputDecoration('Your Name'),
                                validator: _controllor.validateName,
                              ),
                              const SizedBox(height: 12),
                              const Text('EMAIL ADDRESS', style: AppTextStyles.labelStyle),
                              const SizedBox(height: 6),
                              TextFormField(
                                controller: _controllor.emailController,
                                style: AppTextStyles.bodyRegular,
                                decoration: _inputDecoration('elhabbal@gmail.com'),
                                validator: _controllor.validateEmail,
                              ),
                              const SizedBox(height: 12),
                              const Text('PASSWORD', style: AppTextStyles.labelStyle),
                              const SizedBox(height: 6),
                              TextFormField(
                                controller: _controllor.passController,
                                obscureText: _controllor.obsPass,
                                style: AppTextStyles.bodyRegular,
                                decoration: _inputDecoration('********').copyWith(
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _controllor.obsPass ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                      color: Colors.white,
                                    ),
                                    onPressed: () => setState(() => _controllor.obsPass = !_controllor.obsPass),
                                  ),
                                ),
                                validator: _controllor.validatePassword,
                              ),
                              const SizedBox(height: 12),
                              const Text('CONFIRM PASSWORD', style: AppTextStyles.labelStyle),
                              const SizedBox(height: 6),
                              TextFormField(
                                controller: _controllor.confPassController,
                                obscureText: _controllor.obsConf,
                                style: AppTextStyles.bodyRegular,
                                decoration: _inputDecoration('********').copyWith(
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _controllor.obsConf ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                      color: Colors.white,
                                    ),
                                    onPressed: () => setState(() => _controllor.obsConf = !_controllor.obsConf),
                                  ),
                                ),
                                validator: _controllor.validateConfirmPassword,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        
                        const Spacer(),
                        BlocBuilder<AuthCubit, AuthState>(
                          builder: (context, state) {
                            final isLoading = state is AuthLoading;
                            return ElevatedButton(
                              onPressed: isLoading
                                  ? null
                                  : () {
                                      if (_controllor.formKey.currentState?.validate() ?? false) {
                                        context.read<AuthCubit>().signUpWithEmailAndPassword(
                                              email: _controllor.emailController.text.trim(),
                                              password: _controllor.passController.text,
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
                                  : const Text('CREATE ACCOUNT', style: AppTextStyles.buttonTextStyle),
                            );
                          },
                        ),
                        const Spacer(flex: 2),
                        Center(
                          child: TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: RichText(
                              text: const TextSpan(
                                text: 'Already have an account? ',
                                style: TextStyle(color: Colors.white70),
                                children: [
                                  TextSpan(
                                    text: 'LOG IN',
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      filled: true,
      fillColor: AppColors.surface,
      hintText: hint,
      hintStyle: AppTextStyles.hintStyle,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: AppColors.primary),
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
