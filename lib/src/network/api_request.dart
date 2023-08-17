import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import '../../src/model/otp_response.dart';

class ApiRequest {
  String baseURL =
      'http://sms.mobi-marketing.biz/api/mt/SendSMS?user=demo&password=demo123&senderid=WEBSMS&channel=Promo&DCS=8&flashsms=0&';
  Client client = Client();

  sendUID(String number,String uID)async{
    try{
      var res = await client.get(Uri.parse('$baseURL+number=91$number&text=ధన్యవాదాలు ఇది మీ భవిష్యత్తుకు గ్యారెంటీ రిజిస్ట్రేషన్ సర్టిఫికేట్  %23%23$uID%23%23&route=1##'));
      if(res.statusCode==200){
       var body = jsonDecode(utf8.decode(res.bodyBytes));
       AppResponse appResponse = AppResponse.fromJson(body);
       if(appResponse.errCode=="000"){
        return "Message has sent successfully to registered number";
       }else{
        throw Exception(appResponse.errMsg);
       }
      }
    }on SocketException catch (_) {
      throw Exception('No Internet Connection');
    }catch(e){
      throw Exception(e);
    }
  }



}
