
class MapUtils {
  static Uri generateGoogleMapsUrl(double latitude, double longitude) {
    return Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude',
    );
  }
}