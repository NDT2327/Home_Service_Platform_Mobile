import 'package:hsp_mobile/core/providers/auth_provider.dart';
import 'package:hsp_mobile/core/providers/booking_detail_provider.dart';
import 'package:hsp_mobile/core/providers/catalog_provider.dart';
import 'package:hsp_mobile/core/providers/task_claim_provider.dart';
import 'package:hsp_mobile/core/services/account_service.dart';
import 'package:hsp_mobile/core/services/booking_detail_service.dart';
import 'package:hsp_mobile/core/services/booking_service.dart';
import 'package:hsp_mobile/core/services/catalog_service.dart';
import 'package:hsp_mobile/core/services/task_service.dart';
import 'package:hsp_mobile/features/account/account_provider.dart';
import 'package:hsp_mobile/features/job/repository/task_available_repository.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List <SingleChildWidget> providers = [
ChangeNotifierProvider(create: (_) => AuthProvider()),
  ChangeNotifierProvider(create: (_) => AccountProvider()),
  ChangeNotifierProvider(create: (_) => BookingDetailProvider()),
  ChangeNotifierProvider(create: (_) => CatalogProvider(catalogService: CatalogService())),
  ChangeNotifierProvider(
    create: (_) => TaskClaimProvider(
      taskService: TaskService(),
      taskAvailableRepository: TaskAvailableRepository(
        bookingDetailService: BookingDetailService(),
        bookingService: BookingService(),
        accountService: AccountService(),
        catalogService: CatalogService(),
      ),
    ),
  ),
];