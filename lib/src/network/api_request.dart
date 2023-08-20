import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import '../../src/model/otp_response.dart';

class ApiRequest {
  static const String message1 =
      "మీ భవిష్యత్తుకు గ్యారెంటీ యూఐడీ నెంబరు నమోదు కోసం";
  static const String baseURL =
      'http://sms.mobi-marketing.biz/api/mt/SendSMS?user=Showtime&password=abcd@4321D&senderid=APHOPE&channel=Trans&DCS=8&flashsms=0';
  Client client = Client();
  var headers = {
    "Content-Type": "text/plain",
  };

  Future<String> sendUID(String number, String uID) async {
    try {
      
      var res = await client
          .get(Uri.parse("$baseURL&number=91$number&text=%E0%B0%A7%E0%B0%A8%E0%B1%8D%E0%B0%AF%E0%B0%B5%E0%B0%BE%E0%B0%A6%E0%B0%BE%E0%B0%B2%E0%B1%81%20%E0%B0%87%E0%B0%A6%E0%B0%BF%20%E0%B0%AE%E0%B1%80%20%E0%B0%AD%E0%B0%B5%E0%B0%BF%E0%B0%B7%E0%B1%8D%E0%B0%AF%E0%B0%A4%E0%B1%8D%E0%B0%A4%E0%B1%81%E0%B0%95%E0%B1%81%20%E0%B0%97%E0%B1%8D%E0%B0%AF%E0%B0%BE%E0%B0%B0%E0%B1%86%E0%B0%82%E0%B0%9F%E0%B1%80%20%E0%B0%B0%E0%B0%BF%E0%B0%9C%E0%B0%BF%E0%B0%B8%E0%B1%8D%E0%B0%9F%E0%B1%8D%E0%B0%B0%E0%B1%87%E0%B0%B7%E0%B0%A8%E0%B1%8D%20%E0%B0%B8%E0%B0%B0%E0%B1%8D%E0%B0%9F%E0%B0%BF%E0%B0%AB%E0%B0%BF%E0%B0%95%E0%B1%87%E0%B0%9F%E0%B1%8D%20$uID&route=1##"),headers: headers);
      var body = jsonDecode(utf8.decode(res.bodyBytes));
      AppResponse appResponse = AppResponse.fromJson(body);
      if (res.statusCode == 200) {
        if (appResponse.errCode == "000") {
          return "Message has sent successfully to registered number";
        } else {
          throw Exception(appResponse.errMsg);
        }
      } else {
        return appResponse.errMsg!;
      }
    } on SocketException catch (_) {
      throw Exception('No Internet Connection');
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }

  Future<String> sendFinalMsg(String number, String link) async {
    try {
      var res = await client.get(Uri.parse(
          '$baseURL+number=91$number&text=ధన్యవాదాలు ఇది మీ భవిష్యత్తుకు గ్యారెంటీ రిజిస్ట్రేషన్ సర్టిఫికేట్  %23%23$link%23%23&route=1##'));

      var body = jsonDecode(utf8.decode(res.bodyBytes));
      AppResponse appResponse = AppResponse.fromJson(body);
      if (res.statusCode == 200) {
        if (appResponse.errCode == "000") {
          return "Message has sent successfully to registered number";
        } else {
          throw Exception(appResponse.errMsg);
        }
      } else {
        return appResponse.errMsg!;
      }
    } on SocketException catch (_) {
      throw Exception('No Internet Connection');
    } catch (e) {
      throw Exception(e);
    }
  }
}
