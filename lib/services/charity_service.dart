import 'package:ripple/models/charity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CharityService {
  static const String _charityTable = "charity";

  Future<List<Charity>> getCharities() async {
    var result = await Supabase.instance.client.from(_charityTable).select();

    return result.map(_mapToCharity).toList();
  }

  Charity _mapToCharity(Map<String, dynamic> map) => Charity(
        id: map['charityid'],
        charityName: map['charityname'],
        charityDescription: map['description'],
        logo: _parseCharityLogo(map['logo']),
        isActive: map['isactive'],
        cause: _parseCharityCause(
          map['cause'],
        ),
      );

  CharityLogo _parseCharityLogo(String logo) => switch (logo) {
        'our' => CharityLogo.our,
        'feedingAmerica' => CharityLogo.feedingAmerica,
        'salvationArmy' => CharityLogo.feedingAmerica,
        'stJude' => CharityLogo.stJude,
        'americanCancerSociety' => CharityLogo.americanCancerSociety,
        String() => throw UnimplementedError(),
      };

  CharityCause _parseCharityCause(String cause) => switch (cause) {
        'agriculture' => CharityCause.agriculture,
        'health' => CharityCause.health,
        'humanitarian' => CharityCause.humanitarian,
        'trafficking' => CharityCause.trafficking,
        String() => CharityCause.other,
      };
}
