class UserStorage {
  static final Map<String, String> _users = {
    'test': 'password',
  };

  static bool validateUser(String email, String password) {
    return _users[email] == password;
  }

  static void registerUser(String email, String password) {
    _users[email] = password;
  }
}
