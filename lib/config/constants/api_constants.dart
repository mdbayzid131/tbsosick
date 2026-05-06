class ApiConstants {
  // Base URLs
  static const String baseUrl = 'http://10.10.7.47:5001/api/v1';
  // static const String baseUrl = 'https://nayem5001.binarybards.online/api/v1';
  // static const String apiVersion = '';
  //
  // Auth Endpoints
  static const String login = '/auth/login';
  static const String signup = '/users';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';
  static const String forgotPassword = '/auth/forgot-password';

  // User Endpoints
  static const String completeOnboarding = '/users/complete-onboarding';
  static const String resendVerifyEmail = '/auth/resend-otp';
  static const String verifyEmail = '/auth/verify-otp';
  static const String resetPassword = '/auth/reset-password';

  //  Endpoints
  static const String getSuppliesList = '/supplies';
  static const String getSuturesList = '/sutures';

  static const String profile = '/user/profile';
  static const String getCardCount = '/preference-cards/stats';
  static const String getAllCard = '/preference-card';
  static const String getAllCardsList = '/preference-cards';
  static const String getPublicCard = '/preference-card/public';
  static const String getPrivateCard = '/preference-card/private';
  static const String getCardDetails = '/preference-card/{id}';
  static const String downloadCard = '/preference-card/{id}/download';
  static const String addToFavoriteList = '/preference-card/{id}/favorite';
  static const String removeFromFavoriteList = '/preference-card/{id}/favorite';
  // static const String getFavoriteCard = '/preference-card/favorite';
  static const String getFavoriteCard = '/preference-card/favorites';

  // Event Endpoints
  static const String getEventsList = '/events';
  static const String getEventDetailById = '/events/{id}';
  static const String postEvent = '/events';
  static const String patchEvent = '/events/{id}';
  static const String deleteEvent = '/events/{id}';

  // Google Sign In
  static const String googleSignIn = '/auth/google';
  static const String appleSignIn = '/auth/apple';
  static const String socialLogin = '/auth/social-login';
}
