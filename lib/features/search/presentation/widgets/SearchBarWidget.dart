// Archivo: lib/features/search/presentation/widgets/SearchBarWidget.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/search_cubit.dart'; 

class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({super.key});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _controller = TextEditingController();
  
  // Usamos un Debouncer o onSubmitted. Aquí usamos onSubmitted para simplicidad.

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchCubit = context.read<SearchCubit>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: 'Buscar por nombre o servicio (ej: "Plomero")',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _controller.text.isNotEmpty 
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _controller.clear();
                    // Ejecuta la búsqueda sin término (manteniendo los tags)
                    searchCubit.runSearch(newSearchTerm: ''); 
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey.shade200,
          contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
        ),
        // 🚀 Ejecuta la búsqueda al presionar "Buscar" o "Enter"
        onSubmitted: (searchTerm) {
          // Llama a runSearch del Cubit con el nuevo término de búsqueda
          searchCubit.runSearch(newSearchTerm: searchTerm.trim());
        },
        onChanged: (text) {
          // Necesario para que se redibuje el botón de "clear"
          setState(() {}); 
        }
      ),
    );
  }
}