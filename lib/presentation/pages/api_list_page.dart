import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../cubits/api_cubit/api_cubit.dart';
import '../cubits/api_cubit/api_state.dart';


class ApiListPage extends StatefulWidget {
  const ApiListPage({super.key});

  @override
  State<ApiListPage> createState() => _ApiListPageState();
}

class _ApiListPageState extends State<ApiListPage> {
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ApiCubit>().loadItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Items de la API"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<ApiCubit>().loadItems();
            },
          )
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: BlocBuilder<ApiCubit, ApiState>(
              builder: (context, state) {
                if (state is ApiLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ApiError) {
                  return _buildError(state.message);
                } else if (state is ApiLoaded) {
                  if (state.items.isEmpty) {
                    return const Center(child: Text("Sin resultados"));
                  }
                  return ListView.builder(
                    itemCount: state.items.length,
                    itemBuilder: (_, i) {
                      final item = state.items[i];
                      return ListTile(
                        leading: Image.network(item.imageUrl, width: 40),
                        title: Text(item.apiName),
                        subtitle: Text("ID: ${item.id}"),
                        onTap: () => context.push('/prefs/new', extra: item),
                      );
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: TextField(
        controller: _searchCtrl,
        decoration: InputDecoration(
          hintText: "Buscar por nombre",
          suffixIcon: IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              final q = _searchCtrl.text.trim();
              if (q.isNotEmpty) {
                context.read<ApiCubit>().search(q);
              }
            },
          ),
        ),
        onSubmitted: (v) {
          if (v.trim().isNotEmpty) {
            context.read<ApiCubit>().search(v.trim());
          }
        },
      ),
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.read<ApiCubit>().loadItems(),
            child: const Text("Reintentar"),
          )
        ],
      ),
    );
  }
}
