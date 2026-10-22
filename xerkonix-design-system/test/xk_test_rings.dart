// 시험 공용 — XkCheckbox·XkRadio·XkSwitch 포커스 링 찾기.
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// Wrapper chromes whose focus ring is showing. Read from diagnostics, not a
/// key: the ring is a paint property, so showing it never rebuilds (or
/// remounts) the Material control below.
Finder xkFocusRings() => find.byWidgetPredicate(
  (Widget w) =>
      w.runtimeType.toString() == '_XkSnappedChrome' &&
      w.toDiagnosticsNode().getProperties().any(
        (DiagnosticsNode p) => p.name == 'focusRing' && p.value != null,
      ),
);
