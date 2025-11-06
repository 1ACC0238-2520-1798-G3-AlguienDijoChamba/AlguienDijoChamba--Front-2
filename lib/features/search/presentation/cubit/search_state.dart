import 'package:alguiendijochamba_app_flutter/features/search/domain/entities/search_profesional_entity.dart';
import 'package:equatable/equatable.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

class SearchInitial extends SearchState {}
class SearchLoading extends SearchState {}

// 🎯 CORRECCIÓN 1: Usar SearchedProfessionalEntity
class SearchLoaded extends SearchState {
  final List<SearchedProfessionalEntity> professionals;
  final bool hasMore;

  const SearchLoaded({
    required this.professionals,
    required this.hasMore,
  });

  @override
  List<Object> get props => [professionals, hasMore];
}

// 🎯 CORRECCIÓN 2: Usar SearchedProfessionalEntity
class SearchLoadingMore extends SearchState {
  final List<SearchedProfessionalEntity> professionals; 
  final bool hasMore; 

  const SearchLoadingMore({
    required this.professionals,
    required this.hasMore,
  });

  @override
  List<Object> get props => [professionals, hasMore];
}


class SearchError extends SearchState {
  final String message;

  const SearchError({required this.message});

  @override
  List<Object> get props => [message];
}