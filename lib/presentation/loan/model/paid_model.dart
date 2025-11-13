// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class PaidModel {
  final double amount;
  final Timestamp paidAt;

  PaidModel({required this.amount, required this.paidAt});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'amount': amount,
      'paidAt': paidAt,
    };
  }

  factory PaidModel.fromMap(Map<String, dynamic> map) {
    return PaidModel(
      amount: map['amount'] as double,
      paidAt: map['paidAt'],
    );
  }

  String toJson() => json.encode(toMap());

  factory PaidModel.fromJson(String source) =>
      PaidModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
