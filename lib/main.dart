import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = ThemeData.light();
  Locale _locale = Locale('en');

  ThemeProvider() {
    _loadFromPrefs();
  }

  ThemeData getTheme() => _themeData;
  Locale getLocale() => _locale;

  void toggleTheme() {
    _themeData = _themeData == ThemeData.light() ? ThemeData.dark() : ThemeData.light();
    _saveToPrefs();
    notifyListeners();
  }

  void changeLanguage(Locale locale) {
    _locale = locale;
    _saveToPrefs();
    notifyListeners();
  }

  Future<void> _initPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkMode = prefs.getBool('isDarkMode') ?? false;
    final languageCode = prefs.getString('languageCode') ?? 'en';
    _themeData = isDarkMode ? ThemeData.dark() : ThemeData.light();
    _locale = Locale(languageCode);
  }

  Future<void> _loadFromPrefs() async {
    await _initPrefs();
    notifyListeners();
  }

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', _themeData == ThemeData.dark());
    prefs.setString('languageCode', _locale.languageCode);
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Your BMI',
            theme: themeProvider.getTheme(),
            locale: themeProvider.getLocale(),
            home: HomeScreen(),
          );
        },
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.getTheme() == ThemeData.dark();

    return Scaffold(
      appBar: AppBar(
        title: Text('Your BMI'),
        backgroundColor: Colors.blueGrey,
        actions: [
          IconButton(
            icon: Icon(Icons.alarm),
            onPressed: () {
              showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
              ).then((selectedDate) {
                if (selectedDate != null) {
                  showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  ).then((selectedTime) {
                    if (selectedTime != null) {
                      // Set reminder logic here
                    }
                  });
                }
              });
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blueGrey,
              ),
              child: Center(
                child: Text(
                  'BMI Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.bar_chart),
              title: Text('BMI Range'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BMIRangeScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.local_hospital_outlined),
              title: Text('BMI Nurse'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BMINurseScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('About Us'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AboutUsScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to Your BMI App!',
              style: TextStyle(
                fontSize: 24,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'A free tool to know your body',
              style: TextStyle(
                fontSize: 16,
                color: isDarkMode ? Colors.white70 : Colors.black54,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BMICalculatorScreen(),
                  ),
                );
              },
              child: Text('Calculate BMI'),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              title: Text('Theme'),
              trailing: Switch(
                value: Provider.of<ThemeProvider>(context).getTheme() == ThemeData.dark(),
                onChanged: (value) {
                  Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
                },
              ),
            ),
            ListTile(
              title: Text('App Language'),
              trailing: DropdownButton<Locale>(
                value: Provider.of<ThemeProvider>(context).getLocale(),
                onChanged: (Locale? newValue) {
                  if (newValue != null) {
                    Provider.of<ThemeProvider>(context, listen: false).changeLanguage(newValue);
                  }
                },
                items: <Locale>[
                  Locale('en'),
                  Locale('hi'),
                ].map<DropdownMenuItem<Locale>>((Locale locale) {
                  return DropdownMenuItem<Locale>(
                    value: locale,
                    child: Text(locale.languageCode == 'en' ? 'English' : 'Hindi'),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BMICalculatorScreen extends StatefulWidget {
  @override
  _BMICalculatorScreenState createState() => _BMICalculatorScreenState();
}

class _BMICalculatorScreenState extends State<BMICalculatorScreen> {
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  double _bmi = 0;

  void _calculateBMI() {
    final height = double.tryParse(_heightController.text);
    final weight = double.tryParse(_weightController.text);

    if (height != null && weight != null) {
      setState(() {
        _bmi = weight / (height * height);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculate your BMI'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _heightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Height (m)',
              ),
            ),
            TextField(
              controller: _weightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Weight (kg)',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calculateBMI,
              child: Text('Calculate'),
            ),
            SizedBox(height: 20),
            Text(
              _bmi == 0 ? '' : 'Your BMI is ${_bmi.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}

class BMIRangeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BMI Range'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/th.jpeg',
              width: MediaQuery.of(context).size.width * 0.8,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20),
            Text(
              'BMI Categories:',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              'Underweight: BMI < 18.5',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              'Normal weight: BMI 18.5–24.9',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              'Overweight: BMI 25–29.9',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              'Obesity: BMI 30–34.9',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              'Severe Obesity: BMI 35 or greater',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class BMINurseScreen extends StatelessWidget {
  final List<double> bmiValues = [17.0, 21.0, 27.0, 32.0, 37.0];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BMI Nurse'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello, I\'m Your BMI Nurse. I\'m here to assist you and suggest you some valuable information based on your BMI. \nPlease select your calculated BMI:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Column(
              children: bmiValues.map((bmi) {
                String range;
                if (bmi < 18.5) {
                  range = '< 18.5';
                } else if (bmi < 25) {
                  range = '18.5–24.9';
                } else if (bmi < 30) {
                  range = '25–29.9';
                } else if (bmi < 35) {
                  range = '30–34.9';
                } else {
                  range = '35 or greater';
                }

                return ElevatedButton(
                  onPressed: () {
                    _showBMIDetails(context, bmi);
                  },
                  child: Text('BMI: $range'),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  void _showBMIDetails(BuildContext context, double bmi) {
    String message;
    if (bmi < 18.5) {
      message = 'You are underweight. Consider gaining some weight for better health.';
    } else if (bmi < 25) {
      message = 'You have a normal weight. Keep up the good work!';
    } else if (bmi < 30) {
      message = 'You are overweight. Consider losing some weight for better health.';
    } else if (bmi < 35) {
      message = 'You are obese. Please consult a healthcare provider for advice.';
    } else {
      message = 'You are severely obese. Please consult a healthcare provider for guidance.';
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('BMI: ${bmi.toStringAsFixed(1)}'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

class AboutUsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About Your BMI App',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'The Your BMI app aims to help users maintain a healthy body mass index (BMI). '
                  'It provides tools to calculate BMI, understand the different BMI categories, '
                  'and offers personalized advice based on your BMI value. Maintaining a healthy '
                  'BMI is crucial for overall health and well-being. We hope this app helps you achieve your health goals!',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}

