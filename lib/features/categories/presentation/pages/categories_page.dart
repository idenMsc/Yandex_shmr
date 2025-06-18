import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/category_bloc.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
      ),
      body: BlocBuilder<CategoryBloc, CategoryState>(
        builder: (context, state) {
          if (state is CategoryInitial) {
            context.read<CategoryBloc>().add(LoadCategories());
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CategoryLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CategoryError) {
            return Center(child: Text(state.message));
          }

          if (state is CategoryLoaded) {
            return ListView.builder(
              itemCount: state.categories.length,
              itemBuilder: (context, index) {
                final category = state.categories[index];
                return ListTile(
                  leading: Text(category.emoji),
                  title: Text(category.name),
                  trailing: Text(category.isIncome ? 'Income' : 'Expense'),
                );
              },
            );
          }

          return const Center(child: Text('Something went wrong'));
        },
      ),
    );
  }
}
