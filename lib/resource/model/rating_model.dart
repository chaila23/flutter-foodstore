import 'dart:convert';

import 'package:flutter_foodstore/core/utils/parse_helper.dart';
import 'package:flutter_foodstore/resource/model/customer_model.dart';

class RatingModel {
  int? id;
  int? transactionDetailId;
  int? customerId;
  int? productId;
  int? rating;
  String? review;
  DateTime? createdAt;
  DateTime? updatedAt;
  CustomerModel? customer;

  RatingModel({
    this.id,
    this.transactionDetailId,
    this.customerId,
    this.productId,
    this.rating,
    this.review,
    this.createdAt,
    this.updatedAt,
    this.customer,
  });

  factory RatingModel.fromJson(String str) =>
      RatingModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory RatingModel.fromMap(Map<String, dynamic> json) => RatingModel(
        id: toIntOrNull(json["id"]),
        transactionDetailId: toIntOrNull(json["transaction_detail_id"]),
        customerId: toIntOrNull(json["customer_id"]),
        productId: toIntOrNull(json["product_id"]),
        rating: toIntOrNull(json["rating"]),
        review: json["review"]?.toString(),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        customer: json["customer"] == null
            ? null
            : CustomerModel.fromMap(json["customer"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "transaction_detail_id": transactionDetailId,
        "customer_id": customerId,
        "product_id": productId,
        "rating": rating,
        "review": review,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "customer": customer?.toMap(),
      };
}