class AppUrl {
  static const String liveBaseURL = "https://dringo.herokuapp.com";
  static const String localBaseURL = "http://10.0.2.2:3000";
  static const String liveWsURL = "ws://dringo.herokuapp.com";
  static const String localWsURL = "ws://10.0.2.2:3000";
  static const String baseURL = localBaseURL;
  static const String baseWsURL = localWsURL;

  static const String login = baseURL + "/auth/login";
  static const String register = baseURL + "/auth/register";
  static const String google = baseURL + "/auth/google";

  static const String rooms = baseURL + "/rooms";
  static const String categories = baseURL + "/categories";
}
