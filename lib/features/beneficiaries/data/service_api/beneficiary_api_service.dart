import 'package:dio/dio.dart';
import '../dto/beneficiary_contact_dto.dart';

class BeneficiaryApiService {
  final Dio dio;
  BeneficiaryApiService(this.dio);
  static const path = '/api/v1/beneficiary-contacts';
  Future<List<BeneficiaryContactDto>> list() async {
    final response = await dio.get<List<dynamic>>(path);
    return response.data!.map((r) => BeneficiaryContactDto(r as Map<String, dynamic>)).toList();
  }
  Future<BeneficiaryContactDto> get(String id) async {
    final response = await dio.get<Map<String, dynamic>>('$path/${Uri.encodeComponent(id)}');
    return BeneficiaryContactDto(response.data!);
  }
  Future<BeneficiaryCatalogDto> catalog() async {
    final response = await dio.get<Map<String, dynamic>>('$path/catalog');
    return BeneficiaryCatalogDto(response.data!);
  }
  Future<BeneficiaryContactDto> save(Map<String, dynamic> body, {String? id}) async {
    final response = id == null
      ? await dio.post<Map<String, dynamic>>(path, data: body)
      : await dio.put<Map<String, dynamic>>('$path/${Uri.encodeComponent(id)}', data: body);
    return BeneficiaryContactDto(response.data!);
  }
}
