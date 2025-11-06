import 'package:equatable/equatable.dart';

class SearchProfessionalsQuery extends Equatable {
  final List<String> tagIds;
  final int page;
  final int limit;
  final String? searchTerm;
  final List<String> professionalIds; // << nuevo

  const SearchProfessionalsQuery({
    this.tagIds = const [],
    this.page = 1,
    this.limit = 10,
    this.searchTerm,
    this.professionalIds = const [],
  });

  SearchProfessionalsQuery copyWith({
    List<String>? tagIds,
    int? page,
    int? limit,
    String? searchTerm,
    List<String>? professionalIds,
  }) {
    return SearchProfessionalsQuery(
      tagIds: tagIds ?? this.tagIds,
      page: page ?? this.page,
      limit: limit ?? this.limit,
      searchTerm: searchTerm ?? this.searchTerm,
      professionalIds: professionalIds ?? this.professionalIds,
    );
  }

  Map<String, dynamic> toQueryParams() {
    final Map<String, dynamic> params = {
      'page': page.toString(),
      'limit': limit.toString(),
    };
    if (tagIds.isNotEmpty) params['tagIds'] = tagIds.join(',');
    if (searchTerm != null && searchTerm!.isNotEmpty) params['search'] = searchTerm!;
    if (professionalIds.isNotEmpty) params['professionalIds'] = professionalIds.join(','); // << nuevo
    return params;
  }

  @override
  List<Object?> get props => [tagIds, page, limit, searchTerm, professionalIds];
}