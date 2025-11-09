// ignore_for_file: body_might_complete_normally_nullable

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthMiddleware extends GetMiddleware {
  AuthMiddleware();
  @override
  RouteSettings? redirect(String? route) {}
}
