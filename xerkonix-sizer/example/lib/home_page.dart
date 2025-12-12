import 'package:flutter/material.dart';
import 'package:xerkonix_sizer/xerkonix_sizer.dart';
import 'package:xerkonix_design_system/xerkonix_design_system.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    ResponsiveSizer responsiveSizer = ResponsiveSizer(context: context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Xerkonix Sizer"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(Sizer.unitWidth.lp16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: EdgeInsets.all(Sizer.unitWidth.lp16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Sizer Information',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: Sizer.unitHeight.lp8),
                    _buildInfoRow('Window Width', '${responsiveSizer.unitWidth.window.toStringAsFixed(2)}'),
                    _buildInfoRow('Window Height', '${responsiveSizer.unitHeight.window.toStringAsFixed(2)}'),
                    _buildInfoRow('Standard Width', '${Sizer.unitWidth.standard.toStringAsFixed(2)}'),
                    _buildInfoRow('Standard Height', '${Sizer.unitHeight.standard.toStringAsFixed(2)}'),
                    _buildInfoRow('Safe Area Top', '${Sizer.unitPadding.topSafeArea.toStringAsFixed(2)}'),
                    _buildInfoRow('Safe Area Bottom', '${Sizer.unitPadding.bottomSafeArea.toStringAsFixed(2)}'),
                    _buildInfoRow('Safe Area Total', '${Sizer.unitPadding.safeAreaPadding.toStringAsFixed(2)}'),
                  ],
                ),
              ),
            ),
            SizedBox(height: Sizer.unitHeight.lp16),
            Card(
              child: Padding(
                padding: EdgeInsets.all(Sizer.unitWidth.lp16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'LP Values Test',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: Sizer.unitHeight.lp8),
                    _buildInfoRow('LP4 Width', '${Sizer.unitWidth.lp4.toStringAsFixed(2)}'),
                    _buildInfoRow('LP4 Height', '${Sizer.unitHeight.lp4.toStringAsFixed(2)}'),
                    _buildInfoRow('LP8 Width', '${Sizer.unitWidth.lp8.toStringAsFixed(2)}'),
                    _buildInfoRow('LP8 Height', '${Sizer.unitHeight.lp8.toStringAsFixed(2)}'),
                    _buildInfoRow('LP16 Width', '${Sizer.unitWidth.lp16.toStringAsFixed(2)}'),
                    _buildInfoRow('LP16 Height', '${Sizer.unitHeight.lp16.toStringAsFixed(2)}'),
                    _buildInfoRow('LP32 Width', '${Sizer.unitWidth.lp32.toStringAsFixed(2)}'),
                    _buildInfoRow('LP32 Height', '${Sizer.unitHeight.lp32.toStringAsFixed(2)}'),
                    _buildInfoRow('LP64 Width', '${Sizer.unitWidth.lp64.toStringAsFixed(2)}'),
                    _buildInfoRow('LP64 Height', '${Sizer.unitHeight.lp64.toStringAsFixed(2)}'),
                  ],
                ),
              ),
            ),
            SizedBox(height: Sizer.unitHeight.lp16),
            Card(
              child: Padding(
                padding: EdgeInsets.all(Sizer.unitWidth.lp16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Responsive Sizer Test',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: Sizer.unitHeight.lp8),
                    _buildInfoRow('Responsive LP4 Width', '${responsiveSizer.unitWidth.lp4.toStringAsFixed(2)}'),
                    _buildInfoRow('Responsive LP4 Height', '${responsiveSizer.unitHeight.lp4.toStringAsFixed(2)}'),
                    _buildInfoRow('Responsive LP16 Width', '${responsiveSizer.unitWidth.lp16.toStringAsFixed(2)}'),
                    _buildInfoRow('Responsive LP16 Height', '${responsiveSizer.unitHeight.lp16.toStringAsFixed(2)}'),
                  ],
                ),
              ),
            ),
            SizedBox(height: Sizer.unitHeight.lp16),
            Center(
              child: Container(
                width: responsiveSizer.unitWidth.lp52,
                height: responsiveSizer.unitHeight.lp52,
                decoration: BoxDecoration(
                  color: XkColor.identity.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: XkColor.identity.withOpacity(0.4),
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    'Responsive Container',
                    style: TextStyle(
                      color: XkColor.structure,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: Sizer.unitHeight.lp16),
            Card(
              color: XkColor.canvas.withOpacity(0.5),
              child: Padding(
                padding: EdgeInsets.all(Sizer.unitWidth.lp16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: XkColor.identity),
                        SizedBox(width: Sizer.unitWidth.lp8),
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
                    SizedBox(height: Sizer.unitHeight.lp8),
                    _buildInstructionItem('Sizer는 화면 크기에 따라 자동으로 조정됩니다'),
                    _buildInstructionItem('LP 값은 Logical Pixel을 의미합니다'),
                    _buildInstructionItem('Responsive Sizer는 현재 컨텍스트를 기반으로 계산됩니다'),
                    _buildInstructionItem('Rebuild 버튼으로 값 갱신을 확인할 수 있습니다'),
                    SizedBox(height: Sizer.unitHeight.lp8),
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          setState(() {});
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text("Rebuild"),
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

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Sizer.unitHeight.lp4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value, style: const TextStyle(fontFamily: 'monospace')),
        ],
      ),
    );
  }

  Widget _buildInstructionItem(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: Sizer.unitHeight.lp4),
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
