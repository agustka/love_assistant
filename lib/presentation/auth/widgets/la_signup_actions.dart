import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:la/application/core/auth/signup_cubit.dart';
import 'package:la/domain/wizard/entities/user_partner_profile.dart';
import 'package:la/presentation/auth/login_page.dart';
import 'package:la/presentation/auth/widgets/la_auth_actions_card.dart';
import 'package:la/presentation/core/localization/l10n.dart';

class LaSignupActions extends StatelessWidget {
  final UserPartnerProfile? partnerProfile;

  const LaSignupActions({
    super.key,
    required this.partnerProfile,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupCubit, SignupState>(
      builder: (BuildContext context, SignupState state) {
        return LaAuthActionsCard(
          title: S.of(context).auth_signup_title,
          subtitle: S.of(context).auth_signup_subtitle,
          googleText: S.of(context).auth_signup_google,
          appleText: S.of(context).auth_signup_apple,
          prompt: S.of(context).auth_signup_login_prompt,
          actionText: S.of(context).auth_signup_login_action,
          onGoogleTap: () => context.read<SignupCubit>().signupWithGoogle(),
          onAppleTap: () => context.read<SignupCubit>().signupWithApple(),
          onSwitchTap: () {
            Navigator.push(
              context,
              MaterialPageRoute<LoginPage>(
                builder: (BuildContext context) => LoginPage(partnerProfile: partnerProfile),
              ),
            );
          },
          isLoading: state.status == SignupStatus.loading,
        );
      },
    );
  }
}
