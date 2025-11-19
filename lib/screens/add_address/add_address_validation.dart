import '/constants/app_strings.dart';
import '/widgets/app_snackbar.dart';

class AddAddressValidation {







  // Phone validation
  static int? phoneValidation({required int phone}) {
    if (phone.toString().length != 10) {
      appSnackbar(error: true, content: AppStrings.invalid_phone);

      return 0;
    }

    return null;
  }




// Name validation
static String? nameValidation({required String name}) {
  if (name.isEmpty ||
      !RegExp(r"^[a-zA-Z ]{3,}$").hasMatch(name)) {
    appSnackbar(error: true, content: AppStrings.invalid_name);
    return '';
  }
  return null;
}


// Street Name Validatioin
static String? streetValidation({required String street}) {
  if (street.isEmpty ||
      !RegExp(r"^[a-zA-Z0-9\s.,'-]{3,}$").hasMatch(street)) {
    appSnackbar(error: true, content: AppStrings.invalid_street);
    return '';
  }
  return null;
}

// City Validation
static String? cityValidation({required String city}) {
  if (city.isEmpty ||
      !RegExp(r"^[a-zA-Z\s'-]{2,}$").hasMatch(city)) {
    appSnackbar(error: true, content: AppStrings.invalid_city);
    return '';
  }
  return null;
}

// State Valiadtion
static String? stateValidation({required String state}) {
  if (state.isEmpty ||
      !RegExp(r"^[a-zA-Z\s'-]{2,}$").hasMatch(state)) {
    appSnackbar(error: true, content: AppStrings.invalid_state);
    return '';
  }
  return null;
}

// Country Validation
static String? countryValidation({required String country}) {
  if (country.isEmpty ||
      !RegExp(r"^[a-zA-Z\s'-]{2,}$").hasMatch(country)) {
    appSnackbar(error: true, content: AppStrings.invalid_country);
    return '';
  }
  return null;
}

// ZipCode Validation 
static String? zipValidation({required String zip}) {
  if (zip.isEmpty ||
      !RegExp(r"^[0-9]{4,10}$").hasMatch(zip)) {
    appSnackbar(error: true, content: AppStrings.invalid_zip);
    return '';
  }
  return null;
}

}