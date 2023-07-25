// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomMessage _$CustomMessageFromJson(Map<String, dynamic> json) =>
    CustomMessage(
      fromID: json['fromID'] as String,
      toID: json['toID'] as String,
      message: json['message'] as String,
      type: json['type'] as String,
      read: json['read'] as String,
      sent: json['sent'] as String,
    );

Map<String, dynamic> _$CustomMessageToJson(CustomMessage instance) =>
    <String, dynamic>{
      'fromID': instance.fromID,
      'toID': instance.toID,
      'message': instance.message,
      'type': instance.type,
      'read': instance.read,
      'sent': instance.sent,
    };
