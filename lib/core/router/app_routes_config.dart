import 'package:get/get.dart';
import 'package:pendings/presentation/auth/page/create_account_page.dart';
import 'package:pendings/presentation/auth/page/login_page.dart';
import 'package:pendings/presentation/auth/page/verify_email_link_page.dart';
import 'package:pendings/presentation/loan/page/create_loan_page.dart';
import 'package:pendings/presentation/loan/page/create_loan_amount.dart';
import 'package:pendings/presentation/loan/page/loan_details_page.dart';
import 'package:pendings/presentation/loan/page/pay_loan_page.dart';
import 'package:pendings/presentation/shop/page/create_shop_page.dart';
import 'package:pendings/presentation/home/page/home_page.dart';
import 'package:pendings/presentation/shop/page/shop_page.dart';
import 'package:pendings/presentation/shop/page/staffs_shop_page.dart';
import 'package:pendings/presentation/staffs/page/add_staffs_page.dart';
import 'package:pendings/root_page.dart';

import 'middleware/auth_middleware.dart';
part "router_name.dart";

class RouteManager {
  static final _authMiddleware = AuthMiddleware();

  static AuthMiddleware get getauthMiddleware => _authMiddleware;

  static List<GetPage> get pages => [
    GetPage(
      name: RouterName.ROOT,
      page: () => RootPage(),
      middlewares: [getauthMiddleware],
    ),
    GetPage(
      name: RouterName.LOGIN,
      page: () => LoginPage(),
    ),
    GetPage(
      name: RouterName.HOME,
      page: () => HomePage(),
    ),
    GetPage(
      name: RouterName.CREATE_SHOP,
      page: () => CreateShopPage(),
    ),
    GetPage(
      name: RouterName.SHOP,
      page: () => ShopPage(),
    ),
    GetPage(
      name: RouterName.LOAN_DETAILS,
      page: () => LoanDetailsPage(),
      binding: LoanBinding(),
    ),
    GetPage(
      name: RouterName.CREATE_ACCOUNT,
      page: () => CreateAccountPage(),
    ),
    GetPage(
      name: RouterName.PAY_LOAN,
      page: () => PayLoanPage(),
    ),
    GetPage(
      name: RouterName.CREATELOANAMOUNT,
      page: () => CreateLoanAmount(),
    ),
    GetPage(
      name: RouterName.CREATELOAN,
      page: () => CreateLoanPage(),
    ),
    GetPage(
      name: RouterName.SHOPSTAFF,
      page: () => StaffsShopPage(),
    ),
    GetPage(
      name: RouterName.ADDSTAFFS,
      page: () => AddStaffsPage(),
    ),
    GetPage(
      name: RouterName.VERIFY_EMAIL_LINK,
      page: () => const VerifyEmailLinkPage(),
    ),
  ];
}
