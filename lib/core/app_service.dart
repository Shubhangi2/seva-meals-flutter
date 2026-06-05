import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:seva_meal/datasource/auth_datasource.dart';
import 'package:seva_meal/providers/user_auth_provider.dart';

class AppService {
  static List<SingleChildWidget> provideMultiProviders() {
    return [
      ChangeNotifierProvider(create: (_) => UserAuthProvider(authDatasource: AuthDatasource())),
    ];
  }
}
