import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'data/datasources/local_service.dart';
import 'data/datasources/api_service.dart';
import 'data/repositories/item_repository.dart';
import 'presentation/cubits/api_cubit/api_cubit.dart';
import 'presentation/cubits/preference_cubit/preference_cubit.dart';
import 'presentation/pages/api_list_page.dart';
import 'presentation/pages/prefs_list_page.dart';
import 'presentation/pages/prefs_new_page.dart';
import 'presentation/pages/prefs_detail_page.dart';
import 'data/models/item_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(0)) Hive.registerAdapter(ItemModelAdapter());
  await Hive.openBox<ItemModel>(LocalService.boxName);

  final apiService = ApiService();
  final localService = LocalService();
  final repository = ItemRepository(api: apiService, local: localService);

  runApp(MyApp(repository: repository));
}

class MyApp extends StatelessWidget {
  final ItemRepository repository;
  MyApp({required this.repository});

  @override
  Widget build(BuildContext context) {
    final _router = GoRouter(
      initialLocation: '/api-list',
      routes: [
        GoRoute(path: '/api-list', builder: (context, state) => ApiListPage()),
        GoRoute(path: '/prefs', builder: (context, state) => PrefsListPage()),
        GoRoute(path: '/prefs/new', builder: (context, state) => PrefsNewPage()),
        GoRoute(path: '/prefs/:id', builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return PrefsDetailPage(id: id);
        }),
      ],
    );

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ApiCubit(repository)),
        BlocProvider(create: (_) => PreferenceCubit(repository)),
      ],
      child: MaterialApp.router(
        title: 'Items App',
        routerDelegate: _router.routerDelegate,
        routeInformationParser: _router.routeInformationParser,
        routeInformationProvider: _router.routeInformationProvider,
      ),
    );
  }
}
