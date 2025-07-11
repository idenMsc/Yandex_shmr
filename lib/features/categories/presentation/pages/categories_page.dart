import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/category_bloc.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Поисковая строка
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                filled: true,
                fillColor: Color(0xffECE6F0),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 16, horizontal: 14),
                hintText: "Найти статью",
                suffixIcon: Icon(
                  Icons.search,
                  color: Color(0xff1D1B20),
                ),
                border: OutlineInputBorder(borderSide: BorderSide.none),
              ),
              onChanged: (value) {
                setState(() => searchQuery = value);
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<CategoryBloc, CategoryState>(
              builder: (context, state) {
                if (state is CategoryLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is CategoryLoaded) {
                  final categories = state.categories
                      .where((c) => c.name
                          .toLowerCase()
                          .contains(searchQuery.toLowerCase()))
                      .toList();
                  if (categories.isEmpty) {
                    return const Center(child: Text('Ничего не найдено'));
                  }
                  return ListView.builder(
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return ListTile(
                        leading: Text(category.emoji),
                        title: Text(category.name),
                        subtitle: Text(category.isIncome ? 'Доход' : 'Расход'),
                      );
                    },
                  );
                } else if (state is CategoryError) {
                  return Center(child: Text('Ошибка: ${state.message}'));
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
