class ApiRequest {
  const ApiRequest(this.name);
  final String name;
}

class LabApiRequest extends ApiRequest {
  const LabApiRequest(String name) : super(name);

  static const auth = LabApiRequest('auth/signin');
  static const register = LabApiRequest('auth/register');
  static const signOut = LabApiRequest('auth/signout');
  static const statistics = LabApiRequest('Statistics');
  static const checkAnswer = LabApiRequest('Tasks/check');
  static const taskByFilter = LabApiRequest('Tasks/byfilter');
  static const tasks = LabApiRequest('Tasks');
  static const themes = LabApiRequest('Themes');
  static const users = LabApiRequest('User');
}
