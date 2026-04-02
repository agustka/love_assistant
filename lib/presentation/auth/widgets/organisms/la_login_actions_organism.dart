import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:la/application/core/auth/login_cubit.dart';
import 'package:la/domain/wizard/entities/user_partner_profile.dart';
import 'package:la/presentation/auth/signup_page.dart';
import 'package:la/presentation/auth/widgets/atoms/la_auth_header_text_atom.dart';
import 'package:la/presentation/auth/widgets/molecules/la_auth_provider_buttons_molecule.dart';
import 'package:la/presentation/auth/widgets/molecules/la_auth_switch_mode_button_molecule.dart';
import 'package:la/presentation/core/localization/l10n.dart';
import 'package:la/presentation/core/theme/la_theme.dart';
import 'package:la/presentation/core/ui_components/atoms/la_text_atom.dart';

class LaLoginActionsOrganism extends StatelessWidget {
  final UserPartnerProfile? partnerProfile;

  const LaLoginActionsOrganism({
    super.key,
    required this.partnerProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        LaAuthHeaderTextAtom(
          title: S.of(context).auth_login_title,
          subtitle: S.of(context).auth_login_subtitle,
        ),
        const SizedBox(height: LaPaddings.large),
        BlocBuilder<LoginCubit, LoginState>(
          builder: (BuildContext context, LoginState state) {
            if (state is LoginLoading) {
              return const CircularProgressIndicator();
            }

            if (state is LoginFailure) {
              return Column(
                children: [
                  LaTextAtom(state.message, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: LaPaddings.mediumSmall),
                ],
              );
            }

            return Column(
              children: [
                LaAuthProviderButtonsMolecule(
                  googleText: S.of(context).auth_login_google,
                  appleText: S.of(context).auth_login_apple,
                  onGoogleTap: () => context.read<LoginCubit>().loginWithGoogle(),
                  onAppleTap: () => context.read<LoginCubit>().loginWithApple(),
                ),
                const SizedBox(height: LaPaddings.large),
                LaAuthSwitchModeButtonMolecule(
                  prompt: S.of(context).auth_login_signup_prompt,
                  actionText: S.of(context).auth_login_signup_action,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<SignupPage>(
                        builder: (BuildContext context) => SignupPage(partnerProfile: partnerProfile),
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
