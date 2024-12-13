String calculateDurationInHourMin(Duration duration) {
  return '${duration.inHours}${duration.inMinutes.remainder(60) == 0?' hours':'h'} ${duration.inMinutes.remainder(60) == 0 ? '' : '${duration.inMinutes.remainder(60)}m'}';
}

String formatDurationWithColon(int seconds) {
  int hours = seconds ~/ 3600;
  int minutes = (seconds % 3600) ~/ 60;
  int remainingSeconds = seconds % 60;

  if (hours > 0) {
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  } else {
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
