class ApiEndpoints {
  ///<========================base url=====================================>

  static String baseUrl="http://10.10.7.33:5002/api/v1";

  ///<========================auth end points=====================================>`
  static String login = "$baseUrl/auth/login";
  static String createParentAccount = "$baseUrl/user";
  static String forgotPassword = "$baseUrl/auth/forget-password";
  static String resendVerifyEmail = "$baseUrl/auth/resend-verify-email";
  static String verifyEmail = "$baseUrl/auth/verify-email";
  static String resetPassword = "$baseUrl/auth/reset-password?token=RESET_TOKEN_FROM_EMAIL";

  static String refreshToken = "$baseUrl/auth/refresh-token";
  static String logout = "$baseUrl/auth/logout";
  static String changePassword = "$baseUrl/auth/change-password";


  static String getProfile = "$baseUrl/user/profile";
  static String updateProfile = "$baseUrl/user/profile";

  static String getChildrenProfile = "$baseUrl/children";
  static String updateChildProfile({required String childId}) => "$baseUrl/children/$childId";

  static String createChildProfile = "$baseUrl/children";





}