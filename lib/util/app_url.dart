class AppUrl {
  static const String liveBaseURL = "https://dringo.herokuapp.com";
  static const String localBaseURL = "http://10.0.2.2:3000";

  static const String baseURL = localBaseURL;
  static const String login = baseURL + "/auth/login";
  static const String register = baseURL + "/auth/register";
}
