# MSM_Client
MSM Client for MSM project

## Install
```text
$ flutter pub add mqtt_client
$ flutter pub add provider
$ flutter pub add flutter_local_notifications
$ flutter pub add shared_preferences
$ flutter pub add webview_flutter
$ flutter pub add intl
```

### Notification Setup
* Android
    * `webview/android/app/src/main/AndroidManifest.xml`
    ```text
    <activity
        android:showWhenLocked="true"
        android:turnScreenOn="true">
    ```
* [WIP] iOS

### Webview Setup
* Android
    * `webview/android/app/build.gradle`
    ```
    android {
        defaultConfig {
            minSdkVersion 20  // fix it
        }
    }
    ```
    * `webview/android/app/src/main/AndroidManifest.xml`
    ```
    <manifest xmlns:android="http://schemas.android.com/apk/res/android"
        package="com.example.webview">
       <application
            android:label="webview"
            android:name="${applicationName}"
            android:icon="@mipmap/ic_launcher"
            android:usesCleartextTraffic="true"> <!-- add it(http support) -->
            <!-- ... SKIPPED ... -->
        </application>
    </manifest>
    ```
* iOS
    * `webview/ios/Runner/Info.plist`
    ```
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>io.flutter.embedded_views_preview</key>  <!-- add it -->
      <string>YES</string>                          <!-- add it -->
      <key>NSAllowsArbitraryLoads</key>             <!-- add it(http support) -->
      <true/>                                       <!-- add it(http support) -->
      <key>NSAllowsArbitraryLoadsInWebContent</key> <!-- add it(http support) -->
      <true/>                                       <!-- add it(http support) -->
      <!-- ... SKIPPED ... -->
    </dict>
    </plist>
    ```


## How to open 1883 port for MQTT testing
```text
$ sudo iptables -I INPUT -p tcp -m tcp --dport 1883 -j ACCEPT
```