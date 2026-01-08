# Razorpay SDK Rules
-keep class com.razorpay.** { *; }
-dontwarn com.razorpay.**

# General Flutter Rules (Good practice to include)
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Google Play Core (Fix for missing SplitCompat/Deferred Components)
-dontwarn com.google.android.play.core.**
