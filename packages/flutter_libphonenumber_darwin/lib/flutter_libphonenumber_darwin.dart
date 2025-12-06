import 'package:flutter/services.dart';
import 'package:flutter_libphonenumber_platform_interface/flutter_libphonenumber_platform_interface.dart';

const _channel = MethodChannel('com.couttsconsulting/flutter_libphonenumber_darwin');

class FlutterLibphonenumberDarwin extends FlutterLibphonenumberPlatform {
  /// Registers this class as the default instance of [FlutterLibphonenumberPlatform].
  static void registerWith() {
    FlutterLibphonenumberPlatform.instance = FlutterLibphonenumberDarwin();
  }

  @override
  Future<Map<String, String>> format(
    final String phone,
    final String region,
  ) async {
    return await _channel.invokeMapMethod<String, String>('format', {
          'phone': phone,
          'region': region,
        }) ??
        <String, String>{};
  }

  @override
  Future<Map<String, CountryWithPhoneCode>> getAllSupportedRegions() async {
    final result =
        await _channel.invokeMapMethod<String, dynamic>('get_all_supported_regions') ?? {};

    final returnMap = <String, CountryWithPhoneCode>{};
    result.forEach(
      (final k, final v) => returnMap[k] = CountryWithPhoneCode(
        countryName: v['countryName'] as String? ?? '',
        phoneCode: v['phoneCode'] as String? ?? '',
        countryCode: k,
        exampleNumberMobileNational: v['exampleNumberMobileNational'] as String? ?? '',
        exampleNumberFixedLineNational: v['exampleNumberFixedLineNational'] as String? ?? '',
        phoneMaskMobileNational: v['phoneMaskMobileNational'] as String? ?? '',
        phoneMaskFixedLineNational: v['phoneMaskFixedLineNational'] as String? ?? '',
        exampleNumberMobileInternational: v['exampleNumberMobileInternational'] as String? ?? '',
        exampleNumberFixedLineInternational:
            v['exampleNumberFixedLineInternational'] as String? ?? '',
        phoneMaskMobileInternational: v['phoneMaskMobileInternational'] as String? ?? '',
        phoneMaskFixedLineInternational: v['phoneMaskFixedLineInternational'] as String? ?? '',
      ),
    );
    return returnMap;
  }

  @override
  Future<Map<String, dynamic>> parse(
    final String phone, {
    final String? region,
  }) async {
    return await _channel.invokeMapMethod<String, dynamic>('parse', {
          'phone': phone,
          'region': region,
        }) ??
        <String, dynamic>{};
  }

  @override
  Future<void> init({
    final Map<String, CountryWithPhoneCode> overrides = const {},
  }) async {
    return CountryManager().loadCountries(
      phoneCodesMap: await getAllSupportedRegions(),
      overrides: overrides,
    );
  }
}
