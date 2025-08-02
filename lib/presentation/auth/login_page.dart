import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:la/application/core/auth/login_cubit.dart';
import 'package:la/presentation/auth/signup_page.dart';
import 'package:la/presentation/core/widgets/atoms/la_button.dart';
import 'package:la/presentation/core/widgets/atoms/la_text.dart';
import 'package:la/presentation/core/widgets/atoms/la_card.dart';
import 'package:la/presentation/core/widgets/atoms/la_center.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

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
                const LaText('Login', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 24),
                BlocBuilder<LoginCubit, LoginState>(
                  builder: (context, state) {
                    if (state is LoginLoading) {
                      return const CircularProgressIndicator();
                    }
                    if (state is LoginFailure) {
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
                          label: 'Sign in with Google',
                          onPressed: () => context.read<LoginCubit>().loginWithGoogle(),
                        ),
                        const SizedBox(height: 12),
                        LaButton.icon(
                          icon: Icons.apple,
                          label: 'Sign in with Apple',
                          onPressed: () => context.read<LoginCubit>().loginWithApple(),
                        ),
                        const SizedBox(height: 24),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const SignupPage()),
                            );
                          },
                          child: const LaText('Don\'t have an account? Sign up'),
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