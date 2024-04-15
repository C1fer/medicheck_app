import '../enums.dart';

extension StringExtension on String {
  String toSentenceCase() {
    return trim()[0].toUpperCase() + substring(1).toLowerCase();
  }

  String toProperCase() {
    return trim()
        .split(" ")
        .map((e) => e[0].toUpperCase() + e.substring(1).toLowerCase())
        .join(' ');
  }


  String toProperCaseData() {


    return trim()
        .split(" ")
        .map((e) {
      // Return excluded words as lowercase
      if (Constants.excludedWords.contains(e.toLowerCase())) {
        return e.toLowerCase();
      } else {
        return e[0].toUpperCase() + e.substring(1).toLowerCase();
      }
    })
        .join(' ');
  }


  String replaceUnderScores(){
    return replaceAll("_", " ");
  }

}
