import 'package:flutter/material.dart';
import 'package:xerkonix_design_system/xerkonix_design_system.dart';

import 'theme_notifier.dart';

void main() {
  runApp(ThemeNotifier(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: ThemeNotifier.of(context)!.theme,
      builder: (BuildContext context, ThemeData themeData, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Xerkonix Design System Test App',
          theme: themeData,
          home: const MyHomePage(title: 'Xerkonix Design System'),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(XkLayout.spacingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(XkLayout.spacingMedium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Color Palette - Warm Intelligence',
                      style: XkTypo.title2,
                    ),
                    const SizedBox(height: XkLayout.spacingMedium),
                    Text(
                      '차가운 디지털 화면이 아닌, 따뜻한 미색 종이 위에 깊은 먹색 잉크로 쓴 기록 같은 느낌을 구현합니다. '
                      '원색의 RGB를 쓰지 않고, 종이 위에 스며든 잉크의 깊이로 위계를 나눕니다.',
                      style: XkTypo.body,
                    ),
                    const SizedBox(height: XkLayout.spacingMedium),
                    Wrap(
                      spacing: XkLayout.spacingSmall,
                      runSpacing: XkLayout.spacingSmall,
                children: [
                        // Foundation
                        _buildColorSwatch('Canvas', XkColor.canvas, 'Background (Base)'),
                        _buildColorSwatch('Surface', XkColor.surface, 'Card / Panel'),
                        _buildColorSwatch('Overlay', XkColor.overlay, 'Modal Overlay'),
                        _buildColorSwatch('Divider', XkColor.divider, 'Soft Divider'),

                        // Typography
                        _buildColorSwatch('Text Primary', XkColor.textPrimary, 'Title / Emphasis'),
                        _buildColorSwatch('Text Secondary', XkColor.bodyText, 'Body'),
                        _buildColorSwatch('Text Tertiary', XkColor.textTertiary, 'Caption / Meta'),
                        _buildColorSwatch('Text Disabled', XkColor.textDisabled, 'Disabled'),

                        // Identity
                        _buildColorSwatch('Primary (Trust)', XkColor.identity, 'Muted Gold'),
                        _buildColorSwatch('Secondary (Pulse)', XkColor.pulse, 'Human Coral'),

                        // Secondary Element
                        _buildColorSwatch('Warm Graphite', XkColor.warmGraphite, 'Secondary Element'),

                        // Semantics
                        _buildColorSwatch('Success', XkColor.success, 'Sage Ink'),
                        _buildColorSwatch('Warning', XkColor.warning, 'Burnt Ochre'),
                        _buildColorSwatch('Error', XkColor.error, 'Human Coral'),
                        _buildColorSwatch('Info', XkColor.info, 'Deep Slate'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: XkLayout.spacingLarge),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(XkLayout.spacingMedium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Buttons - XkButton Component',
                      style: XkTypo.title2,
                    ),
                    const SizedBox(height: XkLayout.spacingMedium),
                    Text(
                      'Primary: Muted Gold 배경 + Deep Charcoal 텍스트 (다크테마: Canvas 텍스트)\n'
                      'Outlined: 투명 배경 + Identity 테두리 + Identity 텍스트\n'
                      'Hover/Pressed/Disabled 상태에서 잉크의 농담 변화를 확인할 수 있습니다.',
                      style: XkTypo.body,
                    ),
                    const SizedBox(height: XkLayout.spacingLarge),
                    Wrap(
                      spacing: XkLayout.spacingMedium,
                      runSpacing: XkLayout.spacingMedium,
                      children: [
                        XkButton.primary(
                          onPressed: () {},
                          child: const Text('Primary Button'),
                        ),
                        XkButton.outlined(
                          onPressed: () {},
                          child: const Text('Outlined Button'),
                        ),
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
                        XkButton.primary(
                          onPressed: null,
                          child: const Text('Disabled'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(XkLayout.spacingMedium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Typography',
                      style: XkTypo.title2,
                    ),
                    const SizedBox(height: XkLayout.spacingMedium),
                    Text(
                      "Xerkonix Inc. (주식회사 제르코닉스) Thin",
                      style: IBMPlexSans.thin(fontSize: 16),
                    ),
                    const SizedBox(height: XkLayout.spacingSmall),
                    Text(
                      "Xerkonix Inc. (주식회사 제르코닉스) ExtraLight",
                      style: IBMPlexSans.extraLight(fontSize: 16),
                    ),
                    const SizedBox(height: XkLayout.spacingSmall),
                    Text(
                      "Xerkonix Inc. (주식회사 제르코닉스) Light",
                      style: IBMPlexSans.light(fontSize: 16),
                    ),
                    const SizedBox(height: XkLayout.spacingSmall),
                    Text(
                      "Xerkonix Inc. (주식회사 제르코닉스) Regular",
                      style: IBMPlexSans.regular(fontSize: 16),
                    ),
                    const SizedBox(height: XkLayout.spacingSmall),
                    Text(
                      "Xerkonix Inc. (주식회사 제르코닉스) Medium",
                      style: IBMPlexSans.medium(fontSize: 16),
                    ),
                    const SizedBox(height: XkLayout.spacingSmall),
                    Text(
                      "Xerkonix Inc. (주식회사 제르코닉스) SemiBold",
                      style: IBMPlexSans.semiBold(fontSize: 16),
                    ),
                    const SizedBox(height: XkLayout.spacingSmall),
                    Text(
                      "Xerkonix Inc. (주식회사 제르코닉스) Bold",
                      style: IBMPlexSans.bold(fontSize: 16),
                    ),
                    const SizedBox(height: XkLayout.spacingSmall),
                    Text(
                      "Xerkonix Inc. (주식회사 제르코닉스) ExtraBold",
                      style: IBMPlexSans.extraBold(fontSize: 16),
                    ),
                    const SizedBox(height: XkLayout.spacingSmall),
            Text(
                      "Xerkonix Inc. (주식회사 제르코닉스) Black",
                      style: IBMPlexSans.black(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: XkLayout.spacingMedium),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(XkLayout.spacingMedium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'XkTypo - Main Typography System',
                      style: XkTypo.title2,
                    ),
                    const SizedBox(height: XkLayout.spacingMedium),
                    Text("Large Title", style: XkTypo.largeTitle),
                    const SizedBox(height: XkLayout.spacingSmall),
                    Text("Title 1", style: XkTypo.title1),
                    const SizedBox(height: XkLayout.spacingSmall),
                    Text("Title 2", style: XkTypo.title2),
                    const SizedBox(height: XkLayout.spacingSmall),
                    Text("Title 3", style: XkTypo.title3),
                    const SizedBox(height: XkLayout.spacingSmall),
                    Text("Headline", style: XkTypo.headline),
                    const SizedBox(height: XkLayout.spacingSmall),
            Text(
                      "Body - 장시간 독서에도 편안한 80% 농도의 먹색입니다. "
                      "Xerkonix Inc. (주식회사 제르코닉스)의 인간적임과 기계적임의 조화, 자간 -0.01em~-0.02em의 단단한 인상, "
                      "행간 150% 이상의 여유로운 호흡을 경험할 수 있습니다.",
                      style: XkTypo.body,
                    ),
                    const SizedBox(height: XkLayout.spacingSmall),
                    Text("Callout", style: XkTypo.callout),
                    const SizedBox(height: XkLayout.spacingSmall),
                    Text("Subhead", style: XkTypo.subhead),
                    const SizedBox(height: XkLayout.spacingSmall),
                    Text("Footnote", style: XkTypo.footnote),
                    const SizedBox(height: XkLayout.spacingSmall),
                    Text("Caption 1", style: XkTypo.caption1),
                    const SizedBox(height: XkLayout.spacingSmall),
                    Text("Caption 2", style: XkTypo.caption2),
                  ],
                ),
              ),
            ),
            const SizedBox(height: XkLayout.spacingLarge),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(XkLayout.spacingMedium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Shape & Layout - Sophisticated Round',
                      style: XkTypo.title2,
                    ),
                    const SizedBox(height: XkLayout.spacingMedium),
                    Text(
                      'Corner Radius: R8 ~ R12',
                      style: XkTypo.body,
                    ),
                    const SizedBox(height: XkLayout.spacingSmall),
                    Wrap(
                      spacing: XkLayout.spacingSmall,
                      runSpacing: XkLayout.spacingSmall,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: XkColor.identity.withOpacity(0.2),
                            borderRadius: XkShape.smallBorderRadius,
                            border: Border.all(
                              color: XkColor.identity,
                              width: 1,
                            ),
                          ),
                          child: Center(
                            child: Text('R8', style: XkTypo.caption1),
                          ),
                        ),
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: XkColor.identity.withOpacity(0.2),
                            borderRadius: XkShape.defaultBorderRadius,
                            border: Border.all(
                              color: XkColor.identity,
                              width: 1,
                            ),
                          ),
                          child: Center(
                            child: Text('R10', style: XkTypo.caption1),
                          ),
                        ),
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: XkColor.identity.withOpacity(0.2),
                            borderRadius: XkShape.largeBorderRadius,
                            border: Border.all(
                              color: XkColor.identity,
                              width: 1,
                            ),
                          ),
                          child: Center(
                            child: Text('R12', style: XkTypo.caption1),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: XkLayout.spacingMedium),
            Text(
                      '"여백이 곧 콘텐츠" - 시집을 읽는 듯한 넉넉한 행간과 자간',
                      style: XkTypo.body,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: XkLayout.spacingLarge),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(XkLayout.spacingMedium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Motion - The Pulse (호흡)',
                      style: XkTypo.title2,
                    ),
                    const SizedBox(height: XkLayout.spacingMedium),
            Text(
                      'Breathing Light: Identity와 Pulse가 섞이며 생명체처럼 명멸',
                      style: XkTypo.body,
                    ),
                    const SizedBox(height: XkLayout.spacingLarge),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        XkMotion.breathingLight(
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: XkColor.identity,
                              borderRadius: XkShape.defaultBorderRadius,
                            ),
                          ),
                        ),
                        XkMotion.pulse(
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: XkColor.pulse,
                              borderRadius: XkShape.defaultBorderRadius,
                            ),
                          ),
                        ),
                        XkMotion.pulse(
                          primaryColor: XkColor.identity,
                          secondaryColor: XkColor.pulse,
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: XkColor.identity,
                              borderRadius: XkShape.defaultBorderRadius,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: XkLayout.spacingLarge),
            Card(
              color: XkColor.canvas.withOpacity(0.5),
              child: Padding(
                padding: const EdgeInsets.all(XkLayout.spacingMedium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.palette_outlined, color: XkColor.identity),
                        const SizedBox(width: XkLayout.spacingSmall),
                        Text(
                          'Theme Test',
                          style: XkTypo.title3,
                        ),
                      ],
                    ),
                    const SizedBox(height: XkLayout.spacingMedium),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                        ElevatedButton.icon(
                    onPressed: () {
                      ThemeNotifier.of(context)!.setLightMode();
                    },
                          icon: const Icon(Icons.light_mode),
                          label: const Text("Light Theme"),
                        ),
                        const SizedBox(width: XkLayout.spacingMedium),
                        ElevatedButton.icon(
                    onPressed: () {
                      ThemeNotifier.of(context)!.setDarkMode();
                    },
                          icon: const Icon(Icons.dark_mode),
                          label: const Text("Dark Theme"),
                        ),
                      ],
                    ),
                    const SizedBox(height: XkLayout.spacingMedium),
                    _buildInstructionItem('Light/Dark 테마를 전환하여 색상과 타이포그래피를 확인합니다'),
                    _buildInstructionItem('각 색상 스와치를 확인하여 디자인 시스템을 테스트합니다'),
                    _buildInstructionItem('타이포그래피의 인간적임과 기계적임의 조화를 경험해보세요'),
                    _buildInstructionItem('자간 -0.01em~-0.02em의 단단한 인상과 행간 150%의 여유로운 호흡을 확인하세요'),
                    _buildInstructionItem('Primary 버튼(Muted Gold 배경)과 Outlined 버튼(투명 배경 + Identity 테두리)을 비교해보세요'),
                    _buildInstructionItem('Breathing Light 애니메이션을 확인하세요'),
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
      padding: const EdgeInsets.only(bottom: XkLayout.spacingExtraSmall),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('• ', style: XkTypo.body),
          Expanded(child: Text(text, style: XkTypo.body)),
        ],
      ),
    );
  }

  Widget _buildColorSwatch(String name, Color color, [String? description]) {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;
        final textColor = isDark ? XkColor.canvas : XkColor.textPrimary;
        final descriptionColor = isDark ? XkColor.canvas : XkColor.bodyText;
        final borderColor = isDark 
            ? XkColor.canvas.withOpacity(0.2) 
            : XkColor.structure.withOpacity(0.2);
        
        return Column(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: color,
                borderRadius: XkShape.smallBorderRadius,
                border: Border.all(
                  color: borderColor,
                  width: 1,
                ),
              ),
            ),
            const SizedBox(height: XkLayout.spacingExtraSmall),
            SizedBox(
              width: 70,
              child: Column(
                children: [
                  Text(
                    name,
                    style: XkTypo.caption1.copyWith(
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (description != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      description,
                      style: XkTypo.caption2.copyWith(
                        color: descriptionColor,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
