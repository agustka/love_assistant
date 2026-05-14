import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:la/application/core/auth/signup_cubit.dart';
import 'package:la/presentation/auth/widgets/email_confirmation_content_organism.dart';
import 'package:la/presentation/core/ui_components/atoms/import.dart';
import 'package:la/presentation/core/ui_components/import.dart';

class EmailConfirmationDialog extends StatelessWidget {
  const EmailConfirmationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return LaDialogAtom(
      shape: LaCornerRadius().dialog,
      child: BlocBuilder<SignupCubit, SignupState>(
        builder: (BuildContext context, SignupState state) {
          final bool hasPendingError =
              state.status == SignupStatus.emailConfirmationRequired &&
              state.errorMessage == SignupCubit.emailConfirmationPendingErrorCode;

          return EmailConfirmationContentOrganism(
            title: S.of(context).auth_email_confirmation_title,
            message: S.of(context).auth_email_confirmation_message,
            confirmText: S.of(context).auth_email_confirmation_confirmed,
            cancelText: S.of(context).global_cancel,
            errorMessage: hasPendingError ? S.of(context).auth_email_confirmation_pending_error : null,
            isLoading: state.isCheckingEmailConfirmation,
            onConfirm: () => context.read<SignupCubit>().checkEmailConfirmed(),
            onCancel: () => context.read<SignupCubit>().cancelConfirmation(),
          );
        },
      ),
    );
  }
}
