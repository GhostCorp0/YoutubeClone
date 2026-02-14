import 'package:freezed_annotation/freezed_annotation.dart';
part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String displayName,
    required String username,
    required String email,
    required String profilePic,
    required List<String> subscriptions,
    required int videos,
    required String userId,
    required String description,
    required String type,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}