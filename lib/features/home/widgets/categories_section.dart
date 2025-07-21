import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hsp_mobile/core/routes/app_routes.dart';

class CategoriesSection extends StatelessWidget {
  final List<Map<String, dynamic>> categories;

  const CategoriesSection({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Danh mục", style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: categories.map((category) {
              return Expanded(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        GoRouter.of(context).push(
                          '${AppRoutes.mainLayout}/customer${AppRoutes.service}',
                          extra: {
                            'categoryId': category['id'],
                            'categoryName': category['name'],
                          },
                        );
                      },
                      child: CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.blue.shade100,
                        child: category['image'] != null && category['image'].isNotEmpty
                            ? ClipOval(
                                child: Image.network(
                                  category['image'],
                                  width: 56,
                                  height: 56,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(
                                      Icons.broken_image,
                                      size: 30,
                                      color: Colors.blue,
                                    );
                                  },
                                ),
                              )
                            : Icon(
                                Icons.category,
                                size: 30,
                                color: Colors.blue,
                              ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      category['name'],
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 10),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}