import 'package:flutter/material.dart';

class WizardTemplate extends StatefulWidget {
  final List<Widget> steps;
  final int currentStep;
  final bool isLoading;
  final VoidCallback? onNext;
  final VoidCallback? onBack;
  final VoidCallback? onFinish;
  final bool showBackButton;
  final bool showNextButton;
  final String? nextButtonText;
  final String? finishButtonText;
  final bool isNextButtonEnabled;
  final Widget? header;
  final Widget? footer;

  const WizardTemplate({
    super.key,
    required this.steps,
    required this.currentStep,
    this.isLoading = false,
    this.onNext,
    this.onBack,
    this.onFinish,
    this.showBackButton = true,
    this.showNextButton = true,
    this.nextButtonText,
    this.finishButtonText,
    this.isNextButtonEnabled = true,
    this.header,
    this.footer,
  }) : assert(currentStep >= 0 && currentStep < steps.length);

  @override
  State<WizardTemplate> createState() => _WizardTemplateState();
}

class _WizardTemplateState extends State<WizardTemplate> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.currentStep);
  }

  @override
  void didUpdateWidget(covariant WizardTemplate oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentStep != widget.currentStep) {
      _pageController.animateToPage(
        widget.currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.header,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.steps.length,
              itemBuilder: (context, index) {
                return widget.steps[index];
              },
            ),
          ),
          if (widget.footer != null) widget.footer!,
          if (widget.showBackButton || widget.showNextButton)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (widget.showBackButton && widget.currentStep > 0)
                    TextButton(
                      onPressed: widget.onBack,
                      child: const Text('Back'),
                    )
                  else
                    const SizedBox(width: 80),
                  if (widget.showNextButton)
                    ElevatedButton(
                      onPressed: widget.isNextButtonEnabled
                          ? widget.currentStep == widget.steps.length - 1
                              ? widget.onFinish
                              : widget.onNext
                          : null,
                      child: Text(
                        widget.currentStep == widget.steps.length - 1
                            ? widget.finishButtonText ?? 'Finish'
                            : widget.nextButtonText ?? 'Next',
                      ),
                    )
                  else
                    const SizedBox(width: 80),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
