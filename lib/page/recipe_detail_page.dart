import 'package:flutter/material.dart';
import '../ model/RecipeModel.dart';
import '../controller/favorite_controller.dart';

class RecipeDetailPage extends StatefulWidget {
  final Recipe recipe;

  const RecipeDetailPage({super.key, required this.recipe});

  @override
  State<RecipeDetailPage> createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {
  bool isFav = false;

  @override
  void initState() {
    super.initState();
    loadFavorite();
  }

  Future<void> loadFavorite() async {
    // widget.recipe can be a model with .id or a Map; controller handles it
    bool fav = await FavoriteController.isFavorite(widget.recipe);
    setState(() => isFav = fav);
  }

  toggleFav() async {
    await FavoriteController.toggleFavorite(widget.recipe);
    loadFavorite();
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.recipe;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          r.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: toggleFav,
            icon: Icon(
              isFav ? Icons.bookmark : Icons.bookmark_border,
              color: isFav ? Colors.red : Colors.black,
            ),
          ),
        ],
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                r.image,
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),

            // Basic Info
            Text(
              r.name,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.star, color: Colors.amber[700]),
                Text(" ${r.rating}", style: const TextStyle(fontSize: 16)),
                const SizedBox(width: 10),
                Icon(Icons.people, color: Colors.blueGrey),
                Text(
                  " ${r.servings} servings",
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Time & difficulty
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _infoCard(Icons.timer, "Prep", "${r.prepTimeMinutes} mins"),
                _infoCard(
                  Icons.local_fire_department,
                  "Cook",
                  "${r.cookTimeMinutes} mins",
                ),
                _infoCard(Icons.leaderboard, "Level", r.difficulty),
              ],
            ),

            const SizedBox(height: 25),

            // Tags
            Wrap(
              spacing: 8,
              children: List.generate(r.tags.length, (i) {
                return Chip(
                  label: Text(r.tags[i]),
                  backgroundColor: Colors.lightGreen[100],
                );
              }),
            ),

            const SizedBox(height: 25),

            // Ingredients
            const Text(
              "Ingredients",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ...List.generate(r.ingredients.length, (i) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        r.ingredients[i],
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 25),

            // Instructions
            const Text(
              "Instructions",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ...List.generate(r.instructions.length, (i) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 12,
                      backgroundColor: Colors.orange,
                      child: Text(
                        "${i + 1}",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        r.instructions[i],
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _infoCard(IconData icon, String title, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 26, color: Colors.deepOrange),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          Text(value, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
