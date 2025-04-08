class Address {
  String? line1;
  String? line2;
  String? city;
  String? state;
  String? zip;

  Address({
    this.line1,
    this.line2,
    this.city,
    this.state,
    this.zip,
  });

  String formatAddress() {
    final List<String> addressParts = [];

    if (line1 != null && line1!.isNotEmpty) {
      addressParts.add(line1!);
    }
    if (line2 != null && line2!.isNotEmpty) {
      addressParts.add(line2!);
    }
    if ((city != null && city!.isNotEmpty) ||
        (state != null && state!.isNotEmpty) ||
        (zip != null && zip!.isNotEmpty)) {
      final List<String> cityStateZipParts = [];
      if (city != null && city!.isNotEmpty) {
        cityStateZipParts.add(city!);
      }
      if (state != null && state!.isNotEmpty) {
        cityStateZipParts.add(state!);
      }
      if (zip != null && zip!.isNotEmpty) {
        cityStateZipParts.add(zip!);
      }
      if (cityStateZipParts.isNotEmpty) {
        addressParts.add(cityStateZipParts.join(', '));
      }
    }

    return addressParts.join('\n');
  }
}
