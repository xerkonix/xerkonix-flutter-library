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

  void _testConflictError() {
    try {
      XkError xkError = XkErrors.conflict(
        type: 'Conflict',
        message: 'Resource conflict occurred',
        title: 'Conflict Error',
        detail: 'The resource you are trying to create already exists',
      );
      throw XkException(xkError);
    } on XkException {
      setState(() {
        _testResult = 'Conflict Error: Dialog shown';
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
    } on XkException {
      setState(() {
        _testResult = 'Bad Request Error: Dialog shown';
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
    } on XkException {
      setState(() {
        _testResult = 'Unauthorized Error: Dialog shown';
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
    } on XkException {
      setState(() {
        _testResult = 'Not Found Error: Dialog shown';
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
    } on XkException {
      setState(() {
        _testResult = 'Internal Server Error: Dialog shown';
      });
      XkErrorMessageHandler.showError(
        context: context,
        widgetType: WidgetType.dialog,
      );
    }
  }

  void _testCustomException() {
    try {
      XkError xkError = CustomError("Custom Error Message");
      throw CustomException(xkError);
    } on CustomException {
      setState(() {
        _testResult = 'Custom Exception: Dialog shown';
      });
      XkErrorMessageHandler.showError(
        context: context,
        widgetType: WidgetType.dialog,
      );
    }
  }

  void _testCustomErrorDialog() {
    try {
      XkError xkError = CustomError("Custom Error Message Dialog");
      throw CustomException(xkError);
    } on CustomException {
      setState(() {
        _testResult = 'Custom Error Dialog: Custom dialog shown';
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
              color: XkColor.canvas.withOpacity(0.5),
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
                    _buildInstructionItem('각 버튼을 클릭하여 에러 핸들링을 테스트합니다'),
                    _buildInstructionItem('에러 다이얼로그가 표시됩니다'),
                    _buildInstructionItem('콘솔에서 에러 로그를 확인할 수 있습니다'),
                    _buildInstructionItem('Custom Dialog는 커스텀 다이얼로그를 보여줍니다'),
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
