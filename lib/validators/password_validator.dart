extension PasswordValidator on String? {
  bool isValidPassword() {
    return RegExp(
            r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
        .hasMatch(this ?? '');
  }
}

const passwordRequirements =
    'Your password must meet the following complexity requirements:\n'
    '- Minimum length of 8 characters\n'
    '- Include at least one uppercase letter (A-Z)\n'
    '- Include at least one lowercase letter (a-z)\n'
    '- Include at least one number (0-9)\n'
    '- Include at least one special character (e.g., !, @, #, %)';
