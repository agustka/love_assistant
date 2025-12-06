import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:la/application/wizard/wizard_cubit.dart';
import 'package:la/presentation/core/widgets/import.dart';

class WizardStep5 extends StatefulWidget {
  const WizardStep5({
    super.key,
  });

  @override
  State<StatefulWidget> createState() {
    return _WizardStep4State();
  }
}

class _WizardStep4State extends State<WizardStep5> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocBuilder<WizardCubit, WizardState>(
      builder: (BuildContext context, WizardState state) {
        return const SingleChildScrollView(
          child: Column(
            spacing: LaPaddings.large,
            children: [
              // TODO finish step 5 for detail profile
              SizedBox.shrink(),
            ],
          ),
        );
      },
    );
  }
}
