"""Role parsing and generated Dart drift regressions, no sibling checkout needed."""
import copy
import json
import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch
import build_tactile_theme_roles as roles


class ThemeRolesTest(unittest.TestCase):
    def test_variable_rgb_and_transparent(self):
        self.assertEqual(roles._hex(roles._rgba('rgba(var(--rgb),.62)', {'--rgb': '255,255,255'})), '0x9EFFFFFF')
        self.assertEqual(roles._hex(roles._rgba('transparent', {})), '0x00000000')

    def test_panel_preserves_layers_geometry_and_stops(self):
        scope = {'--panel-fill': 'var(--fill),var(--haze)',
                 '--fill': 'linear-gradient(180deg,rgba(255,255,255,.62) 0%,rgba(255,255,255,.92) 62%,rgba(255,255,255,.98) 100%)',
                 '--haze': 'radial-gradient(120% 70% at 10% 0%,rgba(205,214,214,.35) 0%,transparent 70%)'}
        result = roles.extract_panel(scope)
        self.assertEqual(result['linear']['stops'], [0, .62, 1])
        self.assertEqual(result['haze']['radii'], [1.2, .7])
        self.assertEqual(result['haze']['center'], [.1, 0])
        self.assertEqual(result['haze']['stops'], [0, .7])
        self.assertEqual(result['haze']['colors'], ['0x59CDD6D6', '0x00000000'])
        for invalid in ['var(--haze),var(--fill)', 'var(--fill)', 'red']:
            with self.assertRaises(SystemExit): roles.extract_panel({**scope, '--panel-fill': invalid})

    def test_generated_values_are_idempotent_and_detect_mutation(self):
        payload = json.loads(roles.OUT.read_text())
        generated = roles.generated_dart(payload)
        self.assertEqual(roles.normalized_dart(generated), roles.normalized_dart(roles.DART.read_text()))
        changed = copy.deepcopy(payload)
        changed['panel']['dark']['haze']['radii'][0] = .2
        self.assertNotEqual(roles.normalized_dart(roles.generated_dart(changed)), roles.normalized_dart(generated))
        changed = copy.deepcopy(payload)
        changed['tokens']['light']['canvas'] = '0xFF123456'
        self.assertNotEqual(roles.normalized_dart(roles.generated_dart(changed)), roles.normalized_dart(generated))

    def test_missing_gradient_is_an_error(self):
        with tempfile.TemporaryDirectory() as tmp:
            target = Path(tmp)/'tokens.dart'
            target.write_text(roles.DART.read_text().replace('panelHaze: RadialGradient(', 'removedHaze: RadialGradient('))
            with patch.object(roles, 'DART', target), self.assertRaises(SystemExit):
                roles.generated_dart(json.loads(roles.OUT.read_text()))


if __name__ == '__main__': unittest.main()
