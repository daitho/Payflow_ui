import '../model/home_model.dart';

abstract interface class HomeRepository {
  Future<HomeModel> getHome();
}