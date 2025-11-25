import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../data/models/item_model.dart';
import '../cubits/api_cubit/api_cubit.dart';
import '../cubits/api_cubit/api_state.dart';
import '../cubits/preference_cubit/preference_cubit.dart';
import '../cubits/preference_cubit/preference_state.dart';

class PrefsNewPage extends StatefulWidget {
  const PrefsNewPage({super.key});

  @override
  State<PrefsNewPage> createState() => _PrefsNewPageState();
}

class _PrefsNewPageState extends State<PrefsNewPage> {
  ItemModel? selected;
  final TextEditingController _ctrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // El item se recibe vía extra desde ApiListPage
    final routerExtra = GoRouterState.of(context).extra;
    if (routerExtra is ItemModel && selected == null) {
      selected = routerExtra;
      _ctrl.text = selected!.customName;
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Nuevo elemento"),leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => context.pop(),
      ),),
      body: Column(
        children: [
          _buildSelector(),
          _buildNameField(),
          const SizedBox(height: 30),
          _buildButtons(),
        ],
      ),
    );
  }

  Widget _buildSelector() {
    return BlocBuilder<ApiCubit, ApiState>(
      builder: (context, state) {
        if (state is ApiLoaded) {
          final items = state.items;
          return DropdownButton<ItemModel>(
            hint: const Text("Selecciona un item"),
            value: selected,
            items: items.map((e) {
              return DropdownMenuItem(
                value: e,
                child: Text(e.apiName),
              );
            }).toList(),
            onChanged: (v) {
              setState(() {
                selected = v;
                if (v != null) _ctrl.text = v.customName;
              });
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildNameField() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _ctrl,
        decoration: const InputDecoration(
          labelText: "Nombre personalizado",
        ),
      ),
    );
  }

  Widget _buildButtons() {
    return BlocConsumer<PreferenceCubit, PrefState>(
      listener: (context, state) {},
      builder: (context, state) {
        final loading = state is PrefLoading;
        return Column(
          children: [
            ElevatedButton(
              onPressed: loading
                  ? null
                  : () {
                if (selected == null) return;
                final item = selected!.copyWith(customName: _ctrl.text);
                context.read<PreferenceCubit>().addPref(item);
                context.push('/prefs');
              },
              child: loading
                  ? const CircularProgressIndicator()
                  : const Text("Guardar"),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: loading ? null : () => context.pop(),
              child: const Text("Cancelar"),
            )
          ],
        );
      },
    );
  }
}
