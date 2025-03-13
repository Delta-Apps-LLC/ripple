import 'package:ripple/models/person.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserIdentityService {
  static const String _personTable = "user";

  Future<Person?> getPersonInfo(String email) async {
    try {
      final result = await Supabase.instance.client
          .from(_personTable)
          .select()
          .match({'email': email});
      return result.map(_mapToPerson).first;
    } catch (err) {
      return null;
    }
  }

  Future<Person?> insertPerson(Person person) async {
    return _mapToPerson(
      (await Supabase.instance.client
              .from(_personTable)
              .insert(_personToMap(person))
              .select())
          .single,
    );
  }

  Future<Person?> updatePerson(Person person) async {
    return _mapToPerson(
      (await Supabase.instance.client
              .from(_personTable)
              .update(_personToMap(person))
              .match({'userid': person.id!}).select())
          .single,
    );
  }

  Future<Person?> deletePerson(Person person) async {
    return await Supabase.instance.client
        .from(_personTable)
        .delete()
        .match({'userid': person.id!});
  }

  Person? _mapToPerson(Map<String, dynamic> map) => Person(
      id: map['userid'],
      firstName: map['firstname'],
      lastName: map['lastname'],
      email: map['email'],
      onboardLevel: _parseOnboardLevel(map['onboard_level']));

  Map<String, dynamic> _personToMap(Person person) => {
        'firstname': person.firstName,
        'lastname': person.lastName,
        'email': person.email,
        'onboard_level': _onboardLevelToString(person.onboardLevel)
      };

  OnboardLevel _parseOnboardLevel(String level) => switch (level) {
        "howItWorks" => OnboardLevel.howItWorks,
        "selectCharity" => OnboardLevel.selectCharity,
        "connectBank" => OnboardLevel.connectBank,
        "complete" => OnboardLevel.complete,
        String() => throw UnimplementedError(),
      };

  String _onboardLevelToString(OnboardLevel level) => switch (level) {
        OnboardLevel.howItWorks => "howItWorks",
        OnboardLevel.selectCharity => "selectCharity",
        OnboardLevel.connectBank => "connectBank",
        OnboardLevel.complete => "complete"
      };
}
