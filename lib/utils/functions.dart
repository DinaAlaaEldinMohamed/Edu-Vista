String formatDuration(int? duration) {
  if (duration == null || duration <= 0) {
    return '0 sec';
  }

  if (duration < 60) {
    return '${duration} sec';
  }

  int minutes = duration ~/ 60; // Integer division for minutes
  int seconds = duration % 60; // Remainder for seconds

  if (seconds > 0) {
    return '${minutes} min ${seconds} sec';
  } else {
    return '${minutes} min';
  }
}
