import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:la/application/splash/splash_cubit.dart';
import 'package:la/presentation/core/assets/assets.gen.dart';
import 'package:la/presentation/core/widgets/la_app_bar.dart';
import 'package:la/presentation/core/widgets/la_scaffold.dart';
import 'package:la/presentation/core/widgets/la_svg.dart';
import 'package:la/setup.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SplashPageState();
  }
}

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        return getIt<SplashCubit>()..init();
      },
      child: BlocBuilder<SplashCubit, SplashState>(
        builder: (BuildContext context, SplashState state) {
          return LaScaffold(
            appBar: const LaAppBar(showBack: false, takesUpSpace: false),
            child: Center(
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: LaSvg(
                  AppAssets.icons.loveAssistantLogo,
                  width: MediaQuery.sizeOf(context).width * 0.25,
                  height: MediaQuery.sizeOf(context).width * 0.25,
                  accessibilityScaling: false,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
