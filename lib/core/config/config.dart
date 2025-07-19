import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io';

class Config {
  Future<void> init() async {
    print('Current directory: ${Directory.current.path}');
    print('Env file exists: ${File(".env").existsSync()}');
    await dotenv.load(fileName: ".env");
    apiKey = dotenv.env['API_TOKEN']!;
    baseUrl = dotenv.env['API_URI']!;
  }

  static late final String apiKey;
  static late final String baseUrl;
}