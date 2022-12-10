extension DateTimeExtensions on DateTime {
  String toFormattedString() {
    String minute = this.minute.toString();
    if (minute.length == 1) {
      minute = "0$minute";
    }
    return "$day.$month.$year $hour:$minute";
  }
}
