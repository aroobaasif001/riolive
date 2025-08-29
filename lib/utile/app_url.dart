class AppUrl {
  static var baseUrl = "https://backend-api-six-drab.vercel.app";

  static var signup = "${baseUrl}/api/users/signup";
  static var login = "${baseUrl}/api/users/login";
  static var logout = "${baseUrl}/api/users/logout";
  static var stayLogin = "${baseUrl}/api/users/stay-login";
  static var sendOTP = "${baseUrl}/api/agencies/get-code";
  static var createAgency = "${baseUrl}/api/agencies/apply";

  static var startVideoCall = "${baseUrl}/api/random/calls/start";
  static var joinVideoCall = "${baseUrl}/api/random/calls/join/";
  static var endVideoCall = "${baseUrl}/api/random/calls/end/";
  static var lastestVideoCall = "${baseUrl}/api/random/calls/latest";

  static var riolive_id;
  static var token;
}
