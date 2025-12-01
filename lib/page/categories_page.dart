import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:recipe_app/page/recipe_detail_page.dart';

import '../ model/RecipeModel.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  final List<String> categories = const [
    "Italian",
    "Indian",
    "Mexican",
    "Dessert",
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: categories.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Categories",
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.redAccent,
          centerTitle: true,
          bottom: TabBar(
            isScrollable: true,
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            // Selected tab text color
            unselectedLabelColor: Colors.white60,
            // Unselected tab text color
            labelStyle: const TextStyle(
              fontSize: 23, // Size of selected tab text
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 18, // Size of unselected tab text
              fontWeight: FontWeight.normal,
            ),
            tabs: categories.map((c) => Tab(text: c)).toList(),
          ),
        ),
        body: TabBarView(
          children: categories
              .map((c) => CategoryRecipesTab(category: c))
              .toList(),
        ),
      ),
    );
  }
}

class CategoryRecipesTab extends StatefulWidget {
  final String category;

  const CategoryRecipesTab({super.key, required this.category});

  @override
  State<CategoryRecipesTab> createState() => _CategoryRecipesTabState();
}

class _CategoryRecipesTabState extends State<CategoryRecipesTab> {
  late Future<List<Recipe>> recipesFuture;

  @override
  void initState() {
    super.initState();
    recipesFuture = fetchRecipesByCategory(widget.category);
  }

  Future<List<Recipe>> fetchRecipesByCategory(String category) async {
    final response = await http.get(Uri.parse("https://dummyjson.com/recipes"));

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      List list = body['recipes'];

      List filtered = list.where((r) {
        final cuisine = r['cuisine'] ?? '';
        return cuisine.toString().toLowerCase() == category.toLowerCase();
      }).toList();

      return filtered.map((e) => Recipe.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load recipes");
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Recipe>>(
      future: recipesFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.red),
          );
        }

        final recipes = snapshot.data!;
        if (recipes.isEmpty) {
          return const Center(child: Text("No recipes found"));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: recipes.length,
          itemBuilder: (context, index) {
            final r = recipes[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RecipeDetailPage(recipe: r),
                  ),
                );
              },
              child: Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      r.image,
                      height: 60,
                      width: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    r.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text("${r.cuisine} • ⭐ ${r.rating}"),
                  trailing: Text("${r.servings} servings"),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
