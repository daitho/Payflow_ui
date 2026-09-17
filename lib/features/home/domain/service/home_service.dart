import '../model/home_model.dart';
import '../repository/home_repository.dart';

class HomeService {
  final HomeRepository _repository;

  const HomeService({
    required HomeRepository repository,
  }) : _repository = repository;

  // ============================================================
  // GET HOME
  // ============================================================

  Future<HomeModel> getHome() {
    return _repository.getHome();
  }
}