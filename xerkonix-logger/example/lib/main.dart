import 'package:flutter/material.dart';
import 'package:xerkonix_logger/xerkonix_logger.dart';
import 'package:xerkonix_design_system/xerkonix_design_system.dart';
import 'package:http/http.dart' as http;

import 'theme_notifier.dart';

void main() {
  runApp(ThemeNotifier(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: ThemeNotifier.of(context)!.theme,
      builder: (BuildContext context, ThemeData themeData, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Xerkonix Logger Test App',
          theme: themeData,
          home: const MyHomePage(title: 'Xerkonix Logger'),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _logResult = 'No logs generated yet. Click buttons to test.';

  Uri _generateUri() {
    return Uri(
        scheme: "https",
        host: "api.agify.io",
        path: null,
        queryParameters: null,
        query: "name=dhkim");
  }

  Future<http.Response> _httpRequest({required http.Request request}) async {
    final streamedResponse = await request.send();
    return await http.Response.fromStream(streamedResponse);
  }

  void _testDefaultLogger() {
    Logger("Default Logger");
    Logger("You can use this for even Object ${_TestObjectPrint()}");
    setState(() {
      _logResult = '🪵 Default Logger\n🪵 You can use this for even Object Instance of \'_TestObjectPrint\'';
    });
  }

  void _testLevelLoggers() {
    Logger.warning("Warning Message");
    Logger.info("Info Message");
    Logger.debug("Debugging Message");
    Logger.log("log1\nlog2\nlog3\nlog4\nlog5");
    Logger.build("build start\nbuilding...\nbuilding...\nbuilding...\nbuild done");
    setState(() {
      _logResult = '⚠️ Warning Message\n💡 Info Message\n🐛 Debugging Message\n💬 log1\n💬 log2\n💬 log3\n💬 log4\n💬 log5\n🏗 build start\n🏗 building...\n🏗 building...\n🏗 building...\n🏗 build done';
    });
  }

  void _testFunLoggers() {
    FunLogger.heart("I Love You.");
    FunLogger.robot("Robot Message");
    FunLogger.poop("Shit Code");
    setState(() {
      _logResult = '❤️ I Love You.\n🤖 Robot Message\n💩️ Shit Code';
    });
  }

  void _testExceptionLoggers() {
            Logger.exception(_XkException("Exception Message"));
            Logger.error(XkError.example());
            Logger.errorMessage("error message");
    setState(() {
      _logResult = '🚫 XkException: Exception Message\n🛑 TEST_ERROR\nError occurred\nError Title\nError Message\n🛑 error message';
    });
  }

  Future<void> _testHttpLoggers() async {
    http.Request request = http.Request("GET", _generateUri());
    request.headers.addAll({'Content-Type': 'application/json'});

    Logger.httpRequest(httpRequest: request);
    http.Response response = await _httpRequest(request: request);
    Logger.httpResponse(httpResponse: response);
    Logger.httpResponse(httpResponse: response, printHeaders: true);
    
    final requestTime = DateTime.now();
    final responseTime = DateTime.now();
    final responseBody = response.body.length > 200 
        ? '${response.body.substring(0, 200)}...' 
        : response.body;
    
    setState(() {
      _logResult = '➡️ Http Request $requestTime\nURI: ${request.url}\nMethod: ${request.method}\nheaders: ${request.headers}\nBody: ${request.body}\n\n⬅️ Http Response $responseTime\nStatus Code: ${response.statusCode}\nBody: $responseBody\n\n⬅️ Http Response $responseTime\nStatus Code: ${response.statusCode}\nHeaders ${response.headers}\nBody: $responseBody';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Logger Test Result',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: XkColor.canvas.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: XkColor.divider,
                          width: 1,
                        ),
                      ),
                      child: SelectableText(
                      _logResult,
                        style: const TextStyle(
                          fontSize: 12,
                          fontFamily: 'monospace',
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton(
                  onPressed: _testDefaultLogger,
                  child: const Text('Default Logger'),
                ),
                ElevatedButton(
                  onPressed: _testLevelLoggers,
                  child: const Text('Level Loggers'),
                ),
                ElevatedButton(
                  onPressed: _testFunLoggers,
                  child: const Text('Fun Loggers'),
                ),
                ElevatedButton(
                  onPressed: _testExceptionLoggers,
                  child: const Text('Exception Loggers'),
                ),
                ElevatedButton(
                  onPressed: _testHttpLoggers,
                  child: const Text('HTTP Loggers'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Card(
              color: XkColor.canvas.withOpacity(0.5),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.article_outlined, color: XkColor.identity),
                        const SizedBox(width: 8),
                        Text(
                          'Test Instructions',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: XkColor.structure,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildInstructionItem('Click each button to test the logger'),
                    _buildInstructionItem('All logs are displayed on the screen above'),
                    _buildInstructionItem('Logs are also printed to the console in debug mode'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 14)),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }
}

class _TestObjectPrint {
  final String str = "Instance";
  final int integer = 3;
}

class _XkException implements Exception {
  _XkException(this.message);

  final String? message;

  @override
  String toString() {
    return "XkException: $message";
  }
}

class XkError implements Error {
  final String? type;
  final String? message;
  final String? title;
  final String? detail;

  XkError({this.type, this.message, this.title, this.detail});

  @override
  String toString() {
    return "$type\n$message\n$title\n$detail";
  }

  @override
  StackTrace? get stackTrace => StackTrace.current;

  factory XkError.example(
      {String? type,
      String? message,
      String? title,
      String? detail}) = _Example;
}

class _Example extends XkError {
  _Example({String? type, String? message, String? title, String? detail})
      : super(
            type: type ?? "TEST_ERROR",
            message: message ?? 'Error occurred',
            title: title ?? 'Error Title',
            detail: detail ?? 'Error Message');
}
