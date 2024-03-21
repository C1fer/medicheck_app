class GooglePlace {
  String name;
  String phoneNumber;
  String formattedAddress;
  String shortFormattedAddress;
  String primaryType;
  String primaryTypeDisplay;
  String? photoUri;
  String? websiteUri;
  bool openNow;
  List<String> workingHoursDescription;

  GooglePlace(
      {required this.name,
      required this.phoneNumber,
      required this.formattedAddress,
      required this.shortFormattedAddress,
      required this.primaryType,
      required this.primaryTypeDisplay,
      this.photoUri,
      this.websiteUri,
      required this.openNow,
      required this.workingHoursDescription});

  factory GooglePlace.fromJson(Map<String, dynamic> json) => GooglePlace(
      name: json["displayName"]["text"],
      phoneNumber: json["internationalPhoneNumber"],
      formattedAddress: json["formattedAddress"],
      shortFormattedAddress: json["shortFormattedAddress"],
      primaryType: json["primaryType"],
      primaryTypeDisplay: json["primaryTypeDisplayName"]["text"],
      photoUri: json["photos"] != null ? json["photos"][0]["name"] : null,
      websiteUri: json["websiteUri"],
      openNow: json["currentOpeningHours"]["openNow"],
      workingHoursDescription: List<String>.from(json["currentOpeningHours"]["weekdayDescriptions"]));
}
