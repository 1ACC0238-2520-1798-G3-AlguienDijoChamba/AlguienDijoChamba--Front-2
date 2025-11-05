import 'package:flutter/material.dart';
import 'package:easy_load_more/easy_load_more.dart';
import '../widgets/professional_card.dart';
import '../../domain/entities/professional_entity.dart';
import '../../domain/repositories/professional_repository.dart';

class SearchPage extends StatefulWidget {
  final ProfessionalRepository repository; // inyectamos el repo

  const SearchPage({super.key, required this.repository});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final List<ProfessionalEntity> _professionals = [];

  bool _isLoading = false;
  // Mantenemos _hasMore en true para permitir la primera carga
  bool _hasMore = true; 
  int _page = 1;
  final int _limit = 10;

  // Carga todos los profesionales disponibles
  Future<bool> _loadMore() async {
    // Si ya estamos cargando o ya no hay más (en este caso, después del primer fetch)
    if (_isLoading || !_hasMore) return false; 

    setState(() => _isLoading = true);

    try {
      // Llamamos a getAllProfessionals(), que devuelve Future<List<ProfessionalEntity>>
      final newProfessionals = await widget.repository.getAllProfessionals(); 
      
      setState(() {
        // Agregamos todos los profesionales obtenidos
        _professionals.addAll(newProfessionals); 
        
        // Deshabilitamos el 'load more' después de la primera carga completa
        _hasMore = false; 
      });
      
    } catch (e) {
      // Si el error es el que has estado viendo, esta línea lo atrapará y lo mostrará.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error cargando profesionales: $e')),
      );
      _hasMore = false; 
    } finally {
      setState(() => _isLoading = false);
    }

    return _hasMore;
  }

  @override
  void initState() {
    super.initState();
    // Llamamos a _loadMore directamente para iniciar la carga de la lista
    _loadMore(); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buscar Profesionales')),
      body: EasyLoadMore(
        onLoadMore: _loadMore,
        isFinished: !_hasMore,
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: _professionals.length + (_isLoading ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == _professionals.length && _isLoading) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            
            if (_professionals.isEmpty && !_isLoading) {
                // Solo muestra este mensaje si el proceso de carga terminó y no hay datos
                return const Center(
                    child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: Text("No se encontraron profesionales.")
                    )
                );
            }

            final prof = _professionals[index];

            // 🚨 CORRECCIÓN 1: Envolver en InkWell para hacer clic
            return InkWell(
              onTap: () {
                // Generar un slug (URL-friendly string) del nombre
                String fullName = "${prof.nombres} ${prof.apellidos}";
                String technicianNameSlug = fullName
                    .toLowerCase()
                    .replaceAll(RegExp(r'\s+'), '-') // Reemplazar espacios por guiones
                    .replaceAll(RegExp(r'[^\w\-]+'), ''); // Eliminar caracteres especiales
                
                // 🚨 CORRECCIÓN 2: Navegar a la ruta /process/nombre-tecnico
                // Se asume que estás usando la navegación con rutas con nombre (pushNamed).
                // Debes tener la ruta '/process/:name' definida en tu MaterialApp o GoRouter.
                // Si la ruta no existe, esto fallará.
                Navigator.of(context).pushNamed(
                  '/process/$technicianNameSlug',
                  arguments: prof, // Pasar la entidad completa como argumento
                );
              },
              child: ProfessionalCard(
                nombres: prof.nombres,
                apellidos: prof.apellidos,
                professionalLevel: prof.professionalLevel,
                starRating: prof.starRating,
                availableBalance: prof.availableBalance,
                // Usamos una URL genérica si el backend solo devolvió un placeholder.
                fotoPerfilUrl: prof.fotoPerfilUrl,
              ),
            );
          },
        ),
      ),
    );
  }
}