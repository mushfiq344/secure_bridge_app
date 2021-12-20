import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:secure_bridges_app/utility/urls.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Network {
  //if you are using android studio emulator, change localhost to 10.0.2.2
  var token;

  _getToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    token = localStorage.getString('token');
    print("token : $token");
  }

  authData(data, apiUrl) async {
    var fullUrl = BASE_URL + apiUrl;
    return await http.post(Uri.parse(fullUrl),
        body: jsonEncode(data), headers: _setHeaders());
  }

  getData(apiUrl) async {
    var fullUrl = BASE_URL + apiUrl;
    await _getToken();
    return await http.get(Uri.parse(fullUrl), headers: _setHeaders());
  }

  postData(data, apiUrl) async {
    var fullUrl = BASE_URL + apiUrl;
    await _getToken();
    return await http.post(Uri.parse(fullUrl),
        body: jsonEncode(data), headers: _setHeaders());
  }

  putData(data, apiUrl) async {
    var fullUrl = BASE_URL + apiUrl;
    await _getToken();
    return await http.put(Uri.parse(fullUrl),
        body: jsonEncode(data), headers: _setHeaders());
  }

  deleteData(data, apiUrl) async {
    var fullUrl = BASE_URL + apiUrl;
    print("full uril : $fullUrl");
    await _getToken();
    return await http.delete(Uri.parse(fullUrl), headers: _setHeaders());
  }

  _setHeaders() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      };
}
