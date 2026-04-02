import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:la/application/core/auth/signup_cubit.dart';
import 'package:la/domain/wizard/entities/user_partner_profile.dart';
import 'package:la/presentation/auth/login_page.dart';
import 'package:la/presentation/core/theme/la_theme.dart';
import 'package:la/presentation/core/ui_components/atoms/la_button.dart';
import 'package:la/presentation/core/ui_components/atoms/la_card.dart';
import 'package:la/presentation/core/ui_components/atoms/la_center.dart';
import 'package:la/presentation/core/ui_components/atoms/la_text.dart';
import 'package:la/setup.dart';

class SignupPage extends StatelessWidget {
  final UserPartnerProfile? partnerProfile;

  const SignupPage({
    super.key,
    this.partnerProfile,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SignupCubit>(
      create: (BuildContext context) => getIt<SignupCubit>(),
      child: Scaffold(
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
                      if (state.status == SignupStatus.loading) {
                        return const CircularProgressIndicator();
                      }
                      return Column(
                        children: [
                          LaButton.mini(
                            icon: Icons.g_mobiledata,
                            text: 'Sign up with Google',
                            onTap: () => context.read<SignupCubit>().signupWithGoogle(),
                          ),
                          const SizedBox(height: 12),
                          LaButton.mini(
                            icon: Icons.apple,
                            text: 'Sign up with Apple',
                            onTap: () => context.read<SignupCubit>().signupWithApple(),
                          ),
                          const SizedBox(height: 24),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => LoginPage(partnerProfile: partnerProfile),
                                ),
                              );
                            },
                            child: LaText(
                              'Already have an account? Login',
                              style: LaTheme.font.body16,
                            ),
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
      ),
    );
  }
}
