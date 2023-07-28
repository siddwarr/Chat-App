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
      image: json['image'] as String,
      type: json['type'] as String,
      read: json['read'] as String,
      sent: json['sent'] as String,
      imageReply: json['imageReply'] as String,
      textReply: json['textReply'] as String,
      isSelected: json['isSelected'] as bool,
      visibleTo: json['visibleTo'] as List<dynamic>
    );

Map<String, dynamic> _$CustomMessageToJson(CustomMessage instance) =>
    <String, dynamic>{
      'fromID': instance.fromID,
      'toID': instance.toID,
      'message': instance.message,
      'image': instance.image,
      'type': instance.type,
      'read': instance.read,
      'sent': instance.sent,
      'imageReply': instance.imageReply,
      'textReply': instance.textReply,
      'isSelected': instance.isSelected,
      'visibleTo': instance.visibleTo,
    };
