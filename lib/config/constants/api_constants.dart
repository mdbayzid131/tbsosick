class ApiConstants {
  // Base URLs
  static const String baseUrl = 'http://10.10.7.33:5001/api/v1';
  // static const String apiVersion = '';
  //
  // Auth Endpoints
  static const String login = '/auth/login';
  static const String signup = '/user';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';
  static const String forgotPassword = '/auth/forget-password';

  // User Endpoints

  // Add your API endpoints here
  static const String resendVerifyEmail = '/auth/resend-verify-email';
  static const String verifyEmail = '/auth/verify-email';
  static const String resetPassword = '/auth/reset-password';

  //  Endpoints
  static const String getSuppliesList = '/supplies';
  static const String getSuturesList = '/sutures';

  static const String profile = '/user/profile';
  static const String getCardCount = '/preference-card/count';
  static const String getAllCard = '/preference-card';
  static const String getPublicCard = '/preference-card/public';
  static const String getPrivateCard = '/preference-card/private';
  static const String getCardDetails = '/preference-card/{id}';
  static const String downloadCard = '/preference-card/{id}/download';
  static const String addToFavoriteList = '/preference-card/{id}/favorite';
  static const String removeFromFavoriteList = '/preference-card/{id}/favorite';
  static const String getFavoriteCard = '/preference-card/favorite';


  // Event Endpoints
  static const String getEventsList = '/events';
  static const String getEventDetailById = '/events/{id}';
  static const String postEvent = '/events';
  static const String patchEvent = '/events/{id}';
  static const String deleteEvent = '/events/{id}';
}
