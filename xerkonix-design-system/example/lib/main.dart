// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:xerkonix_design_system/xerkonix_design_system.dart';

void main() {
  runApp(const WeaveExampleApp());
}

class WeaveExampleApp extends StatefulWidget {
  const WeaveExampleApp({super.key});

  @override
  State<WeaveExampleApp> createState() => _WeaveExampleAppState();
}

class _WeaveExampleAppState extends State<WeaveExampleApp> {
  bool _isDark = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'XERKONIX Design System v1.3',
      theme: XkLightTheme.themeData,
      darkTheme: XkDarkTheme.themeData,
      themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
      home: WeaveShowcasePage(
        isDark: _isDark,
        onThemeChanged: (value) => setState(() => _isDark = value),
      ),
    );
  }
}

class WeaveShowcasePage extends StatefulWidget {
  const WeaveShowcasePage({
    super.key,
    required this.isDark,
    required this.onThemeChanged,
  });

  final bool isDark;
  final ValueChanged<bool> onThemeChanged;

  @override
  State<WeaveShowcasePage> createState() => _WeaveShowcasePageState();
}

class _WeaveShowcasePageState extends State<WeaveShowcasePage> {
  final _companyController = TextEditingController();
  final _briefController = TextEditingController();
  String _selectedDomain = '수집 · Collect';

  @override
  void initState() {
    super.initState();
    _companyController.text = '주식회사 제르코닉스';
    _briefController.text = '핵심 의사결정 질문을 입력하세요.';
  }

  @override
  void dispose() {
    _companyController.dispose();
    _briefController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('XERKONIX Design System · v1.3', style: XkTypo.h3),
        actions: [
          Row(
            children: [
              Text('Light', style: XkTypo.label),
              Switch(value: widget.isDark, onChanged: widget.onThemeChanged),
              Text('Dark', style: XkTypo.label),
              const SizedBox(width: XkLayout.spacingMd),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(XkLayout.spacingMd),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1180),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Hero(isDark: isDark),
                const SizedBox(height: XkLayout.spacingMd),
                _Section(
                  sectionId: '04 · Iconography',
                  title: 'Icon Set',
                  subtitle:
                      'Weave의 최소 단위를 아이콘으로 정리해, 복잡한 화면에서도 의미를 빠르게 읽게 합니다.',
                  child: _IconGrid(),
                ),
                const SizedBox(height: XkLayout.spacingMd),
                _Section(
                  sectionId: '05 · Components',
                  title: 'Components',
                  subtitle:
                      '공통 UI 컴포넌트를 동일한 토큰 규칙으로 사용합니다.',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: XkLayout.spacingSm,
                        runSpacing: XkLayout.spacingSm,
                        children: [
                          XkButton.primary(
                            onPressed: () {},
                            child: const Text('Primary'),
                          ),
                          XkButton.action(
                            onPressed: () {},
                            child: const Text('Action'),
                          ),
                          XkButton.brand(
                            onPressed: () {},
                            child: const Text('Brand'),
                          ),
                          XkButton.support(
                            onPressed: () {},
                            child: const Text('Support'),
                          ),
                          XkButton.accent(
                            onPressed: () {},
                            child: const Text('Accent'),
                          ),
                          XkButton.tonal(
                            onPressed: () {},
                            child: const Text('Tonal'),
                          ),
                          XkButton.outline(
                            onPressed: () {},
                            child: const Text('Outline'),
                          ),
                        ],
                      ),
                      const SizedBox(height: XkLayout.spacingMd),
                      Wrap(
                        spacing: XkLayout.spacingSm,
                        runSpacing: XkLayout.spacingSm,
                        children: const [
                          XkChip(
                            label: 'default',
                            variant: XkChipVariant.neutral,
                          ),
                          XkChip(
                            label: 'trusted',
                            variant: XkChipVariant.brand,
                          ),
                          XkChip(
                            label: 'recommended',
                            variant: XkChipVariant.support,
                          ),
                          XkChip(
                            label: 'attention',
                            variant: XkChipVariant.accent,
                          ),
                          XkChip(
                            label: 'urgent',
                            variant: XkChipVariant.signal,
                          ),
                        ],
                      ),
                      const SizedBox(height: XkLayout.spacingMd),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final wide = constraints.maxWidth >= 880;
                          return GridView.count(
                            crossAxisCount: wide ? 3 : 1,
                            crossAxisSpacing: XkLayout.spacingSm,
                            mainAxisSpacing: XkLayout.spacingSm,
                            childAspectRatio: wide ? 1.45 : 2.6,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            children: const [
                              XkInfoCard(
                                metric: 'Metric Card',
                                title: 'Primary Value',
                                description:
                                    '핵심 수치, 기준값, 변동값을 같은 위계로 보여주는 기본 카드.',
                              ),
                              XkInfoCard(
                                metric: 'Status Card',
                                title: 'State Delta',
                                description:
                                    '현재 상태와 직전 상태의 차이를 강조해 변화 방향을 알려주는 카드.',
                              ),
                              XkInfoCard(
                                metric: 'Summary Card',
                                title: 'Module Overview',
                                description: '요약 지표와 다음 행동을 함께 배치하는 모듈형 카드.',
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: XkLayout.spacingMd),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final fieldWidth = constraints.maxWidth >= 760
                              ? (constraints.maxWidth - XkLayout.spacingSm) / 2
                              : constraints.maxWidth;
                          return Wrap(
                            spacing: XkLayout.spacingSm,
                            runSpacing: XkLayout.spacingSm,
                            children: [
                              SizedBox(
                                width: fieldWidth,
                                child: XkTextInputField(
                                  label: 'Company',
                                  hintText: '예: 주식회사 제르코닉스',
                                  helperText: '법인명 기준 입력',
                                  controller: _companyController,
                                ),
                              ),
                              SizedBox(
                                width: fieldWidth,
                                child: XkSelectField<String>(
                                  label: 'Domain',
                                  value: _selectedDomain,
                                  helperText: '도메인별 패턴 로드',
                                  options: const [
                                    XkSelectOption(
                                      value: '수집 · Collect',
                                      label: '수집 · Collect',
                                    ),
                                    XkSelectOption(
                                      value: '분석 · Analyze',
                                      label: '분석 · Analyze',
                                    ),
                                    XkSelectOption(
                                      value: '상태 · Map',
                                      label: '상태 · Map',
                                    ),
                                    XkSelectOption(
                                      value: '실행 · Act',
                                      label: '실행 · Act',
                                    ),
                                  ],
                                  onChanged: (value) {
                                    if (value != null) {
                                      setState(() => _selectedDomain = value);
                                    }
                                  },
                                ),
                              ),
                              SizedBox(
                                width: constraints.maxWidth,
                                child: XkTextAreaField(
                                  label: 'Brief',
                                  hintText: '핵심 의사결정 질문을 입력하세요.',
                                  helperText: '질문 중심 입력 권장',
                                  controller: _briefController,
                                  maxLines: 4,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: XkLayout.spacingMd),
                      const Column(
                        children: [
                          XkAlert(
                            title: '분석 완료',
                            message: '핵심 지표와 권장 액션 2건이 생성되었습니다.',
                            variant: XkAlertVariant.success,
                          ),
                          SizedBox(height: XkLayout.spacingXs),
                          XkAlert(
                            title: '모델 업데이트',
                            message: 'v2.2 모델이 2026-03-01부터 순차 적용됩니다.',
                            variant: XkAlertVariant.info,
                          ),
                          SizedBox(height: XkLayout.spacingXs),
                          XkAlert(
                            title: '호출량 주의',
                            message: '월간 API 사용량이 82%에 도달했습니다.',
                            variant: XkAlertVariant.warning,
                          ),
                          SizedBox(height: XkLayout.spacingXs),
                          XkAlert(
                            title: '연결 오류',
                            message: '외부 데이터 소스 인증이 만료되었습니다.',
                            variant: XkAlertVariant.danger,
                          ),
                        ],
                      ),
                      const SizedBox(height: XkLayout.spacingMd),
                      XkTable(
                        columns: const [
                          'Metric',
                          'Current',
                          'Baseline',
                          'Delta',
                          'Action',
                        ],
                        rows: [
                          XkTableRowData(const [
                            XkTableCell(text: 'Primary Score'),
                            XkTableCell(text: '94.2'),
                            XkTableCell(text: '88.7'),
                            XkTableCell(
                              text: '+5.5',
                              textColor: XkColor.success,
                            ),
                            XkTableCell(text: '우선순위 유지'),
                          ]),
                          XkTableRowData(const [
                            XkTableCell(text: 'State Risk'),
                            XkTableCell(text: '21%'),
                            XkTableCell(text: '34%'),
                            XkTableCell(
                              text: '-13%',
                              textColor: XkColor.success,
                            ),
                            XkTableCell(text: '모니터링 간격 확장'),
                          ]),
                          XkTableRowData(const [
                            XkTableCell(text: 'Signal Stability'),
                            XkTableCell(text: '71'),
                            XkTableCell(text: '76'),
                            XkTableCell(text: '-5', textColor: XkColor.warning),
                            XkTableCell(text: '보조 지표 확인'),
                          ]),
                          XkTableRowData(const [
                            XkTableCell(text: 'Data Coverage'),
                            XkTableCell(text: '78%'),
                            XkTableCell(text: '72%'),
                            XkTableCell(
                              text: '+6%',
                              textColor: XkColor.success,
                            ),
                            XkTableCell(text: '입력 범위 유지'),
                          ]),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: XkLayout.spacingMd),
                _Section(
                  sectionId: '06 · Pattern',
                  title: 'Pattern',
                  subtitle:
                      '패턴 섹션은 핵심 신호를 일관된 시각 구조로 정리해, 화면 간 해석 기준을 통일합니다.',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final count = constraints.maxWidth >= 920
                              ? 4
                              : (constraints.maxWidth >= 680 ? 2 : 1);
                          return GridView.count(
                            crossAxisCount: count,
                            crossAxisSpacing: XkLayout.spacingSm,
                            mainAxisSpacing: XkLayout.spacingSm,
                            childAspectRatio: 1.8,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            children: const [
                              XkKpiCard(
                                label: '종합 점수',
                                value: '8.6',
                                suffix: '/10',
                                delta: '전월 대비 +0.4',
                              ),
                              XkKpiCard(
                                label: '신뢰도',
                                value: '92',
                                suffix: '%',
                                delta: '평균 90% 이상 유지',
                              ),
                              XkKpiCard(
                                label: '처리 시간',
                                value: '2.3',
                                suffix: 's',
                                delta: 'SLA 목표 3초',
                              ),
                              XkKpiCard(
                                label: '커버리지',
                                value: '78',
                                suffix: '%',
                                delta: '추가 입력 필요',
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: XkLayout.spacingSm),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final twoColumns = constraints.maxWidth >= 900;
                          if (!twoColumns) {
                            return const Column(
                              children: [
                                _ConfidenceCard(),
                                SizedBox(height: XkLayout.spacingSm),
                                _TimelineCard(),
                              ],
                            );
                          }
                          return const Row(
                            children: [
                              Expanded(child: _ConfidenceCard()),
                              SizedBox(width: XkLayout.spacingSm),
                              Expanded(child: _TimelineCard()),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: XkLayout.spacingSm),
                      const XkMetricTimeline(),
                      const SizedBox(height: XkLayout.spacingSm),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final count = constraints.maxWidth >= 920
                              ? 3
                              : (constraints.maxWidth >= 640 ? 2 : 1);
                          const spacing = XkLayout.spacingSm;
                          final tileWidth = count == 1
                              ? constraints.maxWidth
                              : (constraints.maxWidth -
                                      (spacing * (count - 1))) /
                                  count;

                          return Wrap(
                            spacing: spacing,
                            runSpacing: spacing,
                            children: const [
                              _PatternTile(
                                title: 'Hexagon Radar',
                                child: Center(child: XkHexagonRadar()),
                              ),
                              _PatternTile(
                                title: 'Distribution Heatmap',
                                child: Center(child: XkDistributionHeatmap()),
                              ),
                              _PatternTile(
                                title: 'Priority Funnel',
                                child: XkPriorityFunnel(),
                              ),
                            ]
                                .map((tile) =>
                                    SizedBox(width: tileWidth, child: tile))
                                .toList(),
                          );
                        },
                      ),
                      const SizedBox(height: XkLayout.spacingSm),
                      const XkDomainPatternTabs(),
                    ],
                  ),
                ),
                const SizedBox(height: XkLayout.spacingMd),
                _Section(
                  sectionId: '07 · Motion',
                  title: 'Motion',
                  subtitle:
                      'Weave의 두 축을 기준으로 패턴과 상태의 변화를 모션으로 표현합니다.',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _MotionInterpretationNote(),
                      const SizedBox(height: XkLayout.spacingMd),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final count = constraints.maxWidth >= 1000
                              ? 3
                              : (constraints.maxWidth >= 680 ? 2 : 1);
                          return GridView.count(
                            crossAxisCount: count,
                            crossAxisSpacing: XkLayout.spacingSm,
                            mainAxisSpacing: XkLayout.spacingSm,
                            childAspectRatio: 1.06,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            children: const [
                              _MotionTile(
                                title: 'Status Pulse',
                                code: '2.5s · ease-in-out',
                                child: XkStatusPulse(),
                              ),
                              _MotionTile(
                                title: 'Signal Sweep',
                                code: '2.5s · linear',
                                child: XkSignalSweep(),
                              ),
                              _MotionTile(
                                title: 'Rhythm Line',
                                code: '3.5s · linear',
                                child: XkRhythmLine(),
                              ),
                              _MotionTile(
                                title: 'Focus Ripple',
                                code: '2.2s · ease-out',
                                child: XkFocusRipple(),
                              ),
                              _MotionTile(
                                title: 'Card Settle',
                                code: '2.8s · ease',
                                child: XkCardSettle(),
                              ),
                              _MotionTile(
                                title: 'Alert Pulse',
                                code: '1.9s · ease-in-out',
                                child: XkAlertPulse(),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: XkLayout.spacingMd),
                Center(
                  child: Text(
                    '© 2026 XERKONIX Inc. · Design System v1.3',
                    style: XkTypo.metaMono.copyWith(fontSize: 11),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final eyebrowColor =
        isDark ? XkColor.darkTextSoft : XkColor.identityDeep;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(XkLayout.spacing2xl),
      decoration: BoxDecoration(
        borderRadius: XkShape.xlBorderRadius,
        border: Border.all(
          color: isDark ? XkColor.darkBorderSoft : XkColor.borderSoft,
        ),
        gradient: LinearGradient(
          colors: [
            (isDark ? XkColor.darkIdentityWash : XkColor.identityWash)
                .withValues(alpha: 0.42),
            (isDark ? XkColor.darkActionWash : XkColor.actionWash).withValues(
              alpha: 0.30,
            ),
            Colors.transparent,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 26,
                height: 1,
                color: XkColor.identity,
              ),
              const SizedBox(width: 8),
              Text(
                'DESIGN PHILOSOPHY',
                style: XkTypo.metaMono.copyWith(
                  fontSize: 10,
                  letterSpacing: 2,
                  color: eyebrowColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: XkLayout.spacingSm),
          Text('XERKONIX Weave', style: XkTypo.h1),
          const SizedBox(height: XkLayout.spacingSm),
          Text(
            'Weave는 ‘기술은 인간을 위해 존재합니다’라는 제르코닉스의 정체성을 담아, '
            '복잡한 데이터를 엮어 맥락을 전달하는 디자인 시스템입니다.',
            style: XkTypo.bodyLarge,
          ),
          const SizedBox(height: XkLayout.spacingLg),
          SizedBox(
            width: double.infinity,
            child: Text(
              'Weave의 두 축',
              style: XkTypo.h2.copyWith(fontSize: 22),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: XkLayout.spacingSm),
          LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth >= 520;
              final thread = _AxisMotionCard(
                isDark: isDark,
                title: 'Thread',
                description: '복잡한 데이터에서 발견한 패턴을 표현합니다.',
                motion: const _ThreadAxisMotion(),
              );
              final knot = _AxisMotionCard(
                isDark: isDark,
                title: 'Knot',
                description: '패턴이 모여 드러나는 상태를 표현합니다.',
                motion: const _KnotAxisMotion(),
              );
              if (!wide) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    thread,
                    const SizedBox(height: XkLayout.spacingXs),
                    knot,
                  ],
                );
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: thread),
                  const SizedBox(width: XkLayout.spacingXs),
                  Expanded(child: knot),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _AxisMotionCard extends StatelessWidget {
  const _AxisMotionCard({
    required this.isDark,
    required this.title,
    required this.description,
    required this.motion,
  });

  final bool isDark;
  final String title;
  final String description;
  final Widget motion;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(XkLayout.spacingMd),
      decoration: BoxDecoration(
        borderRadius: XkShape.mdBorderRadius,
        border: Border.all(
          color: isDark ? XkColor.darkBorderSoft : XkColor.borderSoft,
        ),
        color: isDark
            ? XkColor.darkSurface.withValues(alpha: 0.86)
            : XkColor.surface.withValues(alpha: 0.86),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: XkTypo.h3.copyWith(fontSize: 20)),
          const SizedBox(height: XkLayout.spacingXs),
          Container(
            height: 96,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: XkShape.smBorderRadius,
              border: Border.all(
                color: isDark ? XkColor.darkBorderSoft : XkColor.borderSoft,
              ),
              color: isDark
                  ? XkColor.darkSurfaceDeep.withValues(alpha: 0.72)
                  : XkColor.surfaceSoft.withValues(alpha: 0.72),
            ),
            clipBehavior: Clip.antiAlias,
            child: motion,
          ),
          const SizedBox(height: XkLayout.spacingXs),
          Text(description, style: XkTypo.body.copyWith(fontSize: 13)),
        ],
      ),
    );
  }
}

class _ThreadAxisMotion extends StatelessWidget {
  const _ThreadAxisMotion();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final guide = isDark
        ? XkColor.darkTextSoft.withValues(alpha: 0.16)
        : XkColor.textSoft.withValues(alpha: 0.14);

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = math.max(180.0, constraints.maxWidth - 32);
        return Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              left: 26,
              right: 26,
              top: 24,
              child: Container(height: 1, color: guide),
            ),
            Positioned(
              left: 26,
              right: 26,
              bottom: 24,
              child: Container(height: 1, color: guide),
            ),
            Center(
              child: XkRhythmLine(
                width: width,
                height: 54,
                color: isDark ? XkColor.darkIdentity : XkColor.identity,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _KnotAxisMotion extends StatefulWidget {
  const _KnotAxisMotion();

  @override
  State<_KnotAxisMotion> createState() => _KnotAxisMotionState();
}

class _KnotAxisMotionState extends State<_KnotAxisMotion>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return CustomPaint(
          painter: _KnotAxisPainter(
            progress: _controller.value,
            isDark: isDark,
          ),
          child: const SizedBox.expand(),
        );
      },
    );
  }
}

class _KnotAxisPainter extends CustomPainter {
  const _KnotAxisPainter({required this.progress, required this.isDark});

  final double progress;
  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final guidePaint = Paint()
      ..color = isDark
          ? XkColor.darkTextSoft.withValues(alpha: 0.22)
          : XkColor.textSoft.withValues(alpha: 0.22)
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    final starts = <Offset>[
      Offset(size.width * 0.18, size.height * 0.22),
      Offset(size.width * 0.18, size.height * 0.78),
      Offset(size.width * 0.82, size.height * 0.22),
      Offset(size.width * 0.82, size.height * 0.78),
    ];

    for (final start in starts) {
      canvas.drawLine(start, center, guidePaint);
    }

    final accent = isDark ? XkColor.darkAccent : XkColor.accent;
    final identity = isDark ? XkColor.darkIdentity : XkColor.identity;
    final ringProgress = 0.5 - math.cos(progress * math.pi * 2) / 2;

    canvas.drawCircle(
      center,
      14 + (20 * ringProgress),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2
        ..color = accent.withValues(alpha: 0.24 * (1 - ringProgress)),
    );
    canvas.drawCircle(center, 8.5, Paint()..color = accent);

    for (var i = 0; i < starts.length; i++) {
      final t = (progress + (i * 0.25)) % 1.0;
      final dx = starts[i].dx + ((center.dx - starts[i].dx) * t);
      final dy = starts[i].dy + ((center.dy - starts[i].dy) * t);
      canvas.drawCircle(Offset(dx, dy), 3.4, Paint()..color = identity);
    }
  }

  @override
  bool shouldRepaint(covariant _KnotAxisPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.isDark != isDark;
  }
}

class _MotionInterpretationNote extends StatelessWidget {
  const _MotionInterpretationNote();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final border = isDark ? XkColor.darkBorderSoft : XkColor.borderSoft;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(XkLayout.spacingMd),
      decoration: BoxDecoration(
        borderRadius: XkShape.mdBorderRadius,
        border: Border.all(color: border),
        color: isDark ? XkColor.darkSurfaceDeep : XkColor.surfaceSoft,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('해석 단계 (Interpretation Stages)', style: XkTypo.h3),
          const SizedBox(height: XkLayout.spacingXs),
          Text(
            '모션은 데이터 흐름과 상태 변화를 자연스럽게 연결해, '
            '정보 해석 과정을 끊기지 않게 전달합니다.',
            style: XkTypo.body.copyWith(fontSize: 13),
          ),
          const SizedBox(height: XkLayout.spacingSm),
          Text('Observe · 데이터 흐름을 읽는다 · ~180ms', style: XkTypo.body),
          Text('Interpret · 상태 변화를 확인한다 · ~250ms', style: XkTypo.body),
          Text('Connect · 맥락을 완성한다 · ~300ms', style: XkTypo.body),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    this.sectionId,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String? sectionId;
  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final metaColor = isDark ? XkColor.darkTextSoft : XkColor.textSoft;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(XkLayout.spacingMd),
      decoration: BoxDecoration(
        color: isDark ? XkColor.darkSurface : XkColor.surface,
        borderRadius: XkShape.xlBorderRadius,
        border: Border.all(
          color: isDark ? XkColor.darkBorderSoft : XkColor.borderSoft,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (sectionId != null) ...[
            Text(
              sectionId!,
              style: XkTypo.metaMono.copyWith(
                fontSize: 11,
                letterSpacing: 0.06,
                color: metaColor,
              ),
            ),
            const SizedBox(height: XkLayout.spacingXxs),
          ],
          Text(title, style: XkTypo.h3),
          const SizedBox(height: XkLayout.spacingXxs),
          Text(subtitle, style: XkTypo.body.copyWith(fontSize: 13)),
          const SizedBox(height: XkLayout.spacingSm),
          child,
        ],
      ),
    );
  }
}

class _IconGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final count = constraints.maxWidth >= 980
            ? 8
            : (constraints.maxWidth >= 760
                ? 6
                : (constraints.maxWidth >= 520 ? 4 : 3));

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _IconSizePreview(),
            const SizedBox(height: XkLayout.spacingSm),
            GridView.builder(
              itemCount: XkIconName.values.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: count,
                mainAxisSpacing: XkLayout.spacingSm,
                crossAxisSpacing: XkLayout.spacingSm,
                childAspectRatio: 1.2,
              ),
              itemBuilder: (context, index) {
                final name = XkIconName.values[index];
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: XkShape.smBorderRadius,
                    border: Border.all(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? XkColor.darkBorderSoft
                          : XkColor.borderSoft,
                    ),
                  ),
                  padding: const EdgeInsets.all(XkLayout.spacingXs),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      XkIcon(name),
                      const SizedBox(height: XkLayout.spacingXs),
                      Text(
                        name.token,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: XkTypo.metaMono.copyWith(fontSize: 10),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}

class _IconSizePreview extends StatelessWidget {
  const _IconSizePreview();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: XkLayout.spacingMd,
      runSpacing: XkLayout.spacingSm,
      children: const [
        _IconSizeItem(size: XkIconSize.inline, label: '12 · Inline'),
        _IconSizeItem(size: XkIconSize.small, label: '16 · Small'),
        _IconSizeItem(size: XkIconSize.regular, label: '20 · Default'),
        _IconSizeItem(size: XkIconSize.large, label: '24 · Large'),
        _IconSizeItem(size: XkIconSize.display, label: '32 · Display'),
        _IconSizeItem(size: XkIconSize.hero, label: '48 · Hero'),
      ],
    );
  }
}

class _IconSizeItem extends StatelessWidget {
  const _IconSizeItem({required this.size, required this.label});

  final double size;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        XkIcon(XkIconName.chevRight, size: size),
        const SizedBox(width: XkLayout.spacingXs),
        Text(label, style: XkTypo.metaMono.copyWith(fontSize: 11)),
      ],
    );
  }
}

class _PatternTile extends StatelessWidget {
  const _PatternTile({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(XkLayout.spacingMd),
      decoration: BoxDecoration(
        borderRadius: XkShape.mdBorderRadius,
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark
              ? XkColor.darkBorderSoft
              : XkColor.borderSoft,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title, style: XkTypo.label),
          const SizedBox(height: XkLayout.spacingSm),
          child,
        ],
      ),
    );
  }
}

class _ConfidenceCard extends StatelessWidget {
  const _ConfidenceCard();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(XkLayout.spacingMd),
      decoration: BoxDecoration(
        color: isDark ? XkColor.darkSurface : XkColor.surface,
        borderRadius: XkShape.mdBorderRadius,
        border: Border.all(
          color: isDark ? XkColor.darkBorderSoft : XkColor.borderSoft,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Confidence Meter', style: XkTypo.h3.copyWith(fontSize: 18)),
          const SizedBox(height: XkLayout.spacingSm),
          const XkConfidenceMeter(
            label: '역할 적합도 신뢰도',
            value: 0.94,
            valueText: '94%',
            startColor: XkColor.identityDeep,
            endColor: XkColor.identitySoft,
          ),
          const SizedBox(height: XkLayout.spacingSm),
          const XkConfidenceMeter(
            label: '행동 전환 명확도',
            value: 0.91,
            valueText: '91%',
            startColor: XkColor.actionDeep,
            endColor: XkColor.actionSoft,
          ),
          const SizedBox(height: XkLayout.spacingSm),
          const XkConfidenceMeter(
            label: '추천 보조 안정성',
            value: 0.88,
            valueText: '88%',
            startColor: XkColor.supportDeep,
            endColor: XkColor.supportSoft,
          ),
        ],
      ),
    );
  }
}

class _TimelineCard extends StatelessWidget {
  const _TimelineCard();

  @override
  Widget build(BuildContext context) {
    return XkSignalTimeline(
      items: const [
        XkTimelineItem(
          time: '2026-01-14 09:23',
          title: '이탈 위험 급상승',
          description: '참여율 42% 하락, 3주 내 이탈 확률 78%',
          color: XkColor.error,
        ),
        XkTimelineItem(
          time: '2026-01-10 14:07',
          title: '협업 패턴 이상',
          description: '응답 지연 +140%, 피드백 빈도 감소',
          color: XkColor.warning,
        ),
        XkTimelineItem(
          time: '2026-01-05 11:30',
          title: '역량 업데이트',
          description: '경력 점수 +8.2',
          color: XkColor.info,
        ),
        XkTimelineItem(
          time: '2025-12-20 09:00',
          title: '초기 기준선 설정',
          description: 'Baseline 8.6 / 신뢰도 92%',
          color: XkColor.success,
        ),
      ],
    );
  }
}

class _MotionTile extends StatelessWidget {
  const _MotionTile({
    required this.title,
    required this.code,
    required this.child,
  });

  final String title;
  final String code;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(XkLayout.spacingMd),
      decoration: BoxDecoration(
        color: isDark ? XkColor.darkSurface : XkColor.surface,
        borderRadius: XkShape.mdBorderRadius,
        border: Border.all(
          color: isDark ? XkColor.darkBorderSoft : XkColor.borderSoft,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: isDark
                    ? XkColor.darkSurfaceDeep.withValues(alpha: 0.55)
                    : XkColor.surfaceSoft,
                borderRadius: XkShape.smBorderRadius,
              ),
              child: Center(child: child),
            ),
          ),
          const SizedBox(height: XkLayout.spacingSm),
          Text(title, style: XkTypo.label),
          const SizedBox(height: XkLayout.spacingXxs),
          Text(code, style: XkTypo.metaMono.copyWith(fontSize: 10)),
        ],
      ),
    );
  }
}
