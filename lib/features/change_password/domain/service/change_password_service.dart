import '../model/change_password_command.dart';
import '../repository/change_password_repository.dart';

class ChangePasswordService {
  final ChangePasswordRepository _repository;

  const ChangePasswordService({required ChangePasswordRepository repository})
    : _repository = repository;

  Future<void> changePassword(ChangePasswordCommand command) {
    return _repository.changePassword(command);
  }
}
