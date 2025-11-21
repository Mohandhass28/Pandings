// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

enum TransitionsType { cash, goods }

class LoanModel {
  final String id;
  final String shopId;
  final String partyName;
  final String areaName;
  final DateTime date;
  final String closing;
  final String narration;
  final String byUserName;
  final double loanTotalAmount;
  final double loanPendingAmount;
  final Timestamp createAt;
  final TransitionsType type;

  LoanModel({
    required this.id,
    required this.shopId,
    required this.partyName,
    required this.areaName,
    required this.date,
    required this.closing,
    required this.narration,
    required this.byUserName,
    required this.loanTotalAmount,
    required this.loanPendingAmount,
    required this.createAt,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'shopId': shopId,
      'partyName': partyName,
      'areaName': areaName,
      'date': date.millisecondsSinceEpoch,
      'closing': closing,
      'narration': narration,
      'byUserName': byUserName,
      'loanTotalAmount': loanTotalAmount,
      'loanPendingAmount': loanPendingAmount,
      'createAt': createAt,
      'type': type.name,
    };
  }

  factory LoanModel.fromMap(Map<String, dynamic> map) {
    return LoanModel(
      id: map['id'] as String,
      shopId: map['shopId'] as String,
      partyName: map['partyName'] as String,
      areaName: map['areaName'] as String,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      closing: map['closing'] as String,
      narration: map['narration'] as String,
      byUserName: map['byUserName'] as String,
      loanTotalAmount: map['loanTotalAmount'] as double,
      loanPendingAmount: map['loanPendingAmount'] as double,
      createAt: map['createAt'],
      type: map['type'] == "cash"
          ? TransitionsType.cash
          : TransitionsType.goods,
    );
  }

  String toJson() => json.encode(toMap());

  factory LoanModel.fromJson(String source) =>
      LoanModel.fromMap(json.decode(source) as Map<String, dynamic>);

  LoanModel copyWith({
    String? id,
    String? shopId,
    String? partyName,
    String? areaName,
    DateTime? date,
    String? closing,
    String? narration,
    String? byUserName,
    TransitionsType? type,
    double? loanTotalAmount,
    double? loanPendingAmount,
    Timestamp? createAt,
  }) {
    return LoanModel(
      id: id ?? this.id,
      shopId: shopId ?? this.shopId,
      partyName: partyName ?? this.partyName,
      areaName: areaName ?? this.areaName,
      date: date ?? this.date,
      closing: closing ?? this.closing,
      narration: narration ?? this.narration,
      byUserName: byUserName ?? this.byUserName,
      loanTotalAmount: loanTotalAmount ?? this.loanTotalAmount,
      loanPendingAmount: loanPendingAmount ?? this.loanPendingAmount,
      createAt: createAt ?? this.createAt,
      type: type ?? this.type,
    );
  }
}
