# hospital app


1. Установите Flutter

Убедитесь, что у вас установлен Flutter SDK (рекомендуется версия **3.19+**):


flutter --version

Если Flutter не установлен:
➡ https://docs.flutter.dev/get-started/install

git clone https://github.com/bushhiro/test.git
cd test

flutter pub get

Убедитесь, что в pubspec.yaml подключён JSON-файл:
flutter:
  uses-material-design: true
  assets:
    - assets/menu.json
