import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:la/application/core/auth/login_cubit.dart';
import 'package:la/domain/wizard/entities/user_partner_profile.dart';
import 'package:la/presentation/auth/signup_page.dart';
import 'package:la/presentation/core/localization/l10n.dart';
import 'package:la/presentation/core/ui_components/organisms/import.dart';
import 'package:la/presentation/core/ui_components/templates/la_default_page_template.dart';
import 'package:la/setup.dart';

class LoginPage extends StatelessWidget {
  final UserPartnerProfile? partnerProfile;

  const LoginPage({
    super.key,
    this.partnerProfile,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginCubit>(
      create: (BuildContext context) => getIt<LoginCubit>(),
      child: LaDefaultPageTemplate(
        centerContent: true,
        child: BlocBuilder<LoginCubit, LoginState>(
          builder: (BuildContext context, LoginState state) {
            return LaAuthActionsOrganism(
              definition: LaAuthActionsDefinition(
                title: S.of(context).auth_login_title,
                subtitle: S.of(context).auth_login_subtitle,
                googleText: S.of(context).auth_login_google,
                appleText: S.of(context).auth_login_apple,
                prompt: S.of(context).auth_login_signup_prompt,
                actionText: S.of(context).auth_login_signup_action,
                onGoogleTap: () => context.read<LoginCubit>().loginWithGoogle(),
                onAppleTap: () => context.read<LoginCubit>().loginWithApple(),
                onSwitchTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<SignupPage>(
                      builder: (BuildContext context) => SignupPage(partnerProfile: partnerProfile),
                    ),
                  );
                },
                isLoading: state is LoginLoading,
                errorMessage: state is LoginFailure ? state.message : null,
              ),
            );
          },
        ),
      ),
    );
  }
}
