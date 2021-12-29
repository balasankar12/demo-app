# demo

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Google map setup
- GMap Api key => android\app\src\main\AndroidManifest.xml
   <meta-data android:name="com.google.android.geo.API_KEY"
          android:value="YOUR-KEY-HERE"/>
- android/app/build.gradle => minSdkVersion 20
- Access permission
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
- Change Compile SDK version => android\app\src\main\AndroidManifest.xml
    targetSdkVersion 31
    compileSdkVersion 31
