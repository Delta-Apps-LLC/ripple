import 'package:ripple/models/address.dart';
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
        onboardLevel: _parseOnboardLevel(map['onboard_level']),
        address: _parseAddress(map['addressline1'], map['addressline2'],
            map['city'], map['state'], map['zip']),
      );

  Map<String, dynamic> _personToMap(Person person) => {
        'firstname': person.firstName,
        'lastname': person.lastName,
        'email': person.email,
        'onboard_level': _onboardLevelToString(person.onboardLevel),
        'addressline1': person.address?.line1,
        'addressline2': person.address?.line2,
        'city': person.address?.city,
        'state': person.address?.state,
        'zip': person.address?.zip,
      };

  Address? _parseAddress(String? addressLine1, String? addressLine2,
      String? city, String? state, String? zip) {
    if (addressLine1 == null) return null;
    return Address(
      line1: addressLine1,
      line2: addressLine2,
      city: city,
      state: state,
      zip: zip,
    );
  }

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
