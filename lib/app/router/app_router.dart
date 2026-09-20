import '../../features/beneficiaries/data/service_api/beneficiary_api_service.dart';
import '../../features/beneficiaries/data/repository/beneficiary_repository_impl.dart';
import '../../features/beneficiaries/domain/service/beneficiary_service.dart';
import '../../features/beneficiaries/presentation/view_model/beneficiaries_view_model.dart';
import '../../features/beneficiaries/presentation/view_model/beneficiary_form_view_model.dart';
import '../../features/beneficiaries/presentation/view/beneficiary_form_view.dart';
import '../../features/beneficiaries/presentation/view/beneficiaries_view.dart';
import '../../features/transfer/data/repository/transfer_repository_impl.dart';
import '../../features/transfer/data/service_api/transfer_api_service.dart';
import '../../features/transfer/domain/model/transfer_draft_seed.dart';
import '../../features/transfer/domain/service/transfer_service.dart';
import '../../features/transfer/presentation/view/transfer_view.dart';
import '../../features/transfer/presentation/view_model/transfer_view_model.dart';
import '../../features/transfer_history/data/repository/transfer_history_repository_impl.dart';
import '../../features/transfer_history/data/service_api/transfer_history_api_service_impl.dart';
import '../../features/transfer_history/domain/service/transfer_history_service.dart';
import '../../features/transfer_history/presentation/view/transfer_history_view.dart';
import '../../features/transfer_history/presentation/view/transfer_detail_view.dart';
import '../../features/transfer_history/presentation/view_model/transfer_history_view_model.dart';
import '../../features/transfer_history/presentation/view_model/transfer_detail_view_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/config/app_config.dart';
import '../../core/network/auth_interceptor.dart';
import '../../core/network/dio_client.dart';
import '../../core/service/biometric_service.dart';
import '../../core/service/device_service.dart';
import '../../core/service/session_service.dart';
import '../../features/active_sessions/data/repository/active_sessions_repository_impl.dart';
import '../../features/active_sessions/presentation/view/current_device_view.dart';
import '../../features/active_sessions/presentation/view_model/current_device_view_model.dart';
import '../../features/auth/data/repository/auth_repository_impl.dart';
import '../../features/active_sessions/data/service_api/active_sessions_api_service.dart';
import '../../features/auth/data/service_api/auth_api_service.dart';
import '../../features/active_sessions/domain/repository/active_sessions_repository.dart';
import '../../features/auth/domain/repository/auth_repository.dart';
import '../../features/active_sessions/domain/service/active_sessions_service.dart';
import '../../features/auth/domain/service/login_service.dart';
import '../../features/auth/domain/service/refresh_service.dart';
import '../../features/auth/domain/service/register_service.dart';
import '../../features/active_sessions/presentation/view/active_sessions_view.dart';
import '../../features/auth/presentation/view/login_view.dart';
import '../../features/auth/presentation/view/register_view.dart';
import '../../features/auth/presentation/view/splash_view.dart';
import '../../features/active_sessions/presentation/view_model/active_sessions_view_model.dart';
import '../../features/auth/presentation/view_model/login_view_model.dart';
import '../../features/auth/presentation/view_model/register_view_model.dart';
import '../../features/auth/presentation/view_model/splash_view_model.dart';
import '../../features/exchange_rates/data/repository/exchange_rate_repository_impl.dart';
import '../../features/exchange_rates/data/service_api/exchange_rate_api_service.dart';
import '../../features/exchange_rates/domain/repository/exchange_rate_repository.dart';
import '../../features/exchange_rates/presentation/view/exchange_rates_view.dart';
import '../../features/exchange_rates/presentation/view_model/exchange_rates_view_model.dart';
import '../../features/home/data/repository/home_repository_impl.dart';
import '../../features/home/data/service_api/home_repository_impl.dart';
import '../../features/home/domain/repository/home_repository.dart';
import '../../features/home/domain/service/home_service.dart';
import '../../features/home/presentation/view_model/home_view_model.dart';
import '../../features/profile/presentation/view/security_privacy_view.dart';
import '../../features/profile/presentation/view_model/profile_view_model.dart';
import '../../features/profile/presentation/view_model/security_privacy_view_model.dart';
import '../../homepage.dart';
import 'app_routes.dart';
import 'guards/auth_guard.dart';
import 'guards/guest_guard.dart';
// ===========================================================
// DEPENDENCIES
// ===========================================================
final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
final DeviceService _deviceService = DeviceService(
  secureStorage: _secureStorage,
);
final SessionService _sessionService = SessionService(
  secureStorage: _secureStorage,
);
final BiometricService _biometricService = BiometricService(
  secureStorage: _secureStorage,
);
final DioClient _dioClient = DioClient(baseUrl: AppConfig.apiBaseUrl);
final AuthApiService _authApiService = AuthApiService(dio: _dioClient.dio);
final AuthRepository _authRepository = AuthRepositoryImpl(
  authApiService: _authApiService,
  deviceService: _deviceService,
);
final LoginService _loginService = LoginService(
  authRepository: _authRepository,
);
final RegisterService _registerService = RegisterService(
  authRepository: _authRepository,
);
final RefreshService _refreshService = RefreshService(
  authRepository: _authRepository,
);
// ===========================================================
// ACTIVE SESSIONS
// ===========================================================

final ActiveSessionsApiService _activeSessionsApiService =
    ActiveSessionsApiService(dio: _dioClient.dio);

final ActiveSessionsRepository _activeSessionsRepository =
    ActiveSessionsRepositoryImpl(apiService: _activeSessionsApiService);

final ActiveSessionsService _activeSessionsService = ActiveSessionsService(
  repository: _activeSessionsRepository,
);
final AuthInterceptor _authInterceptor = AuthInterceptor(
  dio: _dioClient.dio,
  sessionService: _sessionService,
  refreshService: _refreshService,
);

final HomeApiService _homeApiService = HomeApiService(dio: _dioClient.dio);
late final HomeRepository _homeRepository = HomeRepositoryImpl(
  apiService: _homeApiService,
);
late final HomeService _homeService = HomeService(repository: _homeRepository);

// ===========================================================
// EXCHANGE RATES
// ===========================================================
final ExchangeRateApiService _exchangeRateApiService =
ExchangeRateApiServiceImpl(
  _dioClient.dio,
);

final ExchangeRateRepository _exchangeRateRepository =
ExchangeRateRepositoryImpl(
  _exchangeRateApiService
);

final TransferHistoryService _transferHistoryService = TransferHistoryService(
  repository: TransferHistoryRepositoryImpl(
    apiService: TransferHistoryApiServiceImpl(dio: _dioClient.dio),
  ),
);

final BeneficiaryService _beneficiaryService = BeneficiaryService(
  BeneficiaryRepositoryImpl(BeneficiaryApiService(_dioClient.dio)),
);

final TransferService _transferService = TransferService(
  TransferRepositoryImpl(TransferApiService(_dioClient.dio)),
);

final AuthGuard _authGuard = AuthGuard(sessionService: _sessionService);
final GuestGuard _guestGuard = GuestGuard(sessionService: _sessionService);


// ===========================================================
// ROUTER
// ===========================================================
final GoRouter appRouter = _createRouter();

GoRouter _createRouter() {
  // =========================================================
  // NETWORK SECURITY
  // =========================================================
  _dioClient.dio.interceptors.add(_authInterceptor);

  // =========================================================
  // GO ROUTER
  // =========================================================
  return GoRouter(
    initialLocation: AppRoutes.splash,
    /*
     * IMPORTANT :
     *
     * SessionService est un ChangeNotifier.
     *
     * Dès que :
     * - login réussit,
     * - refresh réussit,
     * - session est supprimée,
     * - logout arrive,
     *
     * GoRouter réévalue automatiquement
     * les Guards.
     */
    refreshListenable: _sessionService,

    redirect: (context, state) {
      final String location = state.matchedLocation;

      // =====================================================
      // SPLASH
      //
      // Le Splash résout lui-même l'état initial :
      //
      // SecureStorage
      // -> éventuellement refresh
      // -> Login ou Home
      //
      // On ne doit donc jamais le rediriger depuis un Guard.
      // =====================================================
      if (location == AppRoutes.splash) {
        return null;
      }

      // =====================================================
      // GUEST ROUTES
      // =====================================================
      if (location == AppRoutes.login || location == AppRoutes.register) {
        return _guestGuard.redirect();
      }

      // =====================================================
      // PROTECTED ROUTES
      // =====================================================
      final bool isProtectedRoute =
          location == AppRoutes.home ||
              location == AppRoutes.exchangeRates ||
              location.startsWith('/transactions/') ||
              location.startsWith('/transfer') ||
              location.startsWith('/profile') ||
              location.startsWith('/beneficiaries/');

      if (isProtectedRoute) {
        return _authGuard.redirect();
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.transfer,
        builder: (context, state) {
          final extra = state.extra;
          final seed = extra is TransferDraftSeed
              ? extra
              : const TransferDraftSeed();
          return ChangeNotifierProvider(
            create: (_) => TransferViewModel(
              transferService: _transferService,
              beneficiaryService: _beneficiaryService,
              seed: seed,
            )..initialize(),
            child: const TransferView(),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.transferBeneficiaryPicker,
        builder: (context, state) => ChangeNotifierProvider(
          create: (_) => BeneficiariesViewModel(_beneficiaryService)..load(),
          child: Builder(
            builder: (context) => BeneficiariesView(
              selectionMode: true,
              onBeneficiaryTap: (contact) => context.pop(contact),
            ),
          ),
        ),
      ),
      GoRoute(path: AppRoutes.beneficiaryCreate,
        builder: (context, state) => ChangeNotifierProvider(
          create: (_) => BeneficiaryFormViewModel(_beneficiaryService)..load(),
          child: const BeneficiaryFormView())),
      GoRoute(path: AppRoutes.beneficiaryEdit,
        builder: (context, state) => ChangeNotifierProvider(
          create: (_) => BeneficiaryFormViewModel(_beneficiaryService,
            id: state.pathParameters['beneficiaryId']!)..load(),
          child: const BeneficiaryFormView())),
      GoRoute(
        path: AppRoutes.transactionHistory,
        builder: (context, state) => ChangeNotifierProvider(
          create: (_) => TransferHistoryViewModel(
            service: _transferHistoryService,
          )..refresh(),
          child: const TransferHistoryView(),
        ),
      ),
      GoRoute(
        path: AppRoutes.transactionDetail,
        builder: (context, state) => ChangeNotifierProvider(
          create: (_) => TransferDetailViewModel(
            service: _transferHistoryService,
            transferId: state.pathParameters['transactionId']!,
          )..load(),
          child: const TransferDetailView(),
        ),
      ),
      // =====================================================
      // SPLASH
      // =====================================================
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) {
          return ChangeNotifierProvider(
            create: (_) => SplashViewModel(
              sessionService: _sessionService,
              refreshService: _refreshService,
              biometricService: _biometricService,
            ),
            child: const SplashView(),
          );
        },
      ),

      // =====================================================
      // LOGIN
      // =====================================================
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) {
          return ChangeNotifierProvider(
            create: (_) => LoginViewModel(
              loginService: _loginService,
              sessionService: _sessionService,
            ),
            child: const LoginView(),
          );
        },
      ),

      // =====================================================
      // REGISTER
      // =====================================================
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) {
          return ChangeNotifierProvider(
            create: (_) => RegisterViewModel(
              registerService: _registerService,
              sessionService: _sessionService,
            ),
            child: const RegisterView(),
          );
        },
      ),

      // =====================================================
      // HOME
      // =====================================================
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider<BeneficiariesViewModel>(
                create: (_) => BeneficiariesViewModel(_beneficiaryService)..load()),
              ChangeNotifierProvider<ProfileViewModel>(
                create: (_) =>
                    ProfileViewModel(sessionService: _sessionService),
              ),

              ChangeNotifierProvider<CurrentDeviceViewModel>(
                create: (_) => CurrentDeviceViewModel(
                  service: _activeSessionsService,
                  sessionService: _sessionService,
                ),
              ),

              // =====================================================
              // HOME
              // =====================================================
              ChangeNotifierProvider<HomeViewModel>(
                create: (_) => HomeViewModel(service: _homeService),
              ),
            ],
            child: const HomePage(),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.profileSecurity,
        builder: (context, state) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (_) => SecurityPrivacyViewModel(
                  biometricService: _biometricService,
                )..initialize(),
              ),

              ChangeNotifierProvider(
                create: (_) => ActiveSessionsViewModel(
                  service: _activeSessionsService,
                  sessionService: _sessionService,
                ),
              ),
            ],
            child: const SecurityPrivacyView(),
          );
        },
      ),
      // =====================================================
      // ACTIVE SESSIONS
      // =====================================================
      GoRoute(
        path: AppRoutes.activeSessions,
        builder: (context, state) {
          return ChangeNotifierProvider(
            create: (_) => ActiveSessionsViewModel(
              service: _activeSessionsService,
              sessionService: _sessionService,
            ),
            child: const ActiveSessionsView(),
          );
        },
      ),
      // =====================================================
      // CURRENT DEVICE
      // =====================================================
      GoRoute(
        path: AppRoutes.currentDevice,
        builder: (context, state) {
          return ChangeNotifierProvider(
            create: (_) => CurrentDeviceViewModel(
              service: _activeSessionsService,
              sessionService: _sessionService,
            ),
            child: const CurrentDeviceView(),
          );
        },
      ),
      // =====================================================
      // EXCHANGE RATES
      // =====================================================
      GoRoute(
        path: AppRoutes.exchangeRates,
        builder: (context, state) {
          return ChangeNotifierProvider<ExchangeRatesViewModel>(
            create: (_) => ExchangeRatesViewModel(
              _exchangeRateRepository,
            ),
            child: const ExchangeRatesView(),
          );
        },
      ),
    ],
  );
}

