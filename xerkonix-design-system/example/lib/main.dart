import 'package:flutter/material.dart';
import 'package:xerkonix_design_system/xerkonix_design_system.dart';

void main() {
  runApp(const TACTILEExampleApp());
}

class TACTILEExampleApp extends StatefulWidget {
  const TACTILEExampleApp({super.key});

  @override
  State<TACTILEExampleApp> createState() => TACTILEExampleAppState();
}

class TACTILEExampleAppState extends State<TACTILEExampleApp> {
  bool _isDark = false;

  @override
  void initState() {
    super.initState();
    if (Uri.base.fragment.contains('dark')) {
      _isDark = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'XERKONIX Design System',
      theme: XkLightTheme.themeData,
      darkTheme: XkDarkTheme.themeData,
      themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (BuildContext _) => ComponentMatrixPage(
          isDark: _isDark,
          onThemeChanged: (bool value) => setState(() => _isDark = value),
        ),
        '/dark': (BuildContext _) => ComponentMatrixPage(
          isDark: true,
          onThemeChanged: (bool value) => setState(() => _isDark = value),
        ),
        '/states': (BuildContext _) => StatesPage(
          isDark: _isDark,
          onThemeChanged: (bool value) => setState(() => _isDark = value),
        ),
        '/states-toast': (BuildContext _) => StatesPage(
          isDark: _isDark,
          onThemeChanged: (bool value) => setState(() => _isDark = value),
          auto: StatesAuto.toast,
        ),
        '/states-dialog': (BuildContext _) => StatesPage(
          isDark: _isDark,
          onThemeChanged: (bool value) => setState(() => _isDark = value),
          auto: StatesAuto.dialog,
        ),
        '/states-loading': (BuildContext _) => StatesPage(
          isDark: _isDark,
          onThemeChanged: (bool value) => setState(() => _isDark = value),
          auto: StatesAuto.loading,
        ),
      },
    );
  }
}

class ComponentMatrixPage extends StatefulWidget {
  const ComponentMatrixPage({
    super.key,
    required this.isDark,
    required this.onThemeChanged,
  });

  final bool isDark;
  final ValueChanged<bool> onThemeChanged;

  @override
  State<ComponentMatrixPage> createState() => ComponentMatrixPageState();
}

class ComponentMatrixPageState extends State<ComponentMatrixPage> {
  final TextEditingController _search = TextEditingController(text: '검색어를 입력하세요');
  int _nav = 0;
  int _tab = 0;
  bool _on = true;
  String _domain = '수집';

  @override
  void initState() {
    super.initState();
    if (widget.isDark) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }
        if (Theme.of(context).brightness != Brightness.dark) {
          widget.onThemeChanged(true);
        }
      });
    }
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: XkGround(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints c) {
            final bool compact = c.maxWidth < 720;
            return CustomScrollView(
              slivers: <Widget>[
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                    compact ? 16 : 28,
                    24,
                    compact ? 16 : 28,
                    40,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1180),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            _Header(
                              isDark: widget.isDark,
                              onThemeChanged: widget.onThemeChanged,
                            ),
                            const SizedBox(height: 28),
                            if (compact)
                              _MobileColumn(
                                nav: _nav,
                                tab: _tab,
                                on: _on,
                                search: _search,
                                domain: _domain,
                                onNav: (int i) => setState(() => _nav = i),
                                onTab: (int i) => setState(() => _tab = i),
                                onToggle: (bool v) => setState(() => _on = v),
                                onDomain: (String v) =>
                                    setState(() => _domain = v),
                                onDialog: () => XkDialog.show(
                                  context,
                                  title: '변화를 시작할 준비가 되셨나요?',
                                  body: '지금, 더 명확한 가능성을 경험하세요.',
                                  primaryLabel: '시작하기',
                                  secondaryLabel: '취소',
                                ),
                              )
                            else
                              _DesktopGrid(
                                nav: _nav,
                                tab: _tab,
                                on: _on,
                                search: _search,
                                domain: _domain,
                                onNav: (int i) => setState(() => _nav = i),
                                onTab: (int i) => setState(() => _tab = i),
                                onToggle: (bool v) => setState(() => _on = v),
                                onDomain: (String v) =>
                                    setState(() => _domain = v),
                                onDialog: () => XkDialog.show(
                                  context,
                                  title: '변화를 시작할 준비가 되셨나요?',
                                  body: '지금, 더 명확한 가능성을 경험하세요.',
                                  primaryLabel: '시작하기',
                                  secondaryLabel: '취소',
                                ),
                              ),
                            const SizedBox(height: 32),
                            Center(
                              child: Text(
                                'XERKONIX Design System · TACTILE',
                                style: XkTypo.metaMono.copyWith(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.isDark, required this.onThemeChanged});
  final bool isDark;
  final ValueChanged<bool> onThemeChanged;

  @override
  Widget build(BuildContext context) {
    final Brightness b = Theme.of(context).brightness;
    return Row(
      children: <Widget>[
        Text(
          'XERKONIX',
          style: XkTypo.h3.copyWith(letterSpacing: 1.4, color: XkColor.inkOf(b)),
        ),
        const Spacer(),
        Flexible(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pushNamed('/states'),
                  child: Text('다른 상태', style: XkTypo.label),
                ),
                const SizedBox(width: 8),
                Text('라이트', style: XkTypo.label),
                Switch(value: isDark, onChanged: onThemeChanged),
                Text('다크', style: XkTypo.label),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

const List<XkNavDestination> _destinations = <XkNavDestination>[
  XkNavDestination(label: 'Home', icon: XkIconName.home),
  XkNavDestination(label: 'Projects', icon: XkIconName.briefcase),
  XkNavDestination(label: 'Library', icon: XkIconName.chartBar),
  XkNavDestination(label: 'Team', icon: XkIconName.users),
  XkNavDestination(label: 'Settings', icon: XkIconName.settings),
];

class _DesktopGrid extends StatelessWidget {
  const _DesktopGrid({
    required this.nav,
    required this.tab,
    required this.on,
    required this.search,
    required this.domain,
    required this.onNav,
    required this.onTab,
    required this.onToggle,
    required this.onDomain,
    required this.onDialog,
  });

  final int nav;
  final int tab;
  final bool on;
  final TextEditingController search;
  final String domain;
  final ValueChanged<int> onNav;
  final ValueChanged<int> onTab;
  final ValueChanged<bool> onToggle;
  final ValueChanged<String> onDomain;
  final VoidCallback onDialog;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        XkNavRail(
          destinations: _destinations,
          selectedIndex: nav,
          onSelect: onNav,
        ),
        const SizedBox(width: 20),
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              XkTextInputField(
                label: '검색',
                hintText: '검색어를 입력하세요',
                controller: search,
              ),
              const SizedBox(height: 20),
              Text('더 명확한 가능성을 만듭니다.', style: XkTypo.h2),
              const SizedBox(height: 6),
              Text(
                '기술은 인간을 위해 존재합니다.',
                style: XkTypo.body.copyWith(
                  color: XkColor.ink2Of(Theme.of(context).brightness),
                ),
              ),
              const SizedBox(height: 16),
              const Row(
                children: <Widget>[
                  Expanded(
                    child: XkInfoCard(
                      metric: '입력',
                      title: '다음 행동',
                      description: '쓰임을 설명하는 제목과 읽기 쉬운 본문을 연결합니다.',
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: XkInfoCard(
                      metric: '결과',
                      title: '판단',
                      description: '핵심 수치와 다음 행동을 같은 위계로 보여 줍니다.',
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: XkInfoCard(
                      metric: '기록',
                      title: '상태',
                      description: '현재와 직전 상태의 차이를 한 줄로 읽게 합니다.',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              XkListRow(
                label: '문서 정리',
                subtitle: '3시간 전 · 업데이트됨',
                icon: XkIconName.mail,
                onTap: () {},
              ),
              const SizedBox(height: 10),
              XkListRow(
                label: '일정 조율',
                subtitle: '어제 · 5개의 메모',
                icon: XkIconName.calendar,
                onTap: () {},
              ),
              const SizedBox(height: 16),
              const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: XkTable(
                      columns: <String>['항목', '현재', '기준'],
                      rows: <XkTableRowData>[
                        XkTableRowData(<XkTableCell>[
                          XkTableCell(text: '점수'),
                          XkTableCell(text: '94.2'),
                          XkTableCell(text: '88.7'),
                        ]),
                        XkTableRowData(<XkTableCell>[
                          XkTableCell(text: '커버리지'),
                          XkTableCell(text: '78%'),
                          XkTableCell(text: '72%'),
                        ]),
                      ],
                    ),
                  ),
                  SizedBox(width: 16),
                  XkHexagonRadar(size: 140),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 20),
        SizedBox(
          width: 260,
          child: _Controls(
            tab: tab,
            on: on,
            domain: domain,
            onTab: onTab,
            onToggle: onToggle,
            onDomain: onDomain,
            onDialog: onDialog,
          ),
        ),
      ],
    );
  }
}

class _MobileColumn extends StatelessWidget {
  const _MobileColumn({
    required this.nav,
    required this.tab,
    required this.on,
    required this.search,
    required this.domain,
    required this.onNav,
    required this.onTab,
    required this.onToggle,
    required this.onDomain,
    required this.onDialog,
  });

  final int nav;
  final int tab;
  final bool on;
  final TextEditingController search;
  final String domain;
  final ValueChanged<int> onNav;
  final ValueChanged<int> onTab;
  final ValueChanged<bool> onToggle;
  final ValueChanged<String> onDomain;
  final VoidCallback onDialog;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('더 명확한 가능성을 만듭니다.', style: XkTypo.h2),
        const SizedBox(height: 12),
        XkButton.primary(
          onPressed: onDialog,
          child: const Text('시작하기'),
        ),
        const SizedBox(height: 16),
        XkNavRail(
          destinations: _destinations,
          selectedIndex: nav,
          onSelect: onNav,
          width: double.infinity,
        ),
        const SizedBox(height: 16),
        _Controls(
          tab: tab,
          on: on,
          domain: domain,
          onTab: onTab,
          onToggle: onToggle,
          onDomain: onDomain,
          onDialog: onDialog,
        ),
        const SizedBox(height: 16),
        const XkKpiCard(label: '처리', value: '1,248', suffix: '', delta: '+12%'),
        const SizedBox(height: 10),
        XkListRow(
          label: '문서 정리',
          subtitle: '보조 텍스트가 들어갑니다.',
          icon: XkIconName.mail,
          onTap: () {},
        ),
        const SizedBox(height: 16),
        const XkHexagonRadar(size: 120),
      ],
    );
  }
}

class _Controls extends StatelessWidget {
  const _Controls({
    required this.tab,
    required this.on,
    required this.domain,
    required this.onTab,
    required this.onToggle,
    required this.onDomain,
    required this.onDialog,
  });

  final int tab;
  final bool on;
  final String domain;
  final ValueChanged<int> onTab;
  final ValueChanged<bool> onToggle;
  final ValueChanged<String> onDomain;
  final VoidCallback onDialog;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        XkButton.primary(onPressed: onDialog, child: const Text('Primary')),
        const SizedBox(height: 8),
        XkButton.support(onPressed: () {}, child: const Text('Secondary')),
        const SizedBox(height: 8),
        XkButton.support(onPressed: null, child: const Text('Disabled')),
        const SizedBox(height: 8),
        XkButton.success(onPressed: () {}, child: const Text('Success')),
        const SizedBox(height: 8),
        XkButton.warning(onPressed: () {}, child: const Text('Warning')),
        const SizedBox(height: 8),
        XkButton.error(onPressed: () {}, child: const Text('Error')),
        const SizedBox(height: 8),
        XkButton.info(onPressed: () {}, child: const Text('Info')),
        const SizedBox(height: 12),
        XkSelectField<String>(
          label: '영역',
          value: domain,
          options: const <XkSelectOption<String>>[
            XkSelectOption<String>(value: '수집', label: '수집'),
            XkSelectOption<String>(value: '분석', label: '분석'),
            XkSelectOption<String>(value: '실행', label: '실행'),
          ],
          onChanged: (String? v) {
            if (v != null) {
              onDomain(v);
            }
          },
        ),
        const SizedBox(height: 8),
        Row(
          children: <Widget>[
            Switch(value: on, onChanged: onToggle),
            const SizedBox(width: 8),
            Checkbox(value: on, onChanged: (bool? v) => onToggle(v ?? false)),
            const Text('선택'),
          ],
        ),
        const SizedBox(height: 8),
        XkTabs(
          labels: const <String>['Tab 1', 'Tab 2', 'Tab 3'],
          index: tab,
          onSelect: onTab,
        ),
        const SizedBox(height: 12),
        XkDialog(
          title: '변화를 시작할 준비가 되셨나요?',
          body: '지금, 더 명확한 가능성을 경험하세요.',
          onPrimary: () {},
          onSecondary: () {},
        ),
        const SizedBox(height: 12),
        const XkAlert(
          title: '연결 오류',
          message: '외부 데이터 소스 인증이 만료되었습니다.',
          variant: XkAlertVariant.danger,
        ),
        const SizedBox(height: 12),
        XkTag(label: '태그', onTap: () {}),
        const SizedBox(height: 12),
        const XkKpiCard(
          label: '처리',
          value: '1,248',
          delta: '+12%',
        ),
      ],
    );
  }
}

enum StatesAuto { none, toast, dialog, loading }

/// Existing widgets that do not fit the 1440 matrix viewport.
class StatesPage extends StatefulWidget {
  const StatesPage({
    super.key,
    required this.isDark,
    required this.onThemeChanged,
    this.auto = StatesAuto.none,
  });

  final bool isDark;
  final ValueChanged<bool> onThemeChanged;
  final StatesAuto auto;

  @override
  State<StatesPage> createState() => StatesPageState();
}

class StatesPageState extends State<StatesPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      if (widget.auto == StatesAuto.toast) {
        showXkToast(context, '저장했습니다.');
      } else if (widget.auto == StatesAuto.dialog) {
        XkDialog.show(
          context,
          title: '변화를 시작할 준비가 되셨나요?',
          body:
              '지금, 더 명확한 가능성을 경험하세요. 이 확인은 현재 화면의 선택을 적용합니다. 나중에 하기를 누르면 아무 것도 바뀌지 않습니다.',
          primaryLabel: '시작하기',
          secondaryLabel: '나중에 하기',
        );
      }
    });
  }

  void _goMatrix() {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).pushReplacementNamed('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: <Widget>[
          XkGround(
            child: CustomScrollView(
              slivers: <Widget>[
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(28, 24, 28, 48),
                  sliver: SliverToBoxAdapter(
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1180),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                XkBackButton(
                                  label: '목록으로',
                                  onPressed: _goMatrix,
                                ),
                                const Spacer(),
                                Text('라이트', style: XkTypo.label),
                                Switch(
                                  value: widget.isDark,
                                  onChanged: widget.onThemeChanged,
                                ),
                                Text('다크', style: XkTypo.label),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Text('다른 상태', style: XkTypo.h3),
                            const SizedBox(height: 16),
                            const XkTextInputField(
                              label: '이메일',
                              hintText: 'name@example.com',
                            ),
                            const SizedBox(height: 12),
                            const XkTextInputField(
                              label: '비밀번호',
                            ),
                            const SizedBox(height: 12),
                            const XkTextAreaField(
                              label: '메모',
                              hintText: '내용을 입력하세요',
                            ),
                            const SizedBox(height: 16),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: <Widget>[
                                XkButton.success(
                                  onPressed: () {},
                                  child: const Text('Success'),
                                ),
                                XkButton.warning(
                                  onPressed: () {},
                                  child: const Text('Warning'),
                                ),
                                XkButton.error(
                                  onPressed: () {},
                                  child: const Text('Error'),
                                ),
                                XkButton.info(
                                  onPressed: () {},
                                  child: const Text('Info'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            const XkSkeletonCard(),
                            const SizedBox(height: 12),
                            const SizedBox(
                              height: 200,
                              child: XkSkeletonList(count: 2),
                            ),
                            const SizedBox(height: 16),
                            const SizedBox(
                              height: 88,
                              child: XkEmptyPane(message: '표시할 항목이 없습니다.'),
                            ),
                            const SizedBox(height: 8),
                            XkErrorPane(
                              message: '요청을 완료하지 못했습니다.',
                              onRetry: () {},
                            ),
                            const SizedBox(height: 16),
                            const XkConfidenceMeter(
                              label: '확신',
                              value: 0.72,
                            ),
                            const SizedBox(height: 16),
                            const XkDistributionHeatmap(cellSize: 18),
                            const SizedBox(height: 16),
                            const XkPriorityFunnel(),
                            const SizedBox(height: 16),
                            const SizedBox(
                              height: 72,
                              child: XkLoadingPane(),
                            ),
                            const SizedBox(height: 16),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: <Widget>[
                                XkButton.support(
                                  onPressed: () =>
                                      showXkToast(context, '저장했습니다.'),
                                  child: const Text('알림'),
                                ),
                                XkButton.primary(
                                  onPressed: () => XkDialog.show(
                                    context,
                                    title: '변화를 시작할 준비가 되셨나요?',
                                    body: '지금, 더 명확한 가능성을 경험하세요.',
                                    primaryLabel: '시작하기',
                                    secondaryLabel: '취소',
                                  ),
                                  child: const Text('대화상자'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (widget.auto == StatesAuto.loading)
            const XkLoadingOverlay(
              message: '불러오는 중',
              visible: true,
            ),
        ],
      ),
    );
  }
}
