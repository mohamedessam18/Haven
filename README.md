# Haven — Flutter mobile app

A mobile home-security interface built with Flutter for Android and iOS. All devices, profile information and control actions are simulated. There is no hardware or emergency monitoring backend.

## Run

From this folder, run `flutter pub get`, then `flutter run` with an Android emulator, iOS simulator or connected phone. iOS device distribution requires your Apple signing configuration. `flutter build apk` creates an Android package when an Android SDK is configured. `flutter build ios --simulator --debug` creates a simulator build.

## Clean architecture

- `lib/features/security/domain`: immutable models, repository contract and pure security use cases. No Flutter or storage dependencies.
- `lib/features/security/data`: SharedPreferences implementation of the repository contract, with corrupt-state fallback.
- `lib/features/security/application`: observable controller coordinating use cases and serialized persistence.
- `lib/features/security/presentation`: app shell, screen widgets, reusable components and device details.
- `lib/core/theme`: shared visual theme.
- `lib/main.dart`: dependency composition and application startup.

Inject a different `SecurityRepository` to connect backend data later. The current action use cases are explicit demo simulations and must be replaced with real asynchronous hardware commands before production use.

## Flows

Home → Dashboard preview with four circular device battery gauges → tap anywhere in the section to open the full Dashboard with gauges for every device.


Home → Stay / Away / confirmed Disarm. Devices → room filter → bottom-sheet detail → lock/unlock or sensor test/clear. System Log → all events or test alerts → clear test alerts. Settings → in-app confirmation preference and app information. Android back returns to Home from another tab. Scroll positions persist across tab changes. Haptics, tap feedback, animated mode changes, screen transitions and modal sheets are native Flutter interactions; screen transitions honor reduced-motion settings.

## Branding

Original scalable logo and house illustration, Android launcher icons, iOS app icons and Flutter web icons. DM Sans is bundled for offline use; its SIL Open Font License is included in `assets/brand/FONT-LICENSE.txt`.

## Verification

`flutter analyze`

`flutter test`

Tests cover independent safety-alert clearing, local persistence round trips and the mobile navigation → disarm confirmation → device-control flow at 390 × 844.

The iOS project targets iOS 15 or later to match the installed Xcode toolchain. 

Verified locally: `flutter analyze` passed, all 3 tests passed, Android debug APK built, and the application ran on the iPhone 17 simulator. The final APK includes legacy, adaptive and themed launcher icon resources. The iOS launcher icon was verified on the simulator home screen.
