import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:la/application/core/auth/signup_cubit.dart';
import 'package:la/presentation/auth/login_page.dart';
import 'package:la/presentation/core/widgets/atoms/la_button.dart';
import 'package:la/presentation/core/widgets/atoms/la_text.dart';
import 'package:la/presentation/core/widgets/atoms/la_card.dart';
import 'package:la/presentation/core/widgets/atoms/la_center.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LaCenter(
        child: LaCard(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const LaText('Sign Up', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 24),
                BlocBuilder<SignupCubit, SignupState>(
                  builder: (context, state) {
                    if (state is SignupLoading) {
                      return const CircularProgressIndicator();
                    }
                    if (state is SignupFailure) {
                      return Column(
                        children: [
                          LaText(state.message, style: const TextStyle(color: Colors.red)),
                          const SizedBox(height: 12),
                        ],
                      );
                    }
                    return Column(
                      children: [
                        LaButton.icon(
                          icon: Icons.g_mobiledata,
                          label: 'Sign up with Google',
                          onPressed: () => context.read<SignupCubit>().signupWithGoogle(),
                        ),
                        const SizedBox(height: 12),
                        LaButton.icon(
                          icon: Icons.apple,
                          label: 'Sign up with Apple',
                          onPressed: () => context.read<SignupCubit>().signupWithApple(),
                        ),
                        const SizedBox(height: 24),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const LoginPage()),
                            );
                          },
                          child: const LaText('Already have an account? Login'),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 