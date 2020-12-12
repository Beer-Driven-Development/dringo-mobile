class AppUrl {
  static const String liveBaseURL = "https://dringo.herokuapp.com";
  static const String localBaseURL = "http://10.0.2.2:3000";
  static const String liveWsURL = "ws://dringo.herokuapp.com";
  static const String localWsURL = "ws://10.0.2.2:3000";
  static const String baseURL = liveBaseURL;
  static const String baseWsURL = liveBaseURL;

  static const String login = baseURL + "/auth/login";
  static const String register = baseURL + "/auth/register";
  static const String google = baseURL + "/auth/google";
  static const String facebook = baseURL + "/auth/facebook";

  static const String rooms = baseURL + "/rooms";
  static const String categories = baseURL + "/categories";
}
