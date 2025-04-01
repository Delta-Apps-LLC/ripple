import 'package:ripple/models/address.dart';

enum OnboardLevel { howItWorks, selectCharity, connectBank, complete }

class Person {
  final int? id;
  final Address? address;
  final String firstName;
  final String lastName;
  final String email;
  final OnboardLevel onboardLevel;

  const Person({
    this.id,
    this.address,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.onboardLevel,
  });
}
