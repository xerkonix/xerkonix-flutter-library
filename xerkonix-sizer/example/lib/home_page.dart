import 'package:flutter/material.dart';
import 'package:xerkonix_sizer/xerkonix_sizer.dart';
import 'package:xerkonix_design_system/xerkonix_design_system.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ResponsiveSizer? _responsiveSizer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _responsiveSizer = ResponsiveSizer(context: context);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // ResponsiveSizer가 없으면 초기화
    _responsiveSizer ??= ResponsiveSizer(context: context);
    
    return LayoutBuilder(
      builder: (context, constraints) {
        // 창 크기 변경 시 ResponsiveSizer 재계산
        _responsiveSizer?.measure();
        return Scaffold(
          backgroundColor: XkColor.canvas,
          appBar: AppBar(
            title: Text(
              'Xerkonix Sizer',
              style: XkTypo.title2.copyWith(color: XkColor.structure),
            ),
            backgroundColor: XkColor.canvas,
            elevation: 0,
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(Sizer.unitWidth.lp16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSection(
                  title: 'Sizer Information',
                  icon: Icons.info_outline,
                  child: Column(
                    children: [
                      _buildInfoRow('Window Width', _responsiveSizer!.unitWidth.window.toStringAsFixed(2)),
                      _buildDivider(),
                      _buildInfoRow('Window Height', _responsiveSizer!.unitHeight.window.toStringAsFixed(2)),
                      _buildDivider(),
                      _buildInfoRow('Standard Width', Sizer.unitWidth.standard.toStringAsFixed(2)),
                      _buildDivider(),
                      _buildInfoRow('Standard Height', Sizer.unitHeight.standard.toStringAsFixed(2)),
                      SizedBox(height: Sizer.unitHeight.lp16),
                      Center(
                        child: XkButton.primary(
                          onPressed: () {
                            setState(() {
                              // 현재 창 크기로 Standard Width와 Height 재설정
                              final currentWidth = _responsiveSizer!.unitWidth.window;
                              final currentHeight = _responsiveSizer!.unitHeight.window;
                              Sizer.init(
                                standardLogicalWidth: currentWidth,
                                standardLogicalHeight: currentHeight,
                              );
                              // ResponsiveSizer도 재계산
                              _responsiveSizer?.measure();
                            });
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.refresh, size: 18),
                              SizedBox(width: Sizer.unitWidth.lp8),
                              Text('Rebuild', style: XkTypo.body),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: Sizer.unitHeight.lp16),
                _buildSection(
                  title: 'LP(Logical Pixel) Values Test',
                  icon: Icons.straighten,
                  child: Column(
                    children: [
                      _buildInfoRow('LP4 Width', Sizer.unitWidth.lp4.toStringAsFixed(2)),
                      _buildDivider(),
                      _buildInfoRow('LP4 Height', Sizer.unitHeight.lp4.toStringAsFixed(2)),
                      _buildDivider(),
                      _buildInfoRow('LP8 Width', Sizer.unitWidth.lp8.toStringAsFixed(2)),
                      _buildDivider(),
                      _buildInfoRow('LP8 Height', Sizer.unitHeight.lp8.toStringAsFixed(2)),
                    ],
                  ),
                ),
                SizedBox(height: Sizer.unitHeight.lp16),
                _buildSection(
                  title: 'Responsive Sizer Test',
                  icon: Icons.aspect_ratio,
                  child: Column(
                    children: [
                      _buildInfoRow('Responsive LP4 Width', _responsiveSizer!.unitWidth.lp4.toStringAsFixed(2)),
                      _buildDivider(),
                      _buildInfoRow('Responsive LP4 Height', _responsiveSizer!.unitHeight.lp4.toStringAsFixed(2)),
                      _buildDivider(),
                      _buildInfoRow('Responsive LP16 Width', _responsiveSizer!.unitWidth.lp16.toStringAsFixed(2)),
                      _buildDivider(),
                      _buildInfoRow('Responsive LP16 Height', _responsiveSizer!.unitHeight.lp16.toStringAsFixed(2)),
                    ],
                  ),
                ),
                SizedBox(height: Sizer.unitHeight.lp16),
                Center(
                  child: Container(
                    width: _responsiveSizer!.unitWidth.lp200,
                    height: _responsiveSizer!.unitHeight.lp100,
                    decoration: BoxDecoration(
                      color: XkColor.identity.withValues(alpha: (0.1 * 255).round().toDouble()),
                      borderRadius: XkShape.defaultBorderRadius,
                      border: Border.all(
                        color: XkColor.identity.withValues(alpha: (0.3 * 255).round().toDouble()),
                        width: 1.5,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Responsive Container',
                        style: XkTypo.body.copyWith(
                          color: XkColor.structure,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: Sizer.unitHeight.lp24),
                Card(
                  color: XkColor.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: XkShape.defaultBorderRadius,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(Sizer.unitWidth.lp16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.lightbulb_outline, color: XkColor.identity, size: 20),
                            SizedBox(width: Sizer.unitWidth.lp8),
                            Text(
                              'Test Instructions',
                              style: XkTypo.headline.copyWith(color: XkColor.structure),
                            ),
                          ],
                        ),
                        SizedBox(height: Sizer.unitHeight.lp16),
                        _buildInstructionItem('Sizer automatically adjusts based on screen size'),
                        SizedBox(height: Sizer.unitHeight.lp8),
                        _buildInstructionItem('LP values represent Logical Pixels'),
                        SizedBox(height: Sizer.unitHeight.lp8),
                        _buildInstructionItem('Responsive Sizer calculates based on current context'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Card(
      color: XkColor.surface,
      shape: RoundedRectangleBorder(
        borderRadius: XkShape.defaultBorderRadius,
      ),
      child: Padding(
        padding: EdgeInsets.all(Sizer.unitWidth.lp16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: XkColor.identity, size: 20),
                SizedBox(width: Sizer.unitWidth.lp8),
                Text(
                  title,
                  style: XkTypo.headline.copyWith(color: XkColor.structure),
                ),
              ],
            ),
            SizedBox(height: Sizer.unitHeight.lp16),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Sizer.unitHeight.lp8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: XkTypo.body.copyWith(color: XkColor.bodyText),
            ),
          ),
          Text(
            value,
            style: XkTypo.body.copyWith(
              color: XkColor.structure,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: XkColor.divider,
    );
  }

  Widget _buildInstructionItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: Sizer.unitHeight.lp4, right: Sizer.unitWidth.lp8),
          width: Sizer.unitWidth.lp4,
          height: Sizer.unitWidth.lp4,
          decoration: BoxDecoration(
            color: XkColor.identity,
            shape: BoxShape.circle,
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: XkTypo.body.copyWith(color: XkColor.bodyText),
          ),
        ),
      ],
    );
  }
}
