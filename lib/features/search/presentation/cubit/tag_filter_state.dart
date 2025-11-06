import 'package:alguiendijochamba_app_flutter/features/search/domain/entities/tag_entities.dart';
import 'package:equatable/equatable.dart';

abstract class TagFilterState extends Equatable {
  const TagFilterState();
  @override
  List<Object> get props => [];
}

class TagFilterLoading extends TagFilterState {}

class TagFilterLoaded extends TagFilterState {
  final List<TagEntity> availableTags;    // Catálogo completo de opciones
  final List<String> selectedTagIds;       // IDs seleccionados actualmente por el CLIENTE (para filtrar)
  
  const TagFilterLoaded({
    required this.availableTags,
    required this.selectedTagIds,
  });

  @override
  List<Object> get props => [availableTags, selectedTagIds];
  
  TagFilterLoaded copyWith({
    List<TagEntity>? availableTags,
    List<String>? selectedTagIds,
  }) {
    return TagFilterLoaded(
      availableTags: availableTags ?? this.availableTags,
      selectedTagIds: selectedTagIds ?? this.selectedTagIds,
    );
  }
}

class TagFilterError extends TagFilterState {
  final String message;
  const TagFilterError(this.message);
  @override
  List<Object> get props => [message];
}