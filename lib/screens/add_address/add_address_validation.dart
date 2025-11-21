class AddAddressValidation {

  // Phone validation
  static String? phoneValidation({required String phone}) {
    if (phone.trim().isEmpty) return "Phone number is required";
    if (!RegExp(r'^[0-9]{10}$').hasMatch(phone)) {
      return "Enter a valid 10 digit phone number";
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
  static String? zipValidation({required String zip}) {
    if (zip.trim().isEmpty) return "Zip code is required";
    if (!RegExp(r"^[0-9]{4,10}$").hasMatch(zip)) {
      return "Enter valid zip code";
    }
    return null;
  }
}

