import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../constants/flavor_type.dart';

part 'config.freezed.dart';

part 'config.g.dart';

@freezed
sealed class Config with _$Config {
  factory Config({
    required FlavorType env,
    required bool production,
    required String apiUrl,
    required String bundleID,
  }) = _Config;

  factory Config.fromJson(Map<String, dynamic> json) => _$ConfigFromJson(json);
}
