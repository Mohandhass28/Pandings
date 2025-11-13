// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ShopModel {
  final String id; // Unique shop ID
  final String ownerId; // User ID of the shop owner
  final String shopName;
  final String shopDesDescription;
  final double pendingAmount;
  final String? userIcon;

  ShopModel({
    required this.id,
    required this.ownerId,
    required this.shopName,
    required this.shopDesDescription,
    required this.pendingAmount,
    this.userIcon,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'ownerId': ownerId,
      'shopName': shopName,
      'shopDesDescription': shopDesDescription,
      'pendingAmount': pendingAmount,
      'userIcon': userIcon,
    };
  }

  factory ShopModel.fromDoc(String id, Map<String, dynamic> map) {
    return ShopModel(
      id: id,
      ownerId: map['ownerId'] ?? '',
      shopName: map['shopName'] ?? '',
      shopDesDescription: map['shopDesDescription'] ?? '',
      userIcon: map['userIcon'],
      pendingAmount: map['pendingAmount'] ?? '',
    );
  }

  factory ShopModel.fromMap(Map<String, dynamic> map) {
    return ShopModel(
      id: map['id'] as String,
      ownerId: map['ownerId'] as String,
      shopName: map['shopName'] as String,
      shopDesDescription: map['shopDesDescription'] as String,
      pendingAmount: map['pendingAmount'] as double,
      userIcon: map['userIcon'] != null ? map['userIcon'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ShopModel.fromJson(String source) =>
      ShopModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
