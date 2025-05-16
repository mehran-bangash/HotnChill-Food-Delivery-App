# Keep Stripe classes required for Push Provisioning
-keep class com.stripe.** { *; }
-dontwarn com.stripe.**

# React Native Stripe SDK (if used)
-keep class com.reactnativestripesdk.** { *; }
-dontwarn com.reactnativestripesdk.**
