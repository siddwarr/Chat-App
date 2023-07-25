import 'package:json_annotation/json_annotation.dart';
part 'custom_message.g.dart';

@JsonSerializable()
class CustomMessage {
  String fromID;
  String toID;
  String message;
  String type; //text or image
  String read;
  String sent;

  CustomMessage({required this.fromID, required this.toID, required this.message, required this.type, required this.read, required this.sent});

  factory CustomMessage.fromJson(Map<String, dynamic> json) => _$CustomMessageFromJson(json);

  Map<String, dynamic> toJson() => _$CustomMessageToJson(this);
}