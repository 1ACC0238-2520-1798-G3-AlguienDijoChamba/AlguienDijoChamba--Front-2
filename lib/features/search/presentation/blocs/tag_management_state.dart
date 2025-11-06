import 'package:alguiendijochamba_app_flutter/features/search/domain/entities/tag_entities.dart';
import 'package:equatable/equatable.dart';

// --- Clases Base ---
abstract class TagManagementState extends Equatable {
  const TagManagementState();
  @override
  List<Object> get props => [];
}

// --- Estados Específicos ---

// 1. Estado Inicial/Cargando Catálogo
class TagManagementInitial extends TagManagementState {}
class TagManagementLoading extends TagManagementState {}

// 2. Catálogo Cargado y Listo para Selección
class TagManagementLoaded extends TagManagementState {
  final List<TagEntity> availableTags;      // Todo el catálogo
  final List<String> selectedTagIds;       // IDs actualmente seleccionados por el profesional
  
  const TagManagementLoaded({
    required this.availableTags,
    required this.selectedTagIds,
  });

  @override
  List<Object> get props => [availableTags, selectedTagIds];
  
  // Método útil para que el Cubit no tenga que recrear todo
  TagManagementLoaded copyWith({
    List<TagEntity>? availableTags,
    List<String>? selectedTagIds,
  }) {
    return TagManagementLoaded(
      availableTags: availableTags ?? this.availableTags,
      selectedTagIds: selectedTagIds ?? this.selectedTagIds,
    );
  }
}

// 3. Guardando Cambios
class TagManagementSaving extends TagManagementState {}

// 4. Éxito y Error
class TagManagementSuccess extends TagManagementState {
  final String message;
  const TagManagementSuccess(this.message);
  @override
  List<Object> get props => [message];
}

class TagManagementError extends TagManagementState {
  final String message;
  const TagManagementError(this.message);
  @override
  List<Object> get props => [message];
}