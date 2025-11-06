import 'package:equatable/equatable.dart';

class TagEntity extends Equatable {
  final String id;
  final String name;

  const TagEntity({required this.id, required this.name});

  // 🚀 El TRADUCTOR: Convierte Map<String, dynamic> (JSON) a TagEntity
  factory TagEntity.fromJson(Map<String, dynamic> json) {
    return TagEntity(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }

  @override
  List<Object?> get props => [id, name];
}