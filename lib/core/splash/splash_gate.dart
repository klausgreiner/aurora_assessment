import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import '../../features/random_image/presentation/presentation.dart';
import '../di/di.dart';
import '../generated/app_localizations.dart';
import 'splash_screen.dart';

class SplashGate extends StatefulWidget {
  const SplashGate({super.key});

  @override
  State<SplashGate> createState() => _SplashGateState();
}

class _SplashGateState extends State<SplashGate> {
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadInitialImage();
  }

  Future<void> _loadInitialImage() async {
    final store = getIt<RandomImageStore>();
    try {
      await store.load(context: context);
      FlutterNativeSplash.remove();
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      FlutterNativeSplash.remove();
      if (mounted) {
        setState(() {
          _isLoading = false;
          _error = AppLocalizations.of(context)!.errorFailedToLoadInitialImage;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const SplashScreen();
    }

    if (_error != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_error!),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isLoading = true;
                    _error = null;
                  });
                  _loadInitialImage();
                },
                child: Text(AppLocalizations.of(context)!.buttonRetry),
              ),
            ],
          ),
        ),
      );
    }

    return const RandomImagePage();
  }
}
