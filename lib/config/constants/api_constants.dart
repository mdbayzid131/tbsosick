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
}
