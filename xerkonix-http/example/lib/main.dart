import 'package:flutter/material.dart';
import 'package:xerkonix_http/xerkonix_http.dart';
import 'package:xerkonix_design_system/xerkonix_design_system.dart';

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
          title: 'Xerkonix HTTP Test App',
          theme: themeData,
          home: const MyHomePage(title: 'Xerkonix HTTP'),
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
  String _result = 'No request made yet';
  bool _isLoading = false;

  final XkHttp _http = XkHttpUtils.generateHttp(
    scheme: "https",
    host: 'jsonplaceholder.typicode.com',
    port: 443,
  );

  Future<void> _testGet() async {
    setState(() {
      _isLoading = true;
      _result = 'Loading...';
    });
    try {
      final result = await _http.client.get(path: '/posts/1');
      setState(() {
        _result = 'GET Success: ${result.toString().substring(0, result.toString().length > 100 ? 100 : result.toString().length)}...';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _result = 'GET Error: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _testPost() async {
    setState(() {
      _isLoading = true;
      _result = 'Loading...';
    });
    try {
      final result = await _http.client.post(
        path: '/posts',
        body: {
          "title": "Test Post",
          "body": "This is a test",
          "userId": 1
        },
      );
      setState(() {
        _result = 'POST Success: ${result.toString().substring(0, result.toString().length > 100 ? 100 : result.toString().length)}...';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _result = 'POST Error: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _testPut() async {
    setState(() {
      _isLoading = true;
      _result = 'Loading...';
    });
    try {
      final result = await _http.client.put(
        path: '/posts/1',
        body: {
          "id": 1,
          "title": "Updated Post",
          "body": "This is an updated test",
          "userId": 1
        },
      );
      setState(() {
        _result = 'PUT Success: ${result.toString().substring(0, result.toString().length > 100 ? 100 : result.toString().length)}...';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _result = 'PUT Error: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _testDelete() async {
    setState(() {
      _isLoading = true;
      _result = 'Loading...';
    });
    try {
      final result = await _http.client.delete(
        path: '/posts/1',
        body: {},
      );
      setState(() {
        _result = 'DELETE Success: ${result?.toString() ?? "null"}';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _result = 'DELETE Error: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _testPatch() async {
    setState(() {
      _isLoading = true;
      _result = 'Loading...';
    });
    try {
      final result = await _http.client.patch(
        path: '/posts/1',
        body: {
          "title": "Patched Post"
        },
      );
      setState(() {
        _result = 'PATCH Success: ${result.toString().substring(0, result.toString().length > 100 ? 100 : result.toString().length)}...';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _result = 'PATCH Error: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _testCustom() async {
    setState(() {
      _isLoading = true;
      _result = 'Loading...';
    });
    try {
      final result = await _http.client.custom(
        uriAddress: 'https://jsonplaceholder.typicode.com/posts/1',
        method: "GET",
      );
      setState(() {
        _result = 'CUSTOM Success: ${result.toString().substring(0, result.toString().length > 100 ? 100 : result.toString().length)}...';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _result = 'CUSTOM Error: $e';
        _isLoading = false;
      });
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
                      'HTTP Methods Test',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _result,
                      style: const TextStyle(fontSize: 12),
                    ),
                    if (_isLoading) ...[
                      const SizedBox(height: 8),
                      const LinearProgressIndicator(),
                    ],
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
                  onPressed: _isLoading ? null : _testGet,
                  child: const Text('GET'),
                ),
                ElevatedButton(
                  onPressed: _isLoading ? null : _testPost,
                  child: const Text('POST'),
                ),
                ElevatedButton(
                  onPressed: _isLoading ? null : _testPut,
                  child: const Text('PUT'),
                ),
                ElevatedButton(
                  onPressed: _isLoading ? null : _testDelete,
                  child: const Text('DELETE'),
                ),
                ElevatedButton(
                  onPressed: _isLoading ? null : _testPatch,
                  child: const Text('PATCH'),
                ),
                ElevatedButton(
                  onPressed: _isLoading ? null : _testCustom,
                  child: const Text('CUSTOM'),
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
                        Icon(Icons.info_outline, color: XkColor.identity),
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
                    _buildInstructionItem('각 버튼을 클릭하여 HTTP 메서드를 테스트합니다'),
                    _buildInstructionItem('결과는 위의 카드에 표시됩니다'),
                    _buildInstructionItem('로그는 콘솔에서 확인할 수 있습니다'),
                    _buildInstructionItem('에러가 발생하면 에러 메시지가 표시됩니다'),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: XkColor.identity.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: XkColor.identity.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        'API: jsonplaceholder.typicode.com',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: XkColor.structure,
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
