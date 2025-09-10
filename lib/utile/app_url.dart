class AppUrl {
  ///Base URL
  // static var baseUrl = "http://192.168.1.17:5000";
  static var baseUrl = "https://backend-api-1-zmcd.onrender.com";

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
  static var rejectVideoCall = "${baseUrl}/api/random/calls/reject/";
  static var getCallStatus = "${baseUrl}/api/random/calls/status/";
  // static var lastestVideoCall = "${baseUrl}/api/random/calls/latest";

  ///Private Call Api's
  static var privateCallRequest = "${baseUrl}/api/private/calls/request";
  static var privateCallAccept = "${baseUrl}/api/private/calls/accept/";
  static var privateCallReject = "${baseUrl}/api/private/calls/reject/";
  static var privateCallEnd = "${baseUrl}/api/private/calls/end/";
  static var privateCallStatus = "${baseUrl}/api/private/calls/status/";

  ///Live Streaming Api's
  static var goLiveCall = "${baseUrl}/api/hosts/go-live";
  static var offLiveLiveCall = "${baseUrl}/api/hosts/go-offline";
  static var liveListCall = "${baseUrl}/api/hosts/live-list";
  static var availableHostsCall = "${baseUrl}/api/hosts/available"; // Alternative endpoint
  static var liveHostsCall = "${baseUrl}/api/random/calls/hosts"; // For random call hosts

  ///Agora Token Api
  static var agoraToken = "${baseUrl}/api/agora/token";

  ///Global Variables
  static var riolive_id;
  static var token;
  static var user_name;
  static var email;
  static var user_role;
}
