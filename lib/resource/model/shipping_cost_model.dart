import 'dart:convert';

import 'package:flutter_foodstore/core/utils/parse_helper.dart';

class ShippingCostModel {
  final String? name;
  final String? code;
  final String? service;
  final String? description;
  final int? cost;
  final String? etd;

  ShippingCostModel({
    this.name,
    this.code,
    this.service,
    this.description,
    this.cost,
    this.etd,
  });

  factory ShippingCostModel.fromJson(String str) =>
      ShippingCostModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ShippingCostModel.fromMap(Map<String, dynamic> json) =>
      ShippingCostModel(
        name: json["name"]?.toString(),
        code: json["code"]?.toString(),
        service: json["service"]?.toString(),
        description: json["description"]?.toString(),
        cost: toIntOrNull(json["cost"]),
        etd: json["etd"]?.toString(),
      );

  Map<String, dynamic> toMap() => {
        "name": name,
        "code": code,
        "service": service,
        "description": description,
        "cost": cost,
        "etd": etd,
      };
}