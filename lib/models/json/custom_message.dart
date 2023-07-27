import 'package:json_annotation/json_annotation.dart';
part 'custom_message.g.dart';

@JsonSerializable()
class CustomMessage {
  String fromID;
  String toID;
  String message;
  String image;
  String type; //text or image
  String read;
  String sent;
  String imageReply; //path of the image to which current message is a reply
  String textReply; //text message to which current message is a reply

  CustomMessage({required this.fromID, required this.toID, required this.message, required this.image, required this.type, required this.read, required this.sent, required this.imageReply, required this.textReply});

  factory CustomMessage.fromJson(Map<String, dynamic> json) => _$CustomMessageFromJson(json);

  Map<String, dynamic> toJson() => _$CustomMessageToJson(this);
}