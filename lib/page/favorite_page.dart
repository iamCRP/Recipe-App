import 'package:flutter/material.dart';
import '../ model/RecipeModel.dart';
import '../controller/favorite_controller.dart';
import 'recipe_detail_page.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  List<Recipe> favorites = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    setState(() => loading = true);
    favorites = await FavoriteController.getFavorites();
    setState(() => loading = false);
  }

  Future<void> removeFavorite(Recipe recipe) async {
    await FavoriteController.toggleFavorite(recipe);
    await loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: const Text(
          'Favorites',
          style: TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.redAccent,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator(color: Colors.red))
          : favorites.isEmpty
          ? const Center(child: Text('No favorites yet'))
          : ListView.separated(
              itemCount: favorites.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final item = favorites[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          item.image,
                          width: 56,
                          height: 56,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(item.name),
                      subtitle: Text(item.cuisine),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => removeFavorite(item),
                      ),
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => RecipeDetailPage(recipe: item),
                          ),
                        );
                        await loadFavorites();
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
