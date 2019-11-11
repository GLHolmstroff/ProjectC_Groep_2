enum FormType { login, register, editprofile }

class EmailValidator {
  static String validate(String value) {
    return value.isEmpty ? "Dit veld mag niet leeg zijn" : null;
  }
}

class PasswordValidator {
  static String validate(String value) {
    return value.isEmpty ? "Dit veld mag niet leeg zijn" : null;
  }
}

class NameValidator {
  static String validate(String value) {
    return value.isEmpty ? "Dit veld mag niet leeg zijn" : null;
  }
}
