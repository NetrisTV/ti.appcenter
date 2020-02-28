# Visual Studio App Center SDK for Axway Titanium
App Center is your continuous integration, delivery and learning solution for iOS and Android apps. Get faster release cycles, higher-quality apps, and the insights to build what users want.

## App Center Crashes Module
App Center Crashes will automatically generate a crash log every time your app crashes. The log is first written to the device's storage and when the user starts the app again, the crash report will be sent to App Center. Collecting crashes works for both beta and live apps, i.e. those submitted to the App Store. Crash logs contain valuable information for you to help fix the crash.

## App Center Analytics Module
App Center Analytics helps you understand user behavior and customer engagement to improve your app. The SDK automatically captures session count, device properties like model, OS version, etc. You can define your own custom events to measure things that matter to you. All the information captured is available in the App Center portal for you to analyze the data.

## Requirements
- Titanium Mobile SDK 9.0.0.GA or later

## Building

Update SDK version and its location in `ios/titanium.xcconfig` if you need.

Run from platform directory ([Appcelerator CLI](https://github.com/appcelerator/appc-install)):
>`appc run -p [android|ios] --build-only`

or ([Titanium CLI](https://github.com/appcelerator/titanium)):
>`ti build -p [android|ios] --build-only`

## Install

To use your module locally inside an app you can copy the zip file into the app root folder and compile your app.
The file will automatically be extracted and copied into the correct `modules/` folder.

## Project Usage

Add the module as a dependency to your application by editing `tiapp.xml`.
Example:

    <modules>
      <module>ru.netris.mobile.appcenter</module>
    </modules>

When you run your project, the compiler will combine module along with its dependencies
and assets into the application.

### Start modules on application create

To start `Crashes` module on application start edit your `tiapp.xml` and add property to `ti:app` tag:

    <property name="ti.appcenter.crashes.start-on-create">true</property>

To start `Analytics` module on application start edit your `tiapp.xml` and add property to `ti:app` tag:

    <property name="ti.appcenter.analytics.start-on-create">true</property>

You must also define `"ti.appcenter.secret.{PLATFORM}"` property to be able to run `Crashes` and/or `Analytics` modules on application create:

    <property name="ti.appcenter.secret.android">{YOUR_APP_SECRET}</property>
    <property name="ti.appcenter.secret.ios">{YOUR_APP_SECRET}</property>

### Manual modules start

If you need to not start modules on application create you can start them manually later with:
```js
const AppCenter = require('ru.netris.mobile.appcenter');
const {Crashes, Analytics} = AppCenter;
const secret = "YOUR_APP_SECRET"

//  you can't call `start` more then once
AppCenter.start(secret, Crashes, Analytics);

//  when you defined "secret" in properties
//AppCenter.start(Crashes, Analytics);

//  when you need only one service
//AppCenter.start(secret, Crashes);
//  or
//AppCenter.start(secret, Analytics);
//  or
//AppCenter.start(Analytics);

```

## Example Usage

```js
const AppCenter = require('ru.netris.mobile.appcenter');
const {Analytics} = AppCenter;
const secret = "YOUR_APP_SECRET"

AppCenter.start(secret, Analytics);

Analytics.trackEvent('Video clicked', { Category: 'Music', FileName: 'favorite.avi' }, function(result) {
    console.log(JSON.stringify(result));
  });
```
