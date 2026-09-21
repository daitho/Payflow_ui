import 'package:flutter_test/flutter_test.dart';
import 'package:pay_flow_ui/features/change_password/domain/exception/change_password_exception.dart';
import 'package:pay_flow_ui/features/change_password/domain/model/change_password_command.dart';
import 'package:pay_flow_ui/features/change_password/domain/repository/change_password_repository.dart';
import 'package:pay_flow_ui/features/change_password/domain/service/change_password_service.dart';
import 'package:pay_flow_ui/features/change_password/presentation/view_model/change_password_view_model.dart';

void main() {
  late _FakeChangePasswordRepository repository;
  late ChangePasswordViewModel viewModel;

  setUp(() {
    repository = _FakeChangePasswordRepository();
    viewModel = ChangePasswordViewModel(
      service: ChangePasswordService(repository: repository),
    );
  });

  test('rejects a weak password before calling the repository', () async {
    final success = await viewModel.submit(
      currentPassword: 'CurrentPassword!1',
      newPassword: 'weak',
      confirmationPassword: 'weak',
    );

    expect(success, isFalse);
    expect(viewModel.newPasswordError, NewPasswordFieldError.weak);
    expect(repository.command, isNull);
  });

  test('rejects a confirmation that does not match', () async {
    final success = await viewModel.submit(
      currentPassword: 'CurrentPassword!1',
      newPassword: 'NewPassword!123',
      confirmationPassword: 'AnotherPassword!123',
    );

    expect(success, isFalse);
    expect(
      viewModel.confirmationPasswordError,
      ConfirmationPasswordFieldError.mismatch,
    );
    expect(repository.command, isNull);
  });

  test('submits valid passwords to the service', () async {
    final success = await viewModel.submit(
      currentPassword: 'CurrentPassword!1',
      newPassword: 'NewPassword!123',
      confirmationPassword: 'NewPassword!123',
    );

    expect(success, isTrue);
    expect(repository.command?.currentPassword, 'CurrentPassword!1');
    expect(repository.command?.newPassword, 'NewPassword!123');
  });

  test('maps an incorrect current password to its field', () async {
    repository.exception = const ChangePasswordException(
      ChangePasswordErrorType.invalidCurrentPassword,
    );

    final success = await viewModel.submit(
      currentPassword: 'WrongPassword!1',
      newPassword: 'NewPassword!123',
      confirmationPassword: 'NewPassword!123',
    );

    expect(success, isFalse);
    expect(
      viewModel.currentPasswordError,
      CurrentPasswordFieldError.invalid,
    );
    expect(viewModel.errorType, isNull);
  });
}

class _FakeChangePasswordRepository implements ChangePasswordRepository {
  ChangePasswordCommand? command;
  ChangePasswordException? exception;

  @override
  Future<void> changePassword(ChangePasswordCommand command) async {
    this.command = command;

    final error = exception;
    if (error != null) {
      throw error;
    }
  }
}
