// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'random_image_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$RandomImageStore on _RandomImageStore, Store {
  late final _$imageUrlAtom = Atom(
    name: '_RandomImageStore.imageUrl',
    context: context,
  );

  @override
  String? get imageUrl {
    _$imageUrlAtom.reportRead();
    return super.imageUrl;
  }

  @override
  set imageUrl(String? value) {
    _$imageUrlAtom.reportWrite(value, super.imageUrl, () {
      super.imageUrl = value;
    });
  }

  late final _$gradientColorsAtom = Atom(
    name: '_RandomImageStore.gradientColors',
    context: context,
  );

  @override
  List<Color> get gradientColors {
    _$gradientColorsAtom.reportRead();
    return super.gradientColors;
  }

  @override
  set gradientColors(List<Color> value) {
    _$gradientColorsAtom.reportWrite(value, super.gradientColors, () {
      super.gradientColors = value;
    });
  }

  late final _$isLoadingAtom = Atom(
    name: '_RandomImageStore.isLoading',
    context: context,
  );

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$errorAtom = Atom(
    name: '_RandomImageStore.error',
    context: context,
  );

  @override
  String? get error {
    _$errorAtom.reportRead();
    return super.error;
  }

  @override
  set error(String? value) {
    _$errorAtom.reportWrite(value, super.error, () {
      super.error = value;
    });
  }

  late final _$loadAsyncAction = AsyncAction(
    '_RandomImageStore.load',
    context: context,
  );

  @override
  Future<void> load() {
    return _$loadAsyncAction.run(() => super.load());
  }

  @override
  String toString() {
    return '''
imageUrl: ${imageUrl},
gradientColors: ${gradientColors},
isLoading: ${isLoading},
error: ${error}
    ''';
  }
}
