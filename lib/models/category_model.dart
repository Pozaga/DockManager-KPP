import 'package:flutter/material.dart';

/// Модель категорії документів (Category).
class CategoryModel {
  final String categoryId;
  final String ownerId;
  final String name;
  final Color color;
  final int documentCount;
  final DateTime createdAt;

  const CategoryModel({
    required this.categoryId,
    required this.ownerId,
    required this.name,
    required this.color,
    this.documentCount = 0,
    required this.createdAt,
  });

  CategoryModel copyWith({
    String? name,
    Color? color,
    int? documentCount,
  }) {
    return CategoryModel(
      categoryId: categoryId,
      ownerId: ownerId,
      name: name ?? this.name,
      color: color ?? this.color,
      documentCount: documentCount ?? this.documentCount,
      createdAt: createdAt,
    );
  }
}
