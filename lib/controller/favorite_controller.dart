import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../ model/RecipeModel.dart';

class FavoriteController {
  static const String key = "favorites";

  // Get all favorites
  static Future<List<Recipe>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(key);
    if (data == null) return [];
    final List list = jsonDecode(data);
    return list.map((e) => Recipe.fromJson(e)).toList();
  }

  // Toggle favorite
  static Future<void> toggleFavorite(Recipe recipe) async {
    final prefs = await SharedPreferences.getInstance();
    final favs = await getFavorites();
    if (favs.any((r) => r.id == recipe.id)) {
      favs.removeWhere((r) => r.id == recipe.id);
    } else {
      favs.add(recipe);
    }
    prefs.setString(key, jsonEncode(favs.map((r) => r.toJson()).toList()));
  }

  // Check if favorite
  static Future<bool> isFavorite(Recipe recipe) async {
    final favs = await getFavorites();
    return favs.any((r) => r.id == recipe.id);
  }

  // Remove favorite by id
  static Future<void> removeFavorite(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final favs = await getFavorites();
    favs.removeWhere((r) => r.id == id);
    prefs.setString(key, jsonEncode(favs.map((r) => r.toJson()).toList()));
  }
}
