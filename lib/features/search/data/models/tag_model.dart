
import 'package:alguiendijochamba_app_flutter/features/search/domain/entities/tag_entities.dart';

class TagModel extends TagEntity {
  const TagModel({required super.id, required super.name});

  factory TagModel.fromJson(Map<String, dynamic> json) {
    return TagModel(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }
}