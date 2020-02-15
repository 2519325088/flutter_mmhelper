import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mmhelper/Models/CountryCodeModel.dart';

class GetCountryListService with ChangeNotifier {
  List<CountryCode> listCountry = [];
  bool isFirst = true;
  String selectedCountry = "Select Country";
  String selectedCountryCode = "Select Code";
  String selectedLoginCountry = "Select Country";
  String selectedLoginCountryCode = "Select Code";

  newCountry({String newCountry,String newCountryCode}){
    selectedCountry = newCountry;
    selectedCountryCode = newCountryCode;
    notifyListeners();
  }

  newLoginCountry({String newCountry,String newCountryCode}){
    selectedLoginCountry = newCountry;
    selectedLoginCountryCode = newCountryCode;
    notifyListeners();
  }

  Future<String> loadStateJson() async {
    return await rootBundle.loadString('assets/Countrylist.json');
  }

  getCountryList() {
    if (isFirst) {
      isFirst = false;
      listCountry = [];
      loadStateJson().then((jsonString) {
        listCountry = countryCodeFromJson(jsonString);
        notifyListeners();
      });
    }
  }
}
