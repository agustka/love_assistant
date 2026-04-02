import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:la/application/core/auth/signup_cubit.dart';
import 'package:la/domain/wizard/entities/user_partner_profile.dart';
import 'package:la/presentation/auth/widgets/organisms/la_signup_actions_organism.dart';
import 'package:la/presentation/auth/widgets/templates/la_auth_card_template.dart';
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
      child: LaAuthCardTemplate(
        child: LaSignupActionsOrganism(partnerProfile: partnerProfile),
      ),
    );
  }
}
