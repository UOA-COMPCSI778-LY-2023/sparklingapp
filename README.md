# sparklingapp

SParklingAPP is an internship program at UoA. It is an app that helps users control their sugar intake.

## Environment Setup:

Refer to the official configuration to install the Flutter environment: Flutter Installation Guide
Project Initialization:

## Clone the project to your local machine:
```
git clone git@github.com:UOA-COMPCSI778-LY-2023/sparklingapp.git
```
## Initialize the project:
```
cd sparklingapp
flutter create .
```
## Configure APP Permissions:

### iOS:
In the path ./sparklingapp/ios/Runner, add the following value to the "dict" key in the Info.plist file:
```
<key>NSCameraUsageDescription</key>
<string>Use camera to scanning Barcode</string>
```
![IOS camera permission ](./files/ios_camera_permission.png)

### Android:
In the path ./sparklingapp/android/app/src/main, add the following value to the "manifest" key in the AndroidManifest.xml file:
```
<uses-permission android:name="android.permission.CAMERA" />
```
![Android camera permission ](./files/android_camera_permission.png)
In the path ./sparklingapp/android/app, modify the "flutter.minSdkVersion" in "build.gradle" file under defaultConfig to 21
![Android minisdkversion ](./files/android_minisdkversion.png)

## Start the Emulator:

![VS Code select ](./files/vscode_choose_platform.png)

## Project Launch:
```
flutter run
```