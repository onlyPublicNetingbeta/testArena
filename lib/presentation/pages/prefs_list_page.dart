import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../cubits/preference_cubit/preference_cubit.dart';
import '../cubits/preference_cubit/preference_state.dart';

class PrefsListPage extends StatefulWidget {
  const PrefsListPage({super.key});

  @override
  State<PrefsListPage> createState() => _PrefsListPageState();
}

class _PrefsListPageState extends State<PrefsListPage> {
  @override
  void initState() {
    super.initState();
    context.read<PreferenceCubit>().loadPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Elementos guardados"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go("/api-list"),
        ),
      ),
      body: BlocBuilder<PreferenceCubit, PrefState>(
        builder: (context, state) {
          if (state is PrefLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PrefError) {
            return Center(child: Text(state.message));
          } else if (state is PrefLoaded) {
            if (state.items.isEmpty) {
              return const Center(child: Text("No hay elementos guardados"));
            }
            return ListView.builder(
              itemCount: state.items.length,
              itemBuilder: (_, i) {
                final item = state.items[i];
                return ListTile(
                  leading: Image.network(item.imageUrl, width: 40),
                  title: Text(item.customName),
                  subtitle: Text(item.apiName),
                  onTap: () => context.push('/prefs/${item.id}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      await context.read<PreferenceCubit>().deletePref(item.id);
                      mounted ? context.read<PreferenceCubit>().loadPrefs() :(){};
                    },
                  ),
                );
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
