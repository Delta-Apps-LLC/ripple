import 'package:ripple/models/roundup_setting.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RoundupSettingService {
  static const String _roundupTable = 'roundup_setting';

  Future<RoundupSetting?> getRoundupSettings() async {
    try {
      final result =
          await Supabase.instance.client.from(_roundupTable).select();
      return result.map(_mapToRoundupSetting).first;
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

  RoundupSetting? _mapToRoundupSetting(Map<String, dynamic> map) =>
      RoundupSetting(
        id: map['roundupid'],
        userId: map['userid'],
        charityId: map['charityid'],
        isActive: map['isactive'],
        monthlyCap: map['monthlycap'],
        donationThreshold: map['donation_threshold'],
        roundupAmount: map['roundup_amount'],
        runningTotal: (map['running_total'] as int).toDouble(),
        totalYtd: (map['totalytd'] as int).toDouble(),
      );

  Map<String, dynamic> _newRoundupSettingToMap(RoundupSetting setting) => {
        'userid': setting.userId,
        'charityid': setting.charityId,
        'isactive': setting.isActive,
      };

  Map<String, dynamic> _roundupSettingToMap(RoundupSetting setting) => {
        'userid': setting.userId,
        'charityid': setting.charityId,
        'isactive': setting.isActive,
        'monthlycap': setting.monthlyCap,
        'donation_threshold': setting.donationThreshold,
        'roundup_amount': setting.roundupAmount,
        'running_total': setting.runningTotal,
        'totalytd': setting.totalYtd,
      };
}
