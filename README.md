# 📱 Your BMI - Flutter App

A simple and user-friendly **BMI (Body Mass Index) Calculator** built with **Flutter**.  
The app helps users calculate their BMI, understand the BMI categories, and get health suggestions.

---

## 🚀 Features
- 🔢 **Calculate BMI** based on height & weight
- 📊 **View BMI Categories** (Underweight, Normal, Overweight, Obesity, Severe Obesity)
- 👩‍⚕️ **BMI Nurse** – Get health suggestions based on your BMI
- 🎨 **Light & Dark Theme Toggle**
- 🌐 **Multi-language Support** (English & Hindi)
- 📝 **Drawer Navigation** with options:
  - BMI Calculator  
  - BMI Range Chart  
  - BMI Nurse  
  - Settings  
  - About Us  

---

## 🛠️ Built With
- [Flutter](https://flutter.dev/) - Cross-platform UI toolkit  
- [Provider](https://pub.dev/packages/provider) - State Management  
- [Shared Preferences](https://pub.dev/packages/shared_preferences) - Local storage  

---

## 📂 Project Structure
lib/
├── main.dart # Entry point
├── home_screen.dart # Home screen with Drawer
├── bmi_calculator.dart # BMI Calculator screen
├── bmi_range.dart # BMI Ranges screen
├── bmi_nurse.dart # BMI Nurse screen
├── settings.dart # Settings (Theme + Language)
└── about_us.dart # About the app

---

## ▶️ Getting Started

### Prerequisites
- Install [Flutter SDK](https://flutter.dev/docs/get-started/install)
- Set up an emulator / device or run on web

### Installation
```bash
# Clone the repo
git clone https://github.com/shashika8088/bmi_calculator.git

# Move into the project
cd bmi_calculator

# Get dependencies
flutter pub get

# Run on emulator / device
flutter run

