# Flutter standard ProGuard rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Prevent shrinking/obfuscation of platform interface classes
-keep class * implements io.flutter.plugin.common.MethodChannel$MethodCallHandler { *; }
