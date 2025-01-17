class ImagesUtils {
  static const _assetPath = 'assets/images/';
  static const logo = '${_assetPath}logo.png';
  static const cartIcon = '${_assetPath}cart_icon.png';
  static const pickImageIcon = '${_assetPath}pick_image_icon.png';
  static const noCourses = '${_assetPath}no_courses.png';
  static const linkIcon = '${_assetPath}link.png';

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
