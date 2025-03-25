import 'package:ripple/models/charity.dart';
import 'package:ripple/models/donation_history.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DonationHistoryService {
  static const String _donationHistoryView = "get_donation_history";

  Future<List<DonationHistory>> getDonationHistory(int userId) async {
    var result = await Supabase.instance.client
        .from(_donationHistoryView)
        .select()
        .match({'userid': userId});
    return result.map(_mapToDonationHistory).toList();
  }

  DonationHistory _mapToDonationHistory(Map<String, dynamic> map) =>
      DonationHistory(
        id: map['donationid'],
        charityId: map['charityid'],
        userId: map['userid'],
        charityName: map['charityname'],
        charityLogo: _parseCharityLogo(map['logo']),
        donationAmount: map['donation_amount'] is int
            ? (map['donation_amount'] as int).toDouble()
            : (map['donation_amount'] as double).toDouble(),
        donationDate: DateTime.tryParse(map['donationdate'])!,
      );

  CharityLogo _parseCharityLogo(String logo) => switch (logo) {
        'our' => CharityLogo.our,
        'feedingAmerica' => CharityLogo.feedingAmerica,
        'salvationArmy' => CharityLogo.salvationArmy,
        'stJude' => CharityLogo.stJude,
        'americanCancerSociety' => CharityLogo.americanCancerSociety,
        String() => throw UnimplementedError(),
      };
}
