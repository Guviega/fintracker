<div align="center">

<img src="assets/logo/fintracker_logo.png" alt="FinTracker" width="180" />

# FinTracker

### A clear, personal view of your money.

Track income and expenses, organize spending, and review your monthly balance in one Flutter app.

<p>
  <img src="https://img.shields.io/badge/Flutter-mobile-02569B?logo=flutter&logoColor=white" alt="Flutter app" />
  <img src="https://img.shields.io/badge/Storage-local%20SQLite-003B57?logo=sqlite&logoColor=white" alt="Local SQLite storage" />
  <img src="https://img.shields.io/badge/Status-personal%20project-6C63FF" alt="Personal project" />
</p>

</div>

---

## ✨ About

FinTracker began as a college assignment in a mobile development course, created to learn Flutter and Dart. It has grown into a practical personal finance tracker that you can use for your own day-to-day records.

The app keeps its data in a local SQLite database on your device. It does not require an account or a remote service, so your records stay on that device.

## 🧭 What you can do

- **Review a monthly dashboard** with income, expenses, net result, and a month selector.
- **See spending breakdowns** by category and payment method.
- **Record and manage income**, including its source, description, date, and amount.
- **Record and manage expenses**, including category, payment method, date, and amount.
- **Create and edit categories** to match your own spending. The app starts with Transport, Food, Essentials, Investments, and Schooling.
- **Keep your records locally** with SQLite storage.

Amounts are displayed in Brazilian real (R$), and dates use a day/month/year format.

## 🛠️ Built with

- [Flutter](https://flutter.dev/) and [Dart](https://dart.dev/)
- [SQLite](https://www.sqlite.org/) through `sqflite`
- [`fl_chart`](https://pub.dev/packages/fl_chart) for dashboard charts
- [`intl`](https://pub.dev/packages/intl) for date formatting

## 🚀 Run locally

### Requirements

- Flutter SDK compatible with the Dart constraint in [`pubspec.yaml`](pubspec.yaml)
- An Android or iOS device/simulator and its platform toolchain

### Steps

```bash
git clone https://github.com/Guviega/fintracker.git
cd fintracker
flutter pub get
flutter run
```

Choose a connected device or simulator when prompted. The project includes Android and iOS platform folders. Its current SQLite dependency (`sqflite`) is intended for those native platforms; web and desktop support are not configured.

## 🗂️ Project layout

```text
lib/
├── database/   # SQLite access and monthly dashboard data
├── model/      # Income, expense, category, and payment method models
└── view/       # Dashboard, lists, forms, and reusable widgets
assets/         # App logo and icons
```

## 💬 Suggestions and contributions

Constructive suggestions are welcome. If you spot a bug, have an idea, or want to improve the app, please open an [issue](https://github.com/Guviega/fintracker/issues) with clear steps or context. For code changes, open a pull request and explain what the change improves.

## 📚 Project context

This is an educational project maintained for personal use and shared for anyone who finds it useful. It is a simple record-keeping tool, not a financial advisory service. Back up your device if you need to preserve your local records; the app currently has no cloud sync or built-in export feature.

---

<div align="center">

Made with Flutter as part of a learning journey. 💙

</div>
