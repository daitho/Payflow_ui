abstract final class AppConfig {
  // Override the backend origin without editing source:
  // flutter run --dart-define=API_BASE_URL=https://YOUR_BACKEND_HOST
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://livable-cruncher-cloning.ngrok-free.dev',
  );
}
