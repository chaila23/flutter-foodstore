import 'dart:convert';

import 'package:flutter_foodstore/core/utils/parse_helper.dart';

class ShippingModel {
  final int? id;
  final int? transactionId;
  final String? shippingCourier;
  final String? shippingService;
  final String? shippingCost;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ShippingModel({
    this.id,
    this.transactionId,
    this.shippingCourier,
    this.shippingService,
    this.shippingCost,
    this.createdAt,
    this.updatedAt,
  });

  factory ShippingModel.fromJson(String str) =>
      ShippingModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ShippingModel.fromMap(Map<String, dynamic> json) => ShippingModel(
        id: toIntOrNull(json["id"]),
        transactionId: toIntOrNull(json["transaction_id"]),
        shippingCourier: json["shipping_courier"]?.toString(),
        shippingService: json["shipping_service"]?.toString(),
        shippingCost: json["shipping_cost"]?.toString(),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "transaction_id": transactionId,
        "shipping_courier": shippingCourier,
        "shipping_service": shippingService,
        "shipping_cost": shippingCost,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}