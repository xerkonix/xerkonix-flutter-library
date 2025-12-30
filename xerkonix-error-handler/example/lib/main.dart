import 'package:flutter/material.dart';
import 'package:xerkonix_error_handler/xerkonix_error_handler.dart';
import 'package:xerkonix_design_system/xerkonix_design_system.dart';

import 'custom_error.dart';
import 'custom_exception.dart';
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
          title: 'Xerkonix Error Handler Test App',
          theme: themeData,
          home: const MyHomePage(title: 'Xerkonix Error Handler'),
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
  String _testResult = 'No test executed yet. Click buttons to test error handling.';
  List<String> _consoleLogs = [];

  void _testConflictError() {
    try {
      XkError xkError = XkErrors.conflict(
        type: 'Conflict',
        message: 'Resource conflict occurred',
        title: 'Conflict Error',
        detail: 'The resource you are trying to create already exists',
      );
      throw XkException(xkError);
    } on XkException catch (e) {
      setState(() {
        _testResult = 'Conflict Error: Dialog shown';
        _consoleLogs.insert(0, '[ERROR] ${e.xkError.runtimeType}Exception: ${e.xkError.message}');
        _consoleLogs.insert(1, '[ERROR] Code: ${e.xkError.code ?? "N/A"}, Type: ${e.xkError.type ?? "N/A"}');
        _consoleLogs.insert(2, '[ERROR] Title: ${e.xkError.title ?? "N/A"}, Detail: ${e.xkError.detail ?? "N/A"}');
        if (_consoleLogs.length > 20) _consoleLogs = _consoleLogs.take(20).toList();
      });
      XkErrorMessageHandler.showError(
        context: context,
        widgetType: WidgetType.dialog,
      );
    }
  }

  void _testBadRequestError() {
    try {
      XkError xkError = XkErrors.badRequest(
        type: 'BadRequest',
        message: 'Invalid request parameters',
        title: 'Bad Request',
        detail: 'Please check your input and try again',
      );
      throw XkException(xkError);
    } on XkException catch (e) {
      setState(() {
        _testResult = 'Bad Request Error: Dialog shown';
        _consoleLogs.insert(0, '[ERROR] ${e.xkError.runtimeType}Exception: ${e.xkError.message}');
        _consoleLogs.insert(1, '[ERROR] Code: ${e.xkError.code ?? "N/A"}, Type: ${e.xkError.type ?? "N/A"}');
        _consoleLogs.insert(2, '[ERROR] Title: ${e.xkError.title ?? "N/A"}, Detail: ${e.xkError.detail ?? "N/A"}');
        if (_consoleLogs.length > 20) _consoleLogs = _consoleLogs.take(20).toList();
      });
      XkErrorMessageHandler.showError(
        context: context,
        widgetType: WidgetType.dialog,
      );
    }
  }

  void _testUnauthorizedError() {
    try {
      XkError xkError = XkErrors.unauthorized(
        type: 'Unauthorized',
        message: 'Authentication required',
        title: 'Unauthorized',
        detail: 'Please login to continue',
      );
      throw XkException(xkError);
    } on XkException catch (e) {
      setState(() {
        _testResult = 'Unauthorized Error: Dialog shown';
        _consoleLogs.insert(0, '[ERROR] ${e.xkError.runtimeType}Exception: ${e.xkError.message}');
        _consoleLogs.insert(1, '[ERROR] Code: ${e.xkError.code ?? "N/A"}, Type: ${e.xkError.type ?? "N/A"}');
        _consoleLogs.insert(2, '[ERROR] Title: ${e.xkError.title ?? "N/A"}, Detail: ${e.xkError.detail ?? "N/A"}');
        if (_consoleLogs.length > 20) _consoleLogs = _consoleLogs.take(20).toList();
      });
      XkErrorMessageHandler.showError(
        context: context,
        widgetType: WidgetType.dialog,
      );
    }
  }

  void _testNotFoundError() {
    try {
      XkError xkError = XkErrors.notFound(
        type: 'NotFound',
        message: 'Resource not found',
        title: 'Not Found',
        detail: 'The requested resource does not exist',
      );
      throw XkException(xkError);
    } on XkException catch (e) {
      setState(() {
        _testResult = 'Not Found Error: Dialog shown';
        _consoleLogs.insert(0, '[ERROR] ${e.xkError.runtimeType}Exception: ${e.xkError.message}');
        _consoleLogs.insert(1, '[ERROR] Code: ${e.xkError.code ?? "N/A"}, Type: ${e.xkError.type ?? "N/A"}');
        _consoleLogs.insert(2, '[ERROR] Title: ${e.xkError.title ?? "N/A"}, Detail: ${e.xkError.detail ?? "N/A"}');
        if (_consoleLogs.length > 20) _consoleLogs = _consoleLogs.take(20).toList();
      });
      XkErrorMessageHandler.showError(
        context: context,
        widgetType: WidgetType.dialog,
      );
    }
  }

  void _testInternalServerError() {
    try {
      XkError xkError = XkErrors.internalServerError(
        type: 'InternalServerError',
        message: 'Server error occurred',
        title: 'Server Error',
        detail: 'An internal server error occurred. Please try again later.',
      );
      throw XkException(xkError);
    } on XkException catch (e) {
      setState(() {
        _testResult = 'Internal Server Error: Dialog shown';
        _consoleLogs.insert(0, '[ERROR] ${e.xkError.runtimeType}Exception: ${e.xkError.message}');
        _consoleLogs.insert(1, '[ERROR] Code: ${e.xkError.code ?? "N/A"}, Type: ${e.xkError.type ?? "N/A"}');
        _consoleLogs.insert(2, '[ERROR] Title: ${e.xkError.title ?? "N/A"}, Detail: ${e.xkError.detail ?? "N/A"}');
        if (_consoleLogs.length > 20) _consoleLogs = _consoleLogs.take(20).toList();
      });
      XkErrorMessageHandler.showError(
        context: context,
        widgetType: WidgetType.dialog,
      );
    }
  }

  void _testCustomException() {
    try {
      XkError xkError = CustomError(
        "Custom Error Message",
        code: "CUSTOM_001",
        type: "CustomError",
      );
      throw CustomException(xkError);
    } on CustomException catch (e) {
      setState(() {
        _testResult = 'Custom Exception: Dialog shown';
        _consoleLogs.insert(0, '[ERROR] CustomException: ${e.xkError.message}');
        _consoleLogs.insert(1, '[ERROR] Code: ${e.xkError.code ?? "N/A"}, Type: ${e.xkError.type ?? "N/A"}');
        _consoleLogs.insert(2, '[ERROR] Title: ${e.xkError.title ?? "N/A"}, Detail: ${e.xkError.detail ?? "N/A"}');
        if (_consoleLogs.length > 20) _consoleLogs = _consoleLogs.take(20).toList();
      });
      XkErrorMessageHandler.showError(
        context: context,
        widgetType: WidgetType.dialog,
      );
    }
  }

  void _testCustomErrorDialog() {
    try {
      XkError xkError = CustomError(
        "Custom Error Message Dialog",
        code: "CUSTOM_002",
        type: "CustomError",
      );
      throw CustomException(xkError);
    } on CustomException catch (e) {
      setState(() {
        _testResult = 'Custom Error Dialog: Custom dialog shown';
        _consoleLogs.insert(0, '[ERROR] CustomException: ${e.xkError.message}');
        _consoleLogs.insert(1, '[ERROR] Code: ${e.xkError.code ?? "N/A"}, Type: ${e.xkError.type ?? "N/A"}');
        _consoleLogs.insert(2, '[ERROR] Title: ${e.xkError.title ?? "N/A"}, Detail: ${e.xkError.detail ?? "N/A"}');
        if (_consoleLogs.length > 20) _consoleLogs = _consoleLogs.take(20).toList();
      });
      XkErrorMessageHandler.showError(
        context: context,
        widgetType: WidgetType.dialog,
        customErrorDialog: AlertDialog(
          title: const Text('Custom Error Title'),
          content: const Text('This is a custom error dialog with custom buttons.'),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: () {
                    XkErrorMessageHandler.flushErrorMessage();
                    Navigator.of(context).pop();
                  },
                  child: const Text("Button 1"),
                ),
                const SizedBox(width: 24),
                OutlinedButton(
                  onPressed: () {
                    XkErrorMessageHandler.flushErrorMessage();
                    Navigator.of(context).pop();
                  },
                  child: const Text("Button 2"),
                ),
              ],
            ),
          ],
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
      );
    }
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
                      'Error Handler Test Result',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _testResult,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Standard Errors',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton(
                  onPressed: _testBadRequestError,
                  child: const Text('Bad Request'),
                ),
                ElevatedButton(
                  onPressed: _testUnauthorizedError,
                  child: const Text('Unauthorized'),
                ),
                ElevatedButton(
                  onPressed: _testNotFoundError,
                  child: const Text('Not Found'),
                ),
                ElevatedButton(
                  onPressed: _testConflictError,
                  child: const Text('Conflict'),
                ),
                ElevatedButton(
                  onPressed: _testInternalServerError,
                  child: const Text('Server Error'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Custom Errors',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton(
                  onPressed: _testCustomException,
                  child: const Text('Custom Exception'),
                ),
                ElevatedButton(
                  onPressed: _testCustomErrorDialog,
                  child: const Text('Custom Dialog'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Card(
              color: XkColor.canvas.withValues(alpha: 0.5),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.error_outline, color: XkColor.pulse),
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
                    _buildInstructionItem('Click buttons to test error handling'),
                    _buildInstructionItem('Error dialogs will be displayed'),
                    _buildInstructionItem('Error logs are shown in the console and below'),
                    _buildInstructionItem('Custom Dialog shows a custom error dialog'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.terminal, color: XkColor.pulse),
                        const SizedBox(width: 8),
                        const Text(
                          'Console Logs',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        if (_consoleLogs.isNotEmpty)
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _consoleLogs.clear();
                              });
                            },
                            child: const Text('Clear'),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (_consoleLogs.isEmpty)
                      const Text(
                        'No error logs yet. Click error buttons to see logs here.',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      )
                    else
                      Container(
                        constraints: const BoxConstraints(maxHeight: 300),
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: SingleChildScrollView(
                          child: SelectableText(
                            _consoleLogs.join('\n'),
                            style: const TextStyle(
                              fontSize: 11,
                              fontFamily: 'monospace',
                              color: Colors.greenAccent,
                            ),
                          ),
                        ),
                      ),
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
