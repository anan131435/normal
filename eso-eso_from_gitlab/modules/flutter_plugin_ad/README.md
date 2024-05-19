# flutter_plugin_ad

A new Flutter plugin.

## Getting Started

This project is a starting point for a Flutter
[plug-in package](https://flutter.dev/developing-packages/),
a specialized package that includes platform-specific implementation code for
Android and/or iOS.

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.



//com.sskj.flutter_plugin_ad 为包名

mvn deploy:deploy-file -Dfile=xxx.aar -Durl="file://." -DgroupId="com.sskj.flutter_plugin_ad" -DartifactId="xxx" -Dversion="1.0.1" -X

比如：
mvn deploy:deploy-file -Dfile=GDTSDK.unionNormal.4.333.1203.aar -Durl="file://." -DgroupId="com.sskj.flutter_plugin_ad" -DartifactId="GDTSDK.unionNormal.4.333.1203" -Dversion="1.0.1" -X




mvn deploy:deploy-file -Dfile=windAd-3.0.1.aar -Durl="file://." -DgroupId="com.sskj.flutter_plugin_ad" -DartifactId="windAd-3.0.1" -Dversion="1.0.1" -X
