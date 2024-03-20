extension StringExtension on String {
  String toSentenceCase() {
    return this[0].toUpperCase() + this.substring(1).toLowerCase();
  }

  String toProperCase() {
   final x = this.split(" ");
   final y = x.map((e) => e[0].toUpperCase() + e.substring(1).toLowerCase()).join(' ');
   return y;
  }
}
