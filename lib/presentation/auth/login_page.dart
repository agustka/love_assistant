import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:la/application/core/auth/login_cubit.dart';
import 'package:la/domain/wizard/entities/user_partner_profile.dart';
import 'package:la/presentation/auth/widgets/organisms/la_login_actions_organism.dart';
import 'package:la/presentation/auth/widgets/templates/la_auth_card_template.dart';
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
      child: LaAuthCardTemplate(
        child: LaLoginActionsOrganism(partnerProfile: partnerProfile),
      ),
    );
  }
}
