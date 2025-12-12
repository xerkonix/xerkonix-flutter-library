import '../http_utils/xerkonix_http_config.dart';
import 'xerkonix_http_client.dart';

class XkHttp {
  XkHttp({required this.client, required this.config});

  final XkHttpClient client;
  final XkHttpConfig config;
}
