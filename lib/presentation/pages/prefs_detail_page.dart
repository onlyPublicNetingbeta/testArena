import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../cubits/preference_cubit/preference_cubit.dart';
import '../cubits/preference_cubit/preference_state.dart';

class PrefsDetailPage extends StatelessWidget {
  final int id;
  const PrefsDetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PreferenceCubit>();
    final item = cubit.repository.getLocalById(id);

    if (item == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Detalle"),leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),),
        body: const Center(child: Text("Elemento no encontrado")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(item.customName),leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => context.pop(),
      ),),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Image.network(item.imageUrl, width: 150),
          const SizedBox(height: 20),
          Text("API Name: ${item.apiName}", style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 10),
          Text("Custom Name: ${item.customName}", style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 30),
          BlocConsumer<PreferenceCubit, PrefState>(
            listener: (context, state) {
              if (state is PrefLoaded) {
                context.push('/prefs');
              }
            },
            builder: (context, state) {
              final loading = state is PrefLoading;
              return Column(
                children: [
                  ElevatedButton(
                    onPressed: loading
                        ? null
                        : () async {
                      await cubit.deletePref(id);
                    },
                    child: loading
                        ? const CircularProgressIndicator()
                        : const Text("Eliminar"),
                  ),
                  TextButton(
                    onPressed: () => context.pop(),
                    child: const Text("Volver"),
                  )
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
