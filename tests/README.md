# 🧪 دليل الاختبارات

## نظرة عامة

يتضمن المشروع اختبارات شاملة لجميع الأنظمة الرئيسية.

## الاختبارات المتاحة

| الملف | الأنظمة المختبرة |
|-------|-----------------|
| test_player.gd | صحة، طاقة، مستويات، خبرة، موت، إعادة تشغيل |
| test_inventory.gd | إضافة، حذف، تجميع، امتلاء، نقل، تسلسل |
| test_save_system.gd | حفظ، تحميل، Checksum، تلف، نسخ احتياطي |
| test_quests.gd | إنشاء، بداية، تقدم، اكتمال، فشل، مكافآت |

## تشغيل الاختبارات

### من داخل Godot Editor

```bash
# اذهب إلى Script Editor
# افتح tests/test_runner.gd
# اضغط Run Script
```

### من سطر الأوامر

```bash
godot --headless --script tests/test_runner.gd
```

### تشغيل اختبار واحد

```bash
# في Godot Script Editor
var tests = TestPlayer.new()
tests.run_all_tests()
```

## إضافة اختبارات جديدة

```gdscript
extends Node

class_name TestMySystem

var tests_passed = 0
var tests_failed = 0

func run_all_tests():
    test_my_feature()

func test_my_feature():
    assert_equal(1 + 1, 2, "Math should work")
    print("✅ test_my_feature passed")

func assert_equal(value, expected, message: String):
    if value == expected:
        tests_passed += 1
    else:
        tests_failed += 1
        print("❌ FAIL: %s" % message)
```

## النتائج المتوقعة

```
╔══════════════════════════════════╗
║   Eclipse Frontier Test Runner   ║
╚══════════════════════════════════╝

=== Running Player Tests ===
✅ test_player_initialization passed
✅ test_take_damage passed
✅ test_heal passed
✅ test_energy_system passed
✅ test_experience_gain passed
✅ test_level_up passed
✅ test_player_death passed
✅ test_player_respawn passed

╔══════════════════════════════════╗
║           TEST SUMMARY           ║
╠══════════════════════════════════╣
║ Total Passed:  24                ║
║ Total Failed:  0                 ║
║ Success Rate:  100.0%            ║
╚══════════════════════════════════╝

🎉 ALL TESTS PASSED!
```