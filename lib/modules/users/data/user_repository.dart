import 'package:injectable/injectable.dart';
import 'package:mysql1/mysql1.dart';
import 'package:pizza_delivery_api/application/database/i_database_connection.dart';
import 'package:pizza_delivery_api/application/exceptions/database_error_exception.dart';
import 'package:pizza_delivery_api/application/helpers/cripty_helpers.dart';
import 'package:pizza_delivery_api/modules/users/data/i_user_repository.dart';
import 'package:pizza_delivery_api/modules/users/view_models/register_user_input_model.dart';

@LazySingleton(as: IUserRepository)
class UserRepository implements IUserRepository {
  final IDatabaseConnection _connection;

  UserRepository(this._connection);

  @override
  Future<void> saveuser(RegisterUserInputModel inputModel) async {
    final conn = await _connection.openConnection();

    try {
      await conn
          .query('INSERT INTO usuario(nome, email, senha) VALUES (?,?,?)', [
        inputModel.name,
        inputModel.email,
        CriptyHelpers.generateSHA256Hash(inputModel.password),
      ]);
    } on MySqlConnection catch (e) {
      print(e);
      throw DatabaseErrorException(message: 'Erro ao registrar o usuáro');
    } finally {
      await conn?.close();
    }
  }
}