extension StringExtension on String {
  String toSentenceCase() {
    return this[0].toUpperCase() + this.substring(1).toLowerCase();
  }

  String toProperCase() {
    return this
        .split(" ")
        .map((e) => e[0].toUpperCase() + e.substring(1).toLowerCase())
        .join(' ');
  }
}
