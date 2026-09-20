import '../model/change_password_command.dart';

abstract interface class ChangePasswordRepository {
  Future<void> changePassword(ChangePasswordCommand command);
}
