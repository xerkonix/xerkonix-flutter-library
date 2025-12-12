import 'dart:ui';

/// Visual Identity System Colors
/// Based on the balance of Logic and Emotion
class XkColor {
  XkColor._();

  // 1. Foundation: The Paper (배경 및 구조)
  /// Canvas - Warm Off-white (#F5F5F5)
  /// [Background (Base)] 차가운 순백색(#FFF)이 아닌, 종이 질감의 미색입니다.
  /// 눈이 편안한 웜톤 오프화이트, 기본 배경색입니다.
  static const Color canvas = Color(0xFFF5F5F5);

  /// Structure - Deep Charcoal (#2D2D2D)
  /// [텍스트/구조] 완전한 블랙(#000)을 지양합니다.
  /// 눈의 피로를 줄이고 세련된 무게감을 주는 차콜입니다.
  /// Heading 텍스트에 사용됩니다 (100% 농도의 먹색).
  static const Color structure = Color(0xFF2D2D2D);

  /// Surface (Card): #FFFFFF
  /// 카드 및 패널 영역. 배경 위에서 깨끗하게 정보가 얹히는 영역입니다.
  static const Color surface = Color(0xFFFFFFFF);

  /// Overlay: #EBEBEB
  /// 모달 백그라운드. 종이를 한 장 더 겹친 듯한 짙은 밀도감입니다.
  static const Color overlay = Color(0xFFEBEBEB);

  /// Divider: #E0E0E0
  /// 구분선. 연필로 흐릿하게 그은 듯한 경계선입니다.
  static const Color divider = Color(0xFFE0E0E0);

  // Dark Theme Specific Colors
  /// Dark Surface (Card): #3A3A3A
  /// 다크테마 카드 배경. Structure보다 약간 밝아 배경과 구분됩니다.
  static const Color darkSurface = Color(0xFF3A3A3A);


  // 2. Typography: The Ink (텍스트 위계)
  /// Text Primary: #2D2D2D
  /// 제목, 강조 텍스트. 100% 농도의 깊은 먹색입니다.
  static const Color textPrimary = Color(0xFF2D2D2D);

  /// Soft Charcoal (#4A4A4A)
  /// Text Secondary: #4A4A4A
  /// [본문 텍스트] 장시간 독서에도 편안한 80% 농도의 먹색입니다.
  /// Body 텍스트에 사용됩니다.
  static const Color bodyText = Color(0xFF4A4A4A);

  /// Text Tertiary: #8C8C8C
  /// 캡션, 부가 정보. 50% 농도. 시선을 방해하지 않는 웜 그레이입니다.
  static const Color textTertiary = Color(0xFF8C8C8C);

  /// Text Disabled: #C4C4C4
  /// 비활성 텍스트. 20% 농도. 잉크가 흐릿해진 상태입니다.
  static const Color textDisabled = Color(0xFFC4C4C4);

  // 3. Identity: The Soul (브랜드 컬러)
  /// Primary (Trust) - Identity - Muted Gold (#C0A062)
  /// [핵심 가치] '데이터의 자산화'와 '고귀한 인간성'을 상징합니다.
  /// 신뢰와 고급스러움을 부여하는 포인트 컬러입니다.
  /// Trust (Gold) - 우리의 데이터를 '자산'으로 격상시키는 고귀한 신뢰의 색입니다.
  static const Color identity = Color(0xFFC0A062);
  
  /// Trust - Alias for Identity (Muted Gold)
  static const Color trust = identity;

  /// Secondary (Pulse) - Human Coral (#FF6B6B)
  /// [강조/알림] 경고조차 생명력이 느껴져야 합니다.
  /// 자극적인 빨강 대신 생동감 있는 코랄 레드를 사용합니다.
  /// Life (Pulse) - 기술이 살아있음을 증명하는 심장 박동의 색입니다.
  static const Color pulse = Color(0xFFFF6B6B);
  
  /// Life - Alias for Pulse (Human Coral)
  static const Color life = pulse;

  /// Secondary Element: Warm Graphite (#6F6B63)
  /// 보조 텍스트, 테두리. 따뜻한 흑연색입니다.
  static const Color warmGraphite = Color(0xFF6F6B63);

  // 4. Semantics: The Nature (기능성 컬러)
  /// Success: #5B8C73
  /// Sage Ink. 말린 세이지 잎 색. 완료 및 성공.
  static const Color success = Color(0xFF5B8C73);

  /// Warning: #E08E45
  /// Burnt Ochre. 황토색. 주의 및 대기.
  static const Color warning = Color(0xFFE08E45);

  /// Error: #FF6B6B
  /// Human Coral. 코랄색. 생명력 있는 에러 표시.
  static const Color error = Color(0xFFFF6B6B);

  /// Info: #526875
  /// Deep Slate. 짙은 청회색. 중립적인 정보 안내.
  static const Color info = Color(0xFF526875);

  // Mapping to generic roles (for backward compatibility and Material Design)
  /// Primary color - Identity (Muted Gold)
  static const Color primary = identity;

  /// Secondary color - Structure (Deep Charcoal)
  static const Color secondary = structure;

  /// Tertiary color - Canvas (Warm Off-white)
  static const Color tertiary = canvas;

  // Legacy color palette (kept for backward compatibility)
  @Deprecated('Use XkColor.canvas instead')
  static const Color pinkLavender = Color(0xFFCDB4DB);
  
  @Deprecated('Use XkColor.canvas instead')
  static const Color lilac = Color(0xFFBE95C4);
  
  @Deprecated('Use XkColor.canvas instead')
  static const Color bilobaFlower = Color(0xFFAE99DE);
  
  @Deprecated('Use XkColor.identity instead')
  static const Color xerkonix = Color(0xFF9C75DB);
  
  @Deprecated('Use XkColor.canvas instead')
  static const Color veryPeri = Color(0xFF6667AB);
  
  @Deprecated('Use XkColor.structure instead')
  static const Color royalPurple = Color(0xFF7851A9);
  
  @Deprecated('Use XkColor.structure instead')
  static const Color deepPurple = Color(0xFF3A243B);
  
  @Deprecated('Use XkColor.pulse instead')
  static const Color tyrianPurple = Color(0xFF66023C);
  
  @Deprecated('Use XkColor.pulse instead')
  static const Color mahoganyRed = Color(0xFF670A0A);
  
  @Deprecated('Use XkColor.pulse instead')
  static const Color carmine = Color(0xFF900020);
  
  @Deprecated('Use XkColor.structure instead')
  static const Color oldLavender = Color(0xFF71697A);
  
  @Deprecated('Use XkColor.structure instead')
  static const Color grey = Color(0xFF939597);
}
