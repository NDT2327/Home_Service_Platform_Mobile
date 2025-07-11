class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return "Email is required";
    final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) return "Invalid email format";
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return "Password is required";
    if (value.length < 6) return "Password must be at least 6 characters";
    return null;
  }

  static String? validateFullName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter full name';
    }
    if (value.length < 2) {
      return 'Full name must be at least 2 characters';
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value != null && value.isNotEmpty && !RegExp(r'^\d{10}$').hasMatch(value)) {
      return 'Invalid phone number (must be 10 digits)';
    }
    return null;
  }

  static String? validateAddress(String? value) {
    if (value != null && value.isNotEmpty && value.length < 5) {
      return 'Address must be at least 5 characters';
    }
    return null;
  }
}
