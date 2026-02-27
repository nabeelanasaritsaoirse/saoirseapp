class AddAddressValidation {
  // Phone validation
  // Phone validation
  static String? phoneValidation({required String phone}) {
    phone = phone.trim();

    if (phone.isEmpty) {
      return "Please enter your phone number";
    }

    // Must start with 6,7,8 or 9 and be exactly 10 digits
    if (!RegExp(r'^[6-9][0-9]{9}$').hasMatch(phone)) {
      return "Enter a valid 10-digit mobile number starting with 6–9.";
    }

    return null;
  }

  // Name validation
  static String? nameValidation({required String name}) {
    if (name.trim().isEmpty) return "Name is required";
    if (name.length < 3) return "Enter a valid name";
    if (!RegExp(r"^[a-zA-Z\s.'-]+$").hasMatch(name)) {
      return "Invalid name format";
    }
    return null;
  }

  // Street Name Validation
  static String? streetValidation({required String street}) {
    if (street.trim().isEmpty) return "Street name is required";
    if (street.length < 3) return "Enter a valid street name";
    return null;
  }

  // City Validation
  static String? cityValidation({required String city}) {
    if (city.trim().isEmpty) return "City is required";
    if (!RegExp(r"^[a-zA-Z\s.'-]+$").hasMatch(city)) {
      return "Invalid city name";
    }
    return null;
  }

  // State Validation
  static String? stateValidation({required String state}) {
    if (state.trim().isEmpty) return "State is required";
    if (!RegExp(r"^[a-zA-Z\s.'-]+$").hasMatch(state)) {
      return "Invalid state name";
    }
    return null;
  }

  // Country Validation
  static String? countryValidation({required String country}) {
    if (country.trim().isEmpty) return "Country is required";
    if (!RegExp(r"^[a-zA-Z\s.'-]+$").hasMatch(country)) {
      return "Invalid country name";
    }
    return null;
  }

  // Zip Code Validation
  // Pin Code Validation
  static String? zipValidation({required String zip}) {
    zip = zip.trim();

    if (zip.isEmpty) {
      return "Pin code is required";
    }

    // Must be exactly 6 digits
    if (!RegExp(r'^[0-9]{6}$').hasMatch(zip)) {
      return "Invalid 6-digit PIN code";
    }

    return null;
  }
}
