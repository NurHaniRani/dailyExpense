import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RequestController {
  String path;
  String server;
  http.Response? _res;
  final Map<dynamic, dynamic> _body = {};
  final Map<String, String> _headers = {};
  dynamic _resultData;

  RequestController({required this.path, this.server = ""}){
    _loadApiAddress();
  }

  setBody(Map<String, dynamic> data) {
    _body.clear();
    _body.addAll(data);
    _headers["Content-Type"] = "application/json; charset=UTF-8";
  }

  Future<void> _loadApiAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedApiAddress = prefs.getString('apiAddress');
    if (savedApiAddress != null && savedApiAddress.isNotEmpty) {
      server = savedApiAddress;
    }
  }

  Future<void> post() async {
    _res = await http.post(
      Uri.parse(server + path),
      headers: _headers,
      body: jsonEncode(_body),
    );
    _parseResult();
  }

  Future<void> get() async {
    _res = await http.get(
      Uri.parse(server + path),
      headers: _headers,
    );
    _parseResult();
  }

  void _parseResult(){
    try{
      print("raw response:${_res?.body}");
      _resultData = jsonDecode(_res?.body?? "");
    }catch(ex){
      // otherwise the response body will be stored as is
      _resultData = _res?.body;
      print("exception in http result parsing ${ex}");
    }
  }
  dynamic result(){
    return _resultData;
  }
  int status() {
    return _res?.statusCode ?? 0;
  }
}