import 'package:flutter/material.dart';
import 'package:la/presentation/core/ui_components/atoms/import.dart';
import 'package:la/presentation/core/ui_components/import.dart';
import 'package:la/presentation/core/ui_components/molecules/import.dart';
import 'package:la/presentation/core/ui_components/organisms/import.dart';
import 'package:la/presentation/core/ui_models/la_date_picker_definition.dart';
import 'package:la/presentation/core/ui_models/la_drop_down_definition.dart';
import 'package:la/presentation/core/ui_models/la_image_asset.dart';
import 'package:la/presentation/core/ui_models/la_multi_select_picker_definition.dart';
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
  final LaMultiSelectPickerDefinition? multiSelectPickerSlot1;
  final LaMultiSelectPickerDefinition? multiSelectPickerSlot2;

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
    this.multiSelectPickerSlot1,
    this.multiSelectPickerSlot2,
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

    return LaSingleChildScrollViewAtom(
      child: LaColumnAtom(
        spacing: LaPadding.large,
        children: [
          if (widget.image != null)
            LaPaddingAtom(
              padding: const EdgeInsets.only(bottom: LaPadding.large),
              child: LaEpicImageOrganism(
                asset: widget.image?.asset ?? LaTheme.illustrations.manGreetings,
                widthAsPercentageOfScreen: 0.5,
              ),
            ),
          if (widget.ribbon != null)
            LaPaddingAtom(
              padding: const EdgeInsets.only(bottom: LaPadding.medium, top: LaPadding.extraSmall),
              child: LaBannerOrganism(asset: widget.ribbon?.asset ?? AppAssets.icons.icTransparent),
            ),
          LaBulletPointListMolecule(
            size: BulletPointListSize.small,
            title: widget.title,
            entries: widget.bulletPoints,
            padding: const EdgeInsets.only(
              left: LaPadding.medium,
              right: LaPadding.medium,
              bottom: LaPadding.small,
            ),
          ),
          if (widget.textFieldSlot != null)
            LaTextField(
              fieldId: widget.textFieldSlot!.fieldId,
              optional: widget.textFieldSlot!.optional,
              title: widget.textFieldSlot!.title,
              hint: widget.textFieldSlot!.hint,
              maxLength: widget.textFieldSlot!.maxLength,
              initialValue: widget.textFieldSlot!.initialValue,
              onChanged: widget.textFieldSlot!.onTextChanged,
              padding: const EdgeInsets.symmetric(horizontal: LaPadding.medium),
            ),
          if (widget.datePickerSlot1 != null)
            LaDatePickerMolecule(
              fieldId: widget.datePickerSlot1!.fieldId,
              optional: widget.datePickerSlot1!.optional,
              title: widget.datePickerSlot1!.title,
              hint: widget.datePickerSlot1!.hint,
              explanation: widget.datePickerSlot1!.explanation,
              firstDate: widget.datePickerSlot1!.firstDate,
              defaultDate: widget.datePickerSlot1!.defaultDate,
              lastDate: widget.datePickerSlot1!.lastDate,
              initialDate: widget.datePickerSlot1!.initialDate,
              onDateSelected: widget.datePickerSlot1!.onDateSelected,
              padding: const EdgeInsets.symmetric(horizontal: LaPadding.medium),
            ),
          if (widget.datePickerSlot2 != null)
            LaDatePickerMolecule(
              fieldId: widget.datePickerSlot2!.fieldId,
              optional: widget.datePickerSlot2!.optional,
              title: widget.datePickerSlot2!.title,
              hint: widget.datePickerSlot2!.hint,
              explanation: widget.datePickerSlot2!.explanation,
              firstDate: widget.datePickerSlot2!.firstDate,
              defaultDate: widget.datePickerSlot2!.defaultDate,
              lastDate: widget.datePickerSlot2!.lastDate,
              initialDate: widget.datePickerSlot2!.initialDate,
              onDateSelected: widget.datePickerSlot2!.onDateSelected,
              padding: const EdgeInsets.symmetric(horizontal: LaPadding.medium),
            ),
          if (widget.multiSelectPickerSlot1 != null)
            LaMultiSelectPickerOrganism(
              fieldId: widget.multiSelectPickerSlot1!.fieldId,
              title: widget.multiSelectPickerSlot1!.title,
              explanation: widget.multiSelectPickerSlot1!.explanation,
              optional: widget.multiSelectPickerSlot1!.optional,
              options: widget.multiSelectPickerSlot1!.options,
              initialSelectedOptions: widget.multiSelectPickerSlot1!.initialSelectedOptions,
              onSelectionChanged: widget.multiSelectPickerSlot1!.onSelectionChanged,
              padding: const EdgeInsets.symmetric(horizontal: LaPadding.medium),
            ),
          if (widget.multiSelectPickerSlot2 != null)
            LaMultiSelectPickerOrganism(
              fieldId: widget.multiSelectPickerSlot2!.fieldId,
              title: widget.multiSelectPickerSlot2!.title,
              explanation: widget.multiSelectPickerSlot2!.explanation,
              optional: widget.multiSelectPickerSlot2!.optional,
              options: widget.multiSelectPickerSlot2!.options,
              initialSelectedOptions: widget.multiSelectPickerSlot2!.initialSelectedOptions,
              onSelectionChanged: widget.multiSelectPickerSlot2!.onSelectionChanged,
              padding: const EdgeInsets.symmetric(horizontal: LaPadding.medium),
            ),
          if (widget.dropDownSlot != null)
            LaDropDownMolecule(
              fieldId: widget.dropDownSlot!.fieldId,
              freeFormFieldId: widget.dropDownSlot!.freeFormFieldId,
              optional: widget.dropDownSlot!.optional,
              title: widget.dropDownSlot!.title,
              hint: widget.dropDownSlot!.hint,
              customHint: widget.dropDownSlot!.customHint,
              explanation: widget.dropDownSlot!.explanation,
              options: widget.dropDownSlot!.options,
              freeFormOption: widget.dropDownSlot!.freeFormOption,
              initialValue: widget.dropDownSlot!.initialValue,
              initialCustomValue: widget.dropDownSlot!.initialCustomValue,
              onChanged: widget.dropDownSlot!.onItemSelected,
              padding: const EdgeInsets.symmetric(horizontal: LaPadding.medium),
            ),
          const LaSizedBoxAtom(height: LaPadding.medium),
        ],
      ),
    );
  }
}
