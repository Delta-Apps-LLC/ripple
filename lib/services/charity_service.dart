import 'package:ripple/models/charity.dart';
import 'package:ripple/models/user_charity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CharityService {
  static const String _charityTable = "charity";
  static const String _userCharityTable = 'user_charity';
  static const String _getCharityQueueView = 'get_charity_queue';

  Future<List<Charity>> getCharities() async {
    var result = await Supabase.instance.client
        .from(_charityTable)
        .select()
        .order('charityname', ascending: true);

    return result.map(_mapToCharity).toList();
  }

  Future<List<Charity>> getCharityQueue(int userId) async {
    final result = await Supabase.instance.client
        .from(_getCharityQueueView)
        .select()
        .match({'userid': userId});
    return result.map(_mapToCharity).toList();
  }

  Future<List<UserCharity>> insertFirstUserCharity(
      int charityId, int userId) async {
    final result =
        await Supabase.instance.client.from(_userCharityTable).insert({
      'userid': userId,
      'charityid': charityId,
    }).select();
    return [_mapToUserCharity(result.first)];
  }

  Future<void> saveQueueEdits(int userId, List<Charity> newQueue) async {
    await Supabase.instance.client
        .from(_userCharityTable)
        .delete()
        .eq('userid', userId);

    final List<Map<String, dynamic>> insertData = newQueue
        .map((charity) => {
              'userid': userId,
              'charityid': charity.id,
            })
        .toList();

    await Supabase.instance.client.from(_userCharityTable).insert(insertData);
  }

  UserCharity _mapToUserCharity(Map<String, dynamic> map) =>
      UserCharity(userId: map['userid'], charityId: map['charityid']);

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
        'salvationArmy' => CharityLogo.salvationArmy,
        'stJude' => CharityLogo.stJude,
        'americanCancerSociety' => CharityLogo.americanCancerSociety,
        'doctorsWithoutBorders' => CharityLogo.doctorsWithoutBorders,
        'noKidHungry' => CharityLogo.noKidHungry,
        'worldWildlife' => CharityLogo.worldWildlife,
        String() => throw UnimplementedError(),
      };

  CharityCause _parseCharityCause(String cause) => switch (cause) {
        'agriculture' => CharityCause.agriculture,
        'health' => CharityCause.health,
        'humanitarian' => CharityCause.humanitarian,
        'trafficking' => CharityCause.trafficking,
        'hunger' => CharityCause.hunger,
        'conservation' => CharityCause.conservation,
        String() => CharityCause.other,
      };
}
