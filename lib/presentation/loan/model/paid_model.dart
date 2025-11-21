// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

enum PaymentType { online, cheque, cash }

enum PaidType {
  credit,
  debit,
}

class PaidModel {
  final double amount;
  final Timestamp paidAt;
  final PaymentType paymentType;
  final PaidType paidType;

  PaidModel({
    required this.amount,
    required this.paidAt,
    required this.paymentType,
    required this.paidType,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'amount': amount,
      'paidAt': paidAt,
      'paymentType': paymentType.name,
      'paidType': paidType.name,
    };
  }

  factory PaidModel.fromMap(Map<String, dynamic> map) {
    return PaidModel(
      amount: map['amount'] as double,
      paidAt: map['paidAt'],
      paymentType: map['paymentType'] == PaymentType.cash.name
          ? PaymentType.cash
          : map['paymentType'] == PaymentType.online.name
          ? PaymentType.online
          : PaymentType.cheque,
      paidType: map['paidType'] == PaidType.credit.name
          ? PaidType.credit
          : PaidType.debit,
    );
  }

  String toJson() => json.encode(toMap());

  factory PaidModel.fromJson(String source) =>
      PaidModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
