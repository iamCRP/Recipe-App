class Recipe {
  int id;
  String name;
  String image;
  String cuisine;
  double rating;
  int servings;
  int prepTimeMinutes;
  int cookTimeMinutes;
  String difficulty;
  List<String> tags;
  List<String> ingredients;
  List<String> instructions;

  Recipe({
    required this.id,
    required this.name,
    required this.image,
    required this.cuisine,
    required this.rating,
    required this.servings,
    required this.prepTimeMinutes,
    required this.cookTimeMinutes,
    required this.difficulty,
    required this.tags,
    required this.ingredients,
    required this.instructions,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      cuisine: json['cuisine'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      servings: json['servings'] ?? 0,
      prepTimeMinutes: json['prepTimeMinutes'] ?? 0,
      cookTimeMinutes: json['cookTimeMinutes'] ?? 0,
      difficulty: json['difficulty'] ?? '',
      tags: List<String>.from(json['tags'] ?? []),
      ingredients: List<String>.from(json['ingredients'] ?? []),
      instructions: List<String>.from(json['instructions'] ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'image': image,
    'cuisine': cuisine,
    'rating': rating,
    'servings': servings,
    'prepTimeMinutes': prepTimeMinutes,
    'cookTimeMinutes': cookTimeMinutes,
    'difficulty': difficulty,
    'tags': tags,
    'ingredients': ingredients,
    'instructions': instructions,
  };
}
