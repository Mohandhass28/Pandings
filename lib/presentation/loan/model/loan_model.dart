// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class LoanModel {
  final String id;
  final String shopId;
  final String name;
  final String description;
  final String byUserName;
  final double loanTotalAmount;
  final double loanPendingAmount;
  final Timestamp createAt;

  LoanModel({
    required this.id,
    required this.shopId,
    required this.name,
    required this.description,
    required this.byUserName,
    required this.loanTotalAmount,
    required this.loanPendingAmount,
    required this.createAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'shopId': shopId,
      'name': name,
      'description': description,
      'byUserName': byUserName,
      'loanTotalAmount': loanTotalAmount,
      'loanPendingAmount': loanPendingAmount,
      'createAt': createAt,
    };
  }

  factory LoanModel.fromMap(Map<String, dynamic> map) {
    return LoanModel(
      id: map['id'] as String,
      shopId: map['shopId'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      byUserName: map['byUserName'] as String,
      loanTotalAmount: map['loanTotalAmount'] as double,
      loanPendingAmount: map['loanPendingAmount'] as double,
      createAt: map['createAt'],
    );
  }

  String toJson() => json.encode(toMap());

  factory LoanModel.fromJson(String source) =>
      LoanModel.fromMap(json.decode(source) as Map<String, dynamic>);

  LoanModel copyWith({
    String? id,
    String? shopId,
    String? name,
    String? description,
    String? byUserName,
    double? loanTotalAmount,
    double? loanPendingAmount,
    Timestamp? createAt,
  }) {
    return LoanModel(
      id: id ?? this.id,
      shopId: shopId ?? this.shopId,
      name: name ?? this.name,
      description: description ?? this.description,
      byUserName: byUserName ?? this.byUserName,
      loanTotalAmount: loanTotalAmount ?? this.loanTotalAmount,
      loanPendingAmount: loanPendingAmount ?? this.loanPendingAmount,
      createAt: createAt ?? this.createAt,
    );
  }
}
