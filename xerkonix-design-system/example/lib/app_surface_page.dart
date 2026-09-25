import 'package:flutter/material.dart';
import 'package:xerkonix_design_system/xerkonix_design_system.dart';

/// Product screen 6-B first-impression spots for review captures.
///
/// `#/app-surface?spot=login|empty|dashboard|complete&theme=light|dark`.
/// The page builds its own [XkTactileTheme] so the legacy example theme does
/// not leak in.
class AppSurfacePage extends StatefulWidget {
  const AppSurfacePage({super.key, required this.spot, required this.dark});

  final String spot;
  final bool dark;

  static AppSurfacePage fromUri(Uri uri) {
    // Hash routes keep their query inside the fragment.
    final String frag = uri.fragment;
    final int q = frag.indexOf('?');
    final Map<String, String> p = q < 0
        ? uri.queryParameters
        : Uri.splitQueryString(frag.substring(q + 1));
    return AppSurfacePage(
      spot: p['spot'] ?? 'login',
      dark: p['theme'] == 'dark',
    );
  }

  @override
  State<AppSurfacePage> createState() => _AppSurfacePageState();
}

class _AppSurfacePageState extends State<AppSurfacePage> {
  int _tab = 0;
  int _nav = 0;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = XkTactileTheme.themeData(
      widget.dark ? Brightness.dark : Brightness.light,
    );
    return Theme(
      data: theme,
      child: Builder(
        builder: (BuildContext context) {
          final bool wide = MediaQuery.sizeOf(context).width >= 900;
          final Widget body = XkTactileRouteFade(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: wide ? 40 : 16,
                vertical: wide ? 40 : 20,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 960),
                  child: _spot(context),
                ),
              ),
            ),
          );
          return Scaffold(
            backgroundColor: theme.scaffoldBackgroundColor,
            body: wide
                ? Row(
                    children: <Widget>[
                      NavigationRail(
                        selectedIndex: _nav,
                        onDestinationSelected: (int i) =>
                            setState(() => _nav = i),
                        labelType: NavigationRailLabelType.all,
                        destinations: const <NavigationRailDestination>[
                          NavigationRailDestination(
                            icon: Icon(Icons.home_outlined),
                            label: Text('홈'),
                          ),
                          NavigationRailDestination(
                            icon: Icon(Icons.folder_outlined),
                            label: Text('프로젝트'),
                          ),
                          NavigationRailDestination(
                            icon: Icon(Icons.settings_outlined),
                            label: Text('설정'),
                          ),
                        ],
                      ),
                      VerticalDivider(width: 1, color: theme.dividerColor),
                      Expanded(child: body),
                    ],
                  )
                : body,
            bottomNavigationBar: wide
                ? null
                : NavigationBar(
                    selectedIndex: _nav,
                    onDestinationSelected: (int i) => setState(() => _nav = i),
                    destinations: const <Widget>[
                      NavigationDestination(
                        icon: Icon(Icons.home_outlined),
                        label: '홈',
                      ),
                      NavigationDestination(
                        icon: Icon(Icons.folder_outlined),
                        label: '프로젝트',
                      ),
                      NavigationDestination(
                        icon: Icon(Icons.settings_outlined),
                        label: '설정',
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }

  // A block-width ink plane, like the web `.app-intro`.
  Widget _wide({required Widget child, bool completion = false}) => SizedBox(
        width: double.infinity,
        child: XkTactileAppIntro(completion: completion, child: child),
      );

  Widget _spot(BuildContext context) {
    switch (widget.spot) {
      case 'empty':
        return _empty(context);
      case 'dashboard':
        return _dashboard(context);
      case 'complete':
        return _complete(context);
      default:
        return _login(context);
    }
  }

  TextStyle _title(BuildContext context) => XkTactileType.display(
        color: XkTactileAppSurface.of(context).onAppIntro,
      );

  Widget _label(BuildContext context, String text) {
    final XkTactileAppSurface s = XkTactileAppSurface.of(context);
    return Text(
      text,
      style: XkTactileType.label(color: s.onAppIntroAccent),
    );
  }

  Widget _body(BuildContext context, String text) {
    final XkTactileAppSurface s = XkTactileAppSurface.of(context);
    return Text(text, style: XkTactileType.body(color: s.appIntroBody));
  }

  Widget _login(BuildContext context) {
    final XkTactileTokens t = XkTactileTokens.of(Theme.of(context).brightness);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        XkTactileAppIntro(
          child: Builder(
            builder: (BuildContext context) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _label(context, '로그인'),
                const SizedBox(height: 12),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.end,
                  children: <Widget>[
                    Text('환영합니다 ', style: _title(context)),
                    XkTactileBrandWord('XERKONIX', style: _title(context)),
                  ],
                ),
                const SizedBox(height: 12),
                _body(context, '계정으로 계속합니다.'),
                const SizedBox(height: 24),
                Wrap(
                  spacing: 16,
                  runSpacing: 12,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: <Widget>[
                    XkTactilePrimaryButton(
                      onPressed: () {},
                      child: const Text('계속'),
                    ),
                    XkTactileButton(
                      kind: XkTactileButtonKind.quiet,
                      onPressed: () {},
                      child: const Text('다른 방법'),
                    ),
                    TextButton(onPressed: () {}, child: const Text('도움말')),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        XkTactileSurface(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('이메일', style: XkTactileType.label(color: t.muted)),
              const SizedBox(height: 8),
              const TextField(
                decoration: InputDecoration(hintText: 'name@example.com'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _empty(BuildContext context) {
    return _wide(
      child: Builder(
        builder: (BuildContext context) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _label(context, '프로젝트'),
            const SizedBox(height: 12),
            Text('아직 프로젝트가 없습니다', style: _title(context)),
            const SizedBox(height: 12),
            _body(context, '첫 프로젝트를 만들면 여기에 표시됩니다.'),
            const SizedBox(height: 24),
            XkTactilePrimaryButton(
              onPressed: () {},
              child: const Text('새 프로젝트'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dashboard(BuildContext context) {
    final XkTactileTokens t = XkTactileTokens.of(Theme.of(context).brightness);
    final XkTactileAppSurface s = XkTactileAppSurface.of(context);
    Widget metric(String name, String value, String unit) => Expanded(
          child: XkTactileSurface(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(name, style: XkTactileType.label(color: t.muted)),
                const SizedBox(height: 6),
                Text.rich(
                  TextSpan(
                    children: <InlineSpan>[
                      TextSpan(
                        text: value,
                        style: XkTactileType.display(color: s.keyMetric),
                      ),
                      TextSpan(
                        text: ' $unit',
                        style: XkTactileType.body(color: t.muted),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        XkTactileAppIntro(
          child: Builder(
            builder: (BuildContext context) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _label(context, '대시보드'),
                const SizedBox(height: 12),
                Text('이번 주 현황', style: _title(context)),
                const SizedBox(height: 12),
                _body(context, '확인이 필요한 항목부터 보여줍니다.'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        DefaultTabController(
          length: 3,
          initialIndex: _tab,
          child: TabBar(
            onTap: (int i) => setState(() => _tab = i),
            tabs: <Widget>[
              Tab(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Text('전체'),
                    const SizedBox(width: 6),
                    Text(
                      '현재',
                      style: XkTactileType.label(color: s.selectedCue),
                    ),
                  ],
                ),
              ),
              const Tab(text: '확인 필요'),
              const Tab(text: '완료'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: <Widget>[
            metric('처리', '128', '건'),
            const SizedBox(width: 12),
            metric('확인 필요', '3', '건'),
          ],
        ),
        const SizedBox(height: 16),
        XkTactileHumanReview(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '확인 필요 · 금액 차이',
                style: XkTactileType.label(color: s.humanReviewLabel),
              ),
              const SizedBox(height: 6),
              Text(
                '인보이스 합계와 입력값이 다릅니다.',
                style: XkTactileType.body(color: t.ink),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _complete(BuildContext context) {
    return _wide(
      completion: true,
      child: Builder(
        builder: (BuildContext context) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _label(context, '결제 완료'),
            const SizedBox(height: 12),
            Text('결제가 완료되었습니다', style: _title(context)),
            const SizedBox(height: 12),
            _body(context, '영수증은 등록한 이메일로 보냈습니다.'),
            const SizedBox(height: 24),
            XkTactilePrimaryButton(
              onPressed: () {},
              child: const Text('영수증 보기'),
            ),
          ],
        ),
      ),
    );
  }
}
