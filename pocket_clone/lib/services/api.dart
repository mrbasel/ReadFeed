// This file contains functions for interacting with an external api

import 'package:http/http.dart' as http;
import 'dart:convert';


getArticle(String articleUrl) async{
  Uri url = Uri.http('0d01ec0852f1.ngrok.io', '/save', {'url': articleUrl});
  var response = await http.get(url);
  Map data = jsonDecode(response.body);
  return data;   
}