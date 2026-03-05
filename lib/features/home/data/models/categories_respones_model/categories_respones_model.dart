import 'dart:convert';

import 'package:equatable/equatable.dart';

class CategoriesResponesModel extends Equatable {
  final String? slug;
  final String? name;
  final String? url;

  const CategoriesResponesModel({this.slug, this.name, this.url});

  factory CategoriesResponesModel.fromMap(Map<String, dynamic> data) {
    return CategoriesResponesModel(
      slug: data['slug'] as String?,
      name: data['name'] as String?,
      url: data['url'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {'slug': slug, 'name': name, 'url': url};

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [CategoriesResponesModel].
  factory CategoriesResponesModel.fromJson(String data) {
    return CategoriesResponesModel.fromMap(
      json.decode(data) as Map<String, dynamic>,
    );
  }

  /// `dart:convert`
  ///
  /// Converts [CategoriesResponesModel] to a JSON string.
  String toJson() => json.encode(toMap());

  CategoriesResponesModel copyWith({String? slug, String? name, String? url}) {
    return CategoriesResponesModel(
      slug: slug ?? this.slug,
      name: name ?? this.name,
      url: url ?? this.url,
    );
  }

  @override
  List<Object?> get props => [slug, name, url];
}
