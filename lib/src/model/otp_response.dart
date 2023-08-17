class AppResponse {
  String? errCode;
  String? errMsg;
  String? jobId;
  MessageData? msgData;
  String? templateId;
  AppResponse(
      {required this.errCode,
      required this.errMsg,
      required this.jobId,
      required this.msgData,
      required this.templateId});

  factory AppResponse.fromJson(Map<String, dynamic> json) => AppResponse(
      errCode: json['ErrorCode'],
      errMsg: json['ErrorMessage'],
      jobId: json['JobId'],
      msgData: json['MessageData'] != null
          ? MessageData.fromJson(json)
          : MessageData(msgId: "", number: ""), templateId: json['TemplateId']);
}

class MessageData {
  String? number;
  String? msgId;
  MessageData({required this.msgId, required this.number});

  factory MessageData.fromJson(Map<String, dynamic> json) =>
      MessageData(msgId: json['MessageId'], number: json['Number']);
}
