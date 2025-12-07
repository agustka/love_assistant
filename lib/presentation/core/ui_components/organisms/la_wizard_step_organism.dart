import 'package:flutter/material.dart';
import 'package:la/presentation/core/ui_components/import.dart';
import 'package:la/presentation/core/ui_components/molecules/import.dart';
import 'package:la/presentation/core/ui_components/organisms/import.dart';
import 'package:la/presentation/core/ui_models/la_date_picker_definition.dart';
import 'package:la/presentation/core/ui_models/la_drop_down_definition.dart';
import 'package:la/presentation/core/ui_models/la_image_asset.dart';
import 'package:la/presentation/core/ui_models/la_text_field_definition.dart';

class LaWizardStepOrganism extends StatefulWidget {
  final LaImageAsset? image;
  final LaImageAsset? ribbon;
  final String title;
  final List<BulletPointEntry> bulletPoints;
  final LaTextFieldDefinition? textFieldSlot;
  final LaDropDownDefinition? dropDownSlot;
  final LaDatePickerDefinition? datePickerSlot1;
  final LaDatePickerDefinition? datePickerSlot2;

  const LaWizardStepOrganism({
    super.key,
    this.image,
    this.ribbon,
    required this.title,
    required this.bulletPoints,
    this.textFieldSlot,
    this.dropDownSlot,
    this.datePickerSlot1,
    this.datePickerSlot2,
  });

  @override
  State<StatefulWidget> createState() {
    return _WizardStep2State();
  }
}

class _WizardStep2State extends State<LaWizardStepOrganism> with AutomaticKeepAliveClientMixin {
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
              padding: const EdgeInsets.only(bottom: LaPaddings.medium, top: LaPaddings.extraSmall),
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
            LaDropDown(
              fieldId: widget.dropDownSlot!.fieldId,
              freeFormFieldId: widget.dropDownSlot!.freeFormFieldId,
              optional: widget.dropDownSlot!.optional,
              title: widget.dropDownSlot!.title,
              hint: widget.dropDownSlot!.hint,
              customHint: widget.dropDownSlot!.customHint,
              options: widget.dropDownSlot!.options,
              freeFormOption: widget.dropDownSlot!.freeFormOption,
              onChanged: widget.dropDownSlot!.onItemSelected,
              padding: const EdgeInsets.symmetric(horizontal: LaPaddings.medium),
            ),
          if (widget.datePickerSlot1 != null)
            LaDatePicker(
              fieldId: widget.datePickerSlot1!.fieldId,
              optional: widget.datePickerSlot1!.optional,
              title: widget.datePickerSlot1!.title,
              hint: widget.datePickerSlot1!.hint,
              explanation: widget.datePickerSlot1!.explanation,
              firstDate: widget.datePickerSlot1!.firstDate,
              defaultDate: widget.datePickerSlot1!.defaultDate,
              lastDate: widget.datePickerSlot1!.lastDate,
              onDateSelected: widget.datePickerSlot1!.onDateSelected,
              padding: const EdgeInsets.symmetric(horizontal: LaPaddings.medium),
            ),
          if (widget.datePickerSlot2 != null)
            LaDatePicker(
              fieldId: widget.datePickerSlot2!.fieldId,
              optional: widget.datePickerSlot2!.optional,
              title: widget.datePickerSlot2!.title,
              hint: widget.datePickerSlot2!.hint,
              explanation: widget.datePickerSlot2!.explanation,
              firstDate: widget.datePickerSlot2!.firstDate,
              defaultDate: widget.datePickerSlot2!.defaultDate,
              lastDate: widget.datePickerSlot2!.lastDate,
              onDateSelected: widget.datePickerSlot2!.onDateSelected,
              padding: const EdgeInsets.symmetric(horizontal: LaPaddings.medium),
            ),
          const SizedBox(height: LaPaddings.medium),
        ],
      ),
    );
  }
}
