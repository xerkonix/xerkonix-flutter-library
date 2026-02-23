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
      title: 'XERKONIX Weave DS Example',
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
  String _selectedDomain = 'Input Layer';

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
        title: Text('XERKONIX Weave Design System', style: XkTypo.h3),
        actions: [
          Row(
            children: [
              Text('Light', style: XkTypo.label),
              Switch(
                value: widget.isDark,
                onChanged: widget.onThemeChanged,
              ),
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
                  title: 'Iconography',
                  subtitle:
                      'HTML reference icon set 48개를 XkIcon으로 전부 구현. 기본 20px, stroke 1.6.',
                  child: _IconGrid(),
                ),
                const SizedBox(height: XkLayout.spacingMd),
                _Section(
                  title: 'Components',
                  subtitle:
                      'Button / Chip / Card / Form / Alert / Table 전부 위젯으로 공개.',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: XkLayout.spacingSm,
                        runSpacing: XkLayout.spacingSm,
                        children: [
                          XkButton.primary(
                              onPressed: () {}, child: const Text('Primary')),
                          XkButton.brand(
                              onPressed: () {}, child: const Text('Brand')),
                          XkButton.accent(
                              onPressed: () {}, child: const Text('Accent')),
                          XkButton.tonal(
                              onPressed: () {}, child: const Text('Tonal')),
                          XkButton.outline(
                              onPressed: () {}, child: const Text('Outline')),
                        ],
                      ),
                      const SizedBox(height: XkLayout.spacingMd),
                      Wrap(
                        spacing: XkLayout.spacingSm,
                        runSpacing: XkLayout.spacingSm,
                        children: const [
                          XkChip(
                              label: 'default', variant: XkChipVariant.neutral),
                          XkChip(
                              label: 'trusted', variant: XkChipVariant.brand),
                          XkChip(
                              label: 'attention',
                              variant: XkChipVariant.accent),
                          XkChip(
                              label: 'urgent', variant: XkChipVariant.signal),
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
                                        value: 'Input Layer',
                                        label: 'Input Layer'),
                                    XkSelectOption(
                                        value: 'Pattern Layer',
                                        label: 'Pattern Layer'),
                                    XkSelectOption(
                                        value: 'State Layer',
                                        label: 'State Layer'),
                                    XkSelectOption(
                                        value: 'Action Layer',
                                        label: 'Action Layer'),
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
                          'Action'
                        ],
                        rows: [
                          XkTableRowData(const [
                            XkTableCell(text: 'Primary Score'),
                            XkTableCell(text: '94.2'),
                            XkTableCell(text: '88.7'),
                            XkTableCell(
                                text: '+5.5', textColor: XkColor.success),
                            XkTableCell(text: '우선순위 유지'),
                          ]),
                          XkTableRowData(const [
                            XkTableCell(text: 'State Risk'),
                            XkTableCell(text: '21%'),
                            XkTableCell(text: '34%'),
                            XkTableCell(
                                text: '-13%', textColor: XkColor.success),
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
                                text: '+6%', textColor: XkColor.success),
                            XkTableCell(text: '입력 범위 유지'),
                          ]),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: XkLayout.spacingMd),
                _Section(
                  title: 'Pattern',
                  subtitle:
                      'KPI / Confidence Meter / Timeline / Monitor / Hexagon Radar / Cluster Matrix / Flow Compression / Domain Tabs 전부 구현.',
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
                                  delta: '전월 대비 +0.4'),
                              XkKpiCard(
                                  label: '신뢰도',
                                  value: '92',
                                  suffix: '%',
                                  delta: '평균 90% 이상 유지'),
                              XkKpiCard(
                                  label: '처리 시간',
                                  value: '2.3',
                                  suffix: 's',
                                  delta: 'SLA 목표 3초'),
                              XkKpiCard(
                                  label: '커버리지',
                                  value: '78',
                                  suffix: '%',
                                  delta: '추가 입력 필요'),
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
                      const XkSignalOverviewMonitor(),
                      const SizedBox(height: XkLayout.spacingSm),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final count = constraints.maxWidth >= 920
                              ? 3
                              : (constraints.maxWidth >= 640 ? 2 : 1);
                          return GridView.count(
                            crossAxisCount: count,
                            crossAxisSpacing: XkLayout.spacingSm,
                            mainAxisSpacing: XkLayout.spacingSm,
                            childAspectRatio: 1.2,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            children: const [
                              _PatternTile(
                                title: 'Hexagon Radar',
                                child: Center(child: XkHexagonRadar()),
                              ),
                              _PatternTile(
                                title: 'Cluster Matrix',
                                child: Center(child: XkClusterMatrix()),
                              ),
                              _PatternTile(
                                title: 'Flow Compression',
                                child: XkFlowCompression(),
                              ),
                            ],
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
                  title: 'Motion',
                  subtitle:
                      'Status Breath / Signal Sweep / Wave Drift / Focus Ripple / Card Settle / Alert Beat + 기존 breathingLight/pulse API 포함.',
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final count = constraints.maxWidth >= 1000
                          ? 4
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
                            title: 'Status Breath',
                            code: '2.6s · ease-in-out',
                            child: XkStatusBreath(),
                          ),
                          _MotionTile(
                            title: 'Signal Sweep',
                            code: '2.6s · linear',
                            child: XkSignalSweep(),
                          ),
                          _MotionTile(
                            title: 'Wave Drift',
                            code: '3.8s · linear',
                            child: XkWaveDrift(),
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
                            title: 'Alert Beat',
                            code: '1.9s · ease-in-out',
                            child: XkAlertBeat(),
                          ),
                          _MotionTile(
                            title: 'Legacy breathingLight',
                            code: 'wrapper API',
                            child: _LegacyBreathingLight(),
                          ),
                          _MotionTile(
                            title: 'Legacy pulse',
                            code: 'wrapper API',
                            child: _LegacyPulse(),
                          ),
                        ],
                      );
                    },
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
            (isDark ? XkColor.darkActionWash : XkColor.actionWash)
                .withValues(alpha: 0.30),
            Colors.transparent,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('WEAVE', style: XkTypo.metaMono),
          const SizedBox(height: XkLayout.spacingXs),
          Text('Thread the pattern, tie the state.', style: XkTypo.h1),
          const SizedBox(height: XkLayout.spacingSm),
          Text(
            '디자인 시스템 HTML 기준 아이콘/컴포넌트/패턴/모션을 전부 공개 위젯으로 구현한 예시 화면입니다.',
            style: XkTypo.bodyLarge,
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
          Text(title, style: XkTypo.h3),
          const SizedBox(height: XkLayout.spacingXxs),
          Text(subtitle, style: XkTypo.body.copyWith(fontSize: 12)),
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
        XkIcon(
          XkIconName.chevRight,
          size: size,
        ),
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
        children: [
          Text(title, style: XkTypo.label),
          const SizedBox(height: XkLayout.spacingSm),
          Expanded(child: child),
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
            startColor: XkColor.identity,
            endColor: XkColor.identitySoft,
          ),
          const SizedBox(height: XkLayout.spacingSm),
          const XkConfidenceMeter(
            label: '이탈 위험 신뢰도',
            value: 0.78,
            valueText: '78%',
            startColor: XkColor.error,
            endColor: XkColor.actionSoft,
          ),
          const SizedBox(height: XkLayout.spacingSm),
          const XkConfidenceMeter(
            label: '데이터 완성도',
            value: 0.78,
            valueText: '78%',
            startColor: XkColor.info,
            endColor: XkColor.actionSoft,
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

class _LegacyBreathingLight extends StatelessWidget {
  const _LegacyBreathingLight();

  @override
  Widget build(BuildContext context) {
    return XkMotion.breathingLight(
      child: Container(
        width: 16,
        height: 16,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: XkColor.identity,
        ),
      ),
    );
  }
}

class _LegacyPulse extends StatelessWidget {
  const _LegacyPulse();

  @override
  Widget build(BuildContext context) {
    return XkMotion.pulse(
      child: const XkIcon(XkIconName.bell, size: 22),
    );
  }
}
