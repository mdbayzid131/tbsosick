# Flutter standard ProGuard rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Prevent shrinking/obfuscation of platform interface classes
-keep class * implements io.flutter.plugin.common.MethodChannel$MethodCallHandler { *; }

# Ignore missing Google Play Core classes (referred to by Flutter's deferred components, which we do not use)
-dontwarn com.google.android.play.core.**

