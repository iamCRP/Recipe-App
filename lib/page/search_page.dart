import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../ model/RecipeModel.dart';
import 'recipe_detail_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Recipe> allRecipes = [];
  List<Recipe> filteredRecipes = [];

  String searchQuery = "";
  String selectedCuisine = "All";

  List<String> cuisines = [
    "All",
    "Indian",
    "Italian",
    "American",
    "Mexican",
    "Chinese",
  ];

  Future<void> fetchRecipes() async {
    final response = await http.get(Uri.parse("https://dummyjson.com/recipes"));

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      List list = body['recipes'];

      setState(() {
        allRecipes = list.map((e) => Recipe.fromJson(e)).toList();
        filteredRecipes = allRecipes;
      });
    }
  }

  void filterData() {
    List<Recipe> temp = allRecipes.where((recipe) {
      final matchesSearch = recipe.name.toLowerCase().contains(
        searchQuery.toLowerCase(),
      );

      final matchesCuisine =
          selectedCuisine == "All" || recipe.cuisine == selectedCuisine;

      return matchesSearch && matchesCuisine;
    }).toList();

    setState(() {
      filteredRecipes = temp;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchRecipes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.redAccent,
        title: const Text(
          "Search Recipes",
          style: TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      body: Column(
        children: [
          // 🔎 Search Bar
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search recipe...",
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.redAccent.withOpacity(0.1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (val) {
                searchQuery = val;
                filterData();
              },
            ),
          ),

          // 🍽 Cuisine Filter Dropdown
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.redAccent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: DropdownButton(
                value: selectedCuisine,
                isExpanded: true,
                underline: SizedBox(),
                items: cuisines.map((c) {
                  return DropdownMenuItem(value: c, child: Text(c));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCuisine = value!;
                  });
                  filterData();
                },
              ),
            ),
          ),

          SizedBox(height: 10),

          // List of Recipes
          Expanded(
            child: filteredRecipes.isEmpty
                ? Center(
                    child: Text(
                      "No Recipes Found",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredRecipes.length,
                    itemBuilder: (context, index) {
                      final r = filteredRecipes[index];

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => RecipeDetailPage(recipe: r),
                            ),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 5,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              // Image
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.network(
                                  r.image,
                                  height: 90,
                                  width: 90,
                                  fit: BoxFit.cover,
                                ),
                              ),

                              SizedBox(width: 15),

                              // Name + Cuisine + Rating
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      r.name,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      r.cuisine,
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.star,
                                          color: Colors.orange,
                                          size: 18,
                                        ),
                                        Text(" ${r.rating}"),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
