import 'package:flutter/material.dart';
import 'package:la/presentation/core/ui_components/import.dart';
import 'package:la/presentation/core/ui_components/molecules/import.dart';
import 'package:la/presentation/core/ui_components/organisms/import.dart';
import 'package:la/presentation/core/ui_models/la_drop_down_definition.dart';
import 'package:la/presentation/core/ui_models/la_image_asset.dart';
import 'package:la/presentation/core/ui_models/la_text_field_definition.dart';

class LaWizardStepOrganism<T> extends StatefulWidget {
  final LaImageAsset? image;
  final LaImageAsset? ribbon;
  final String title;
  final List<BulletPointEntry> bulletPoints;
  final LaTextFieldDefinition? textFieldSlot;
  final LaDropDownDefinition<T>? dropDownSlot;

  const LaWizardStepOrganism({
    super.key,
    this.image,
    this.ribbon,
    required this.title,
    required this.bulletPoints,
    this.textFieldSlot,
    this.dropDownSlot,
  });

  @override
  State<StatefulWidget> createState() {
    return _WizardStep2State<T>();
  }
}

class _WizardStep2State<T> extends State<LaWizardStepOrganism> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return SingleChildScrollView(
      child: Column(
        spacing: LaPaddings.large,
        children: [
          if (widget.image != null)
            Padding(
              padding: const EdgeInsets.only(bottom: LaPaddings.large),
              child: LaEpicImage(
                asset: widget.image?.asset ?? LaTheme.illustrations.manGreetings,
                widthAsPercentageOfScreen: 0.5,
              ),
            ),
          if (widget.ribbon != null)
            Padding(
              padding: const EdgeInsets.only(bottom: LaPaddings.large, top: LaPaddings.medium),
              child: LaBanner(asset: widget.ribbon?.asset ?? AppAssets.icons.icTransparent),
            ),
          LaBulletPointList(
            size: BulletPointListSize.small,
            title: widget.title,
            entries: widget.bulletPoints,
            padding: const EdgeInsets.only(
              left: LaPaddings.medium,
              right: LaPaddings.medium,
              bottom: LaPaddings.small,
            ),
          ),
          if (widget.textFieldSlot != null)
            LaTextField(
              fieldId: widget.textFieldSlot!.fieldId,
              optional: widget.textFieldSlot!.optional,
              title: widget.textFieldSlot!.title,
              hint: widget.textFieldSlot!.hint,
              maxLength: widget.textFieldSlot!.maxLength,
              onChanged: widget.textFieldSlot!.onTextChanged,
              padding: const EdgeInsets.symmetric(horizontal: LaPaddings.medium),
            ),
          if (widget.dropDownSlot != null)
            LaDropDown<T>(
              fieldId: widget.dropDownSlot!.fieldId,
              freeFormFieldId: widget.dropDownSlot!.freeFormFieldId,
              optional: widget.dropDownSlot!.optional,
              title: widget.dropDownSlot!.title,
              hint: widget.dropDownSlot!.hint,
              customHint: widget.dropDownSlot!.customHint,
              options: widget.dropDownSlot!.options,
              freeFormOption: widget.dropDownSlot!.freeFormOption,
              onChanged: widget.dropDownSlot!.onItemSelected,
            ),
        ],
      ),
    );
  }
}
