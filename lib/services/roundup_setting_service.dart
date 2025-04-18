import 'package:ripple/models/roundup_setting.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RoundupSettingService {
  static const String _roundupTable = 'roundup_setting';

  Future<RoundupSetting?> getRoundupSettings(int userId) async {
    try {
      final result = await Supabase.instance.client
          .from(_roundupTable)
          .select()
          .match({'userid': userId}).single();
      return _mapToRoundupSetting(result);
    } catch (err) {
      return null;
    }
  }

  Future<RoundupSetting?> insertRoundupSettings(RoundupSetting setting) async {
    final res = _mapToRoundupSetting((await Supabase.instance.client
            .from(_roundupTable)
            .insert(_newRoundupSettingToMap(setting))
            .select())
        .single);
    return res;
  }

  Future<RoundupSetting?> updateRoundupSettings(RoundupSetting setting) async {
    final res = _mapToRoundupSetting((await Supabase.instance.client
            .from(_roundupTable)
            .update(_roundupSettingToMap(setting))
            .match({'roundupid': setting.id!}).select())
        .single);
    return res;
  }

  Future<void> resetNextCharityIndex(int roundupId) async {
    await Supabase.instance.client
        .from(_roundupTable)
        .update({'next_charity_index': 0})
        .eq('roundupId', roundupId);
  }

  RoundupSetting _mapToRoundupSetting(Map<String, dynamic> map) =>
      RoundupSetting(
        id: map['roundupid'],
        userId: map['userid'],
        nextCharityIndex: map['next_charity_index'],
        isActive: map['isactive'],
        monthlyCap: map['monthlycap'],
        hasMonthlyCap: map['has_monthly_cap'],
        donationThreshold: map['donation_threshold'],
        roundupAmount: map['roundup_amount'],
        roundupMode: parseRoundupMode(map['roundup_mode']),
        runningTotal: map['running_total'] is int
            ? (map['running_total'] as int).toDouble()
            : (map['running_total'] as double).toDouble(),
        totalYtd: map['totalytd'] is int
            ? (map['totalytd'] as int).toDouble()
            : (map['totalytd'] as double).toDouble(),
      );

  RoundupMode parseRoundupMode(String mode) {
    return switch (mode) {
      'automatic' => RoundupMode.automatic,
      'manual' => RoundupMode.manual,
      'random' => RoundupMode.random,
      String() => RoundupMode.automatic,
    };
  }

  String roundupModeToString(RoundupMode mode) {
    return switch (mode) {
      RoundupMode.automatic => 'automatic',
      RoundupMode.manual => 'manual',
      RoundupMode.random => 'random',
    };
  }

  Map<String, dynamic> _newRoundupSettingToMap(RoundupSetting setting) => {
        'userid': setting.userId,
      };

  Map<String, dynamic> _roundupSettingToMap(RoundupSetting setting) => {
        'userid': setting.userId,
        'next_charity_index': setting.nextCharityIndex,
        'isactive': setting.isActive,
        'monthlycap': setting.monthlyCap,
        'has_monthly_cap': setting.hasMonthlyCap,
        'donation_threshold': setting.donationThreshold,
        'roundup_amount': setting.roundupAmount,
        'running_total': setting.runningTotal,
        'totalytd': setting.totalYtd,
        'roundup_mode': roundupModeToString(setting.roundupMode!),
      };
}
