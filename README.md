![banner](/screenshots/banner.jpg)
# IGSaver

An Instagram downloader application made with flutter, which allows you to easily download posts and profile avatars. IGsaver is currently available in two language (english and persian). See more about features in **Screenshots** section.

## Platform
Dart 2.13.4

Flutter 2.2.3

## Dependencies
- [Intl](https://pub.dev/packages/intl): localization
- [http](https://pub.dev/packages/http): send HTTP requests
- [Dio](https://pub.dev/packages/dio): save files from instagram server
- [HiveDB](https://pub.dev/packages/hive): store settings and user preferences
- [provider](https://pub.dev/packages/provider): state management
- [photo_view](https://pub.dev/packages/photo_view): view images in history
- [permission_handler](https://pub.dev/packages/permission_handler): check and ask permissions
- [awesome_notifications](https://pub.dev/packages/awesome_notifications): send notifications to user

## Download
[![banner](/screenshots/download.png)](https://apkpure.com/p/com.mark.igsaver)

## Build
1. Make sure you have installed and configured flutter and Android SDKs.
2. Connect an Android device or run Emulator.
3. Clone the project:

```shell
git clone https://github.com/MRezaKarimi/igsaver.git
cd igsaver
```

4. Get dependencies:
```shell
flutter pub get
```
5. Build project:
```shell
flutter run
```


## Known Issues
`User-Agent` parameter in request headers set to `Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:79.0)` to prevent redirecting to login page.
However, after multiple try to download profile, Instagram redirects requests to login page and download profile not working any more.

Due to Android limitations on reading clipboard contents when app is running in the background, clipboard monitor and auto-download only works on Android 9 and below.

## Screenshots
![screenshot 1](/screenshots/p1.jpg)
![screenshot 2](/screenshots/p2.jpg)
![screenshot 3](/screenshots/p3.jpg)
![screenshot 4](/screenshots/p4.jpg)
![screenshot 5](/screenshots/p5.jpg)
![screenshot 6](/screenshots/p6.jpg)