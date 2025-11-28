import 'package:alguiendijochamba_app_flutter/core/di/injector.dart';
import 'package:alguiendijochamba_app_flutter/features/home/presentation/pages/home_page.dart';
import 'package:alguiendijochamba_app_flutter/features/process/domain/repositories/process_repository.dart';
import 'package:alguiendijochamba_app_flutter/features/process/domain/usecases/cancel_job.dart';
import 'package:alguiendijochamba_app_flutter/features/process/domain/usecases/complete_job.dart';
import 'package:alguiendijochamba_app_flutter/features/process/domain/usecases/create_job_request.dart';
import 'package:alguiendijochamba_app_flutter/features/process/domain/usecases/get_professional_detail.dart';
import 'package:alguiendijochamba_app_flutter/features/process/presentation/blocs/process_bloc.dart';
import 'package:alguiendijochamba_app_flutter/features/process/presentation/blocs/process_event.dart';
import 'package:alguiendijochamba_app_flutter/features/process/presentation/pages/jobs_list_page.dart';
import 'package:alguiendijochamba_app_flutter/features/search/domain/usecases/get_all_tags_usecase.dart';
import 'package:alguiendijochamba_app_flutter/features/search/domain/usecases/search_professionals_usecase.dart';
import 'package:alguiendijochamba_app_flutter/features/search/presentation/pages/search_page.dart';
import 'package:alguiendijochamba_app_flutter/features/profile/presentation/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late PersistentTabController _controller;
  late final SearchProfessionalsUseCase searchUseCase;
  late final GetAllTagsUseCase getAllTagsUseCase;

  @override
  void initState() {
    super.initState();
    searchUseCase = injector<SearchProfessionalsUseCase>();
    getAllTagsUseCase = injector<GetAllTagsUseCase>();
    _controller = PersistentTabController(initialIndex: 0);
  }

  List<Widget> _buildScreens() {
    return [
      // 🏠 Tab Home
      Home(controller: _controller),
      
      // 🔍 Tab Search
      SearchPage(
        searchUseCase: searchUseCase,
        getAllTagsUseCase: getAllTagsUseCase,
      ),
      
      // 📋 Tab Process: lista de jobs
      BlocProvider<ProcessBloc>(
        create: (_) => ProcessBloc(
          getProfessionalDetail: injector<GetProfessionalDetail>(),
          createJobRequest: injector<CreateJobRequest>(),
          completeJob: injector<CompleteJob>(),
          cancelJob: injector<CancelJob>(),
          repository: injector<ProcessRepository>(),
        )..add(const LoadAvailableJobs()),
        child: JobsListPage(
          repository: injector<ProcessRepository>(),
        ),
      ),
      
      // 🎁 Tab Rewards
      const Scaffold(body: Center(child: Text('Rewards Page'))),
      
      // 👤 Tab Profile (ACTUALIZADO)
      const ProfilePage(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.home_outlined),
        inactiveIcon: const Icon(Icons.home),
        title: "Home",
        activeColorPrimary: const Color(0xFF2563EB),
        inactiveColorPrimary: const Color(0xFF6B7280),
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.search_outlined),
        inactiveIcon: const Icon(Icons.search),
        title: "Search",
        activeColorPrimary: const Color(0xFF2563EB),
        inactiveColorPrimary: const Color(0xFF6B7280),
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.pending_outlined),
        inactiveIcon: const Icon(Icons.pending),
        title: "Process",
        activeColorPrimary: const Color(0xFF2563EB),
        inactiveColorPrimary: const Color(0xFF6B7280),
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.card_giftcard_outlined),
        inactiveIcon: const Icon(Icons.card_giftcard),
        title: "Rewards",
        activeColorPrimary: const Color(0xFF2563EB),
        inactiveColorPrimary: const Color(0xFF6B7280),
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.person_outline),
        inactiveIcon: const Icon(Icons.person),
        title: "Profile",
        activeColorPrimary: const Color(0xFF2563EB),
        inactiveColorPrimary: const Color(0xFF6B7280),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineToSafeArea: true,
      backgroundColor: Colors.white,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      hideNavigationBarWhenKeyboardAppears: true,
      navBarStyle: NavBarStyle.style3,
      onItemSelected: (index) {
        // Opcional: lógica adicional al cambiar de tab
        debugPrint('Tab seleccionado: $index');
      },
    );
  }
}
