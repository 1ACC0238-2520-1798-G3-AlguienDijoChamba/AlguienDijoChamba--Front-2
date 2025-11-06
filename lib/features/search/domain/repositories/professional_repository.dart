// Archivo: lib/features/professional/domain/repositories/professional_repository.dart

import 'package:alguiendijochamba_app_flutter/features/search/domain/entities/search_profesional_entity.dart';
import 'package:alguiendijochamba_app_flutter/features/search/domain/query/search_professionals_query.dart';


abstract class ProfessionalRepository {
 Future<List<SearchedProfessionalEntity>> searchProfessionals(SearchProfessionalsQuery query);


}