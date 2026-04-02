import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:la/application/core/auth/signup_cubit.dart';
import 'package:la/domain/wizard/entities/user_partner_profile.dart';
import 'package:la/presentation/auth/widgets/la_signup_actions.dart';
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
        maxContentWidth: 420,
        child: LaSignupActions(partnerProfile: partnerProfile),
      ),
    );
  }
}
