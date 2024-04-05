class GooglePlace {
  String id;
  String name;
  String? phoneNumber;
  String formattedAddress;
  String shortFormattedAddress;
  String primaryType;
  String primaryTypeDisplay;
  String? photoUri;
  String? websiteUri;
  bool? openNow;
  List<String>? workingHoursDescription;
  double lat;
  double lon;

  GooglePlace(
      {required this.id,
      required this.name,
      this.phoneNumber,
      required this.formattedAddress,
      required this.shortFormattedAddress,
      required this.primaryType,
      required this.primaryTypeDisplay,
      this.photoUri,
      this.websiteUri,
      this.openNow,
      this.workingHoursDescription,
      required this.lat,
      required this.lon}
      );

  factory GooglePlace.fromJson(Map<String, dynamic> json) => GooglePlace(
      id: json["id"],
      name: json["displayName"]["text"],
      phoneNumber: json["internationalPhoneNumber"],
      formattedAddress: json["formattedAddress"],
      shortFormattedAddress: json["shortFormattedAddress"],
      primaryType: json["primaryType"],
      primaryTypeDisplay: json["primaryTypeDisplayName"]["text"],
      photoUri: json["photos"] != null ? json["photos"][0]["name"] : null,
      websiteUri: json["websiteUri"],
      openNow: json["currentOpeningHours"] != null
          ? json["currentOpeningHours"]["openNow"]
          : null,
      workingHoursDescription: json["currentOpeningHours"] != null
          ? List<String>.from(
              json["currentOpeningHours"]["weekdayDescriptions"])
          : null,
      lat: json["location"]["latitude"],
      lon: json["location"]["longitude"]
  );
}
