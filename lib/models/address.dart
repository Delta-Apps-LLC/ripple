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
    if (line1 == null) return '';
    return '$line1\n$line2\n$city, $state $zip';
  }
}
