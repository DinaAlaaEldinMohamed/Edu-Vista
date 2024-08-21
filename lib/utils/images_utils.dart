class ImagesUtils {
  static const _assetPath = 'assets/images/';
  static const logo = '${_assetPath}logo.png';
  static const cartIcon = '${_assetPath}cart_icon.png';

  static const List<String> onboardingImages = [
    'certificate-and-badges.png',
    'progress-tracking.png',
    'offline-access.png',
    'course-catalog.png'
  ];

  static String getOnboardingImage(int index) {
    return '$_assetPath${onboardingImages[index]}';
  }
}
