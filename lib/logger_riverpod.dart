import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoggerRiverpod extends ProviderObserver {
  @override
  void didAddProvider(ProviderBase<Object?> provider, Object? value,
      ProviderContainer container) {
    super.didAddProvider(provider, value, container);
    log('PROVIDER CREATED -> ${provider.name ?? provider.runtimeType},  $value');
  }

  @override
  void didDisposeProvider(
      ProviderBase<Object?> provider, ProviderContainer container) {
    super.didDisposeProvider(provider, container);
    log('PROVIDER DELETED -> ${provider.name ?? provider.runtimeType}');
  }
}
