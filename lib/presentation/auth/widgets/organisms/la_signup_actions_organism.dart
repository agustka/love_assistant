import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:la/application/core/auth/signup_cubit.dart';
import 'package:la/domain/wizard/entities/user_partner_profile.dart';
import 'package:la/presentation/auth/login_page.dart';
import 'package:la/presentation/auth/widgets/atoms/la_auth_header_text_atom.dart';
import 'package:la/presentation/auth/widgets/molecules/la_auth_provider_buttons_molecule.dart';
import 'package:la/presentation/auth/widgets/molecules/la_auth_switch_mode_button_molecule.dart';
import 'package:la/presentation/core/localization/l10n.dart';

class LaSignupActionsOrganism extends StatelessWidget {
  final UserPartnerProfile? partnerProfile;

  const LaSignupActionsOrganism({
    super.key,
    required this.partnerProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        LaAuthHeaderTextAtom(
          title: S.of(context).auth_signup_title,
          subtitle: S.of(context).auth_signup_subtitle,
        ),
        const SizedBox(height: 24),
        BlocBuilder<SignupCubit, SignupState>(
          builder: (BuildContext context, SignupState state) {
            if (state.status == SignupStatus.loading) {
              return const CircularProgressIndicator();
            }

            return Column(
              children: [
                LaAuthProviderButtonsMolecule(
                  googleText: S.of(context).auth_signup_google,
                  appleText: S.of(context).auth_signup_apple,
                  onGoogleTap: () => context.read<SignupCubit>().signupWithGoogle(),
                  onAppleTap: () => context.read<SignupCubit>().signupWithApple(),
                ),
                const SizedBox(height: 24),
                LaAuthSwitchModeButtonMolecule(
                  prompt: S.of(context).auth_signup_login_prompt,
                  actionText: S.of(context).auth_signup_login_action,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<LoginPage>(
                        builder: (BuildContext context) => LoginPage(partnerProfile: partnerProfile),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
