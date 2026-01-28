import 'package:flutter/material.dart';
import '../../features/random_image/presentation/presentation.dart';
import '../di/di.dart';
import 'splash_screen.dart';

class SplashGate extends StatefulWidget {
  const SplashGate({super.key});

  @override
  State<SplashGate> createState() => _SplashGateState();
}

class _SplashGateState extends State<SplashGate> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInitialImage();
  }

  Future<void> _loadInitialImage() async {
    final store = getIt<RandomImageStore>();
    await store.load(context: context);
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const SplashScreen();
    }

    return const RandomImagePage();
  }
}
