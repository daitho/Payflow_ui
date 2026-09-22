import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../features/change_password/data/repository/change_password_repository_impl.dart';
import '../../../features/change_password/data/service_api/change_password_api_service.dart';
import '../../../features/change_password/domain/repository/change_password_repository.dart';
import '../../../features/change_password/domain/service/change_password_service.dart';
import '../../../features/change_password/presentation/view/change_password_view.dart';
import '../../../features/change_password/presentation/view_model/change_password_view_model.dart';
import '../app_routes.dart';

GoRoute buildChangePasswordRoute({required Dio dio}) {
  final ChangePasswordApiService apiService = ChangePasswordApiService(
    dio: dio,
  );
  final ChangePasswordRepository repository = ChangePasswordRepositoryImpl(
    apiService: apiService,
  );
  final ChangePasswordService service = ChangePasswordService(
    repository: repository,
  );

  return GoRoute(
    path: AppRoutes.changePassword,
    builder: (context, state) {
      return ChangeNotifierProvider(
        create: (_) => ChangePasswordViewModel(service: service),
        child: const ChangePasswordView(),
      );
    },
  );
}
