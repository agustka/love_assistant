import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:la/application/core/auth/signup_cubit.dart';
import 'package:la/domain/wizard/entities/user_partner_profile.dart';
import 'package:la/presentation/auth/login_page.dart';
import 'package:la/presentation/core/localization/l10n.dart';
import 'package:la/presentation/core/ui_components/organisms/import.dart';
import 'package:la/presentation/core/ui_components/templates/la_default_page_template.dart';
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
      child: LaDefaultPageTemplate(
        centerContent: true,
        child: BlocBuilder<SignupCubit, SignupState>(
          builder: (BuildContext context, SignupState state) {
            return LaAuthActionsOrganism(
              definition: LaAuthActionsDefinition(
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
              ),
            );
          },
        ),
      ),
    );
  }
}
