class AppUrl {
  ///Base URL
  // static var baseUrl = "http://192.168.1.17:5000";
  static var baseUrl = "https://backend-api-pgu8.onrender.com";

  ///Registration Api's
  static var signup = "${baseUrl}/api/users/signup";
  static var login = "${baseUrl}/api/users/login";
  static var logout = "${baseUrl}/api/users/logout";
  static var stayLogin = "${baseUrl}/api/users/stay-login";
  static var sendOTP = "${baseUrl}/api/agencies/get-code";
  static var createAgency = "${baseUrl}/api/agencies/apply";

  ///Video Call Api's
  static var startVideoCall = "${baseUrl}/api/random/calls/start";
  static var joinVideoCall = "${baseUrl}/api/random/calls/join/";
  static var endVideoCall = "${baseUrl}/api/random/calls/end/";
  // static var lastestVideoCall = "${baseUrl}/api/random/calls/latest";

  ///Live Streaming Api's
  static var goLiveCall = "${baseUrl}/api/hosts/go-live";
  static var offLiveLiveCall = "${baseUrl}/api/hosts/go-offline";
  // static var liveListCall = "${baseUrl}/api/hosts/live-list"; // Removed - using direct URL now

  ///Agora Token Api
  static var agoraToken = "${baseUrl}/api/agora/token";

  ///Global Variables
  static var riolive_id;
  static var token;
  static var user_name;
  static var email;
  static var user_role;
}
