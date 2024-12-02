import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';
import 'login_screen.dart';
import 'profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, String>> items = [
    {
      'title': 'Пістолет Глок 17',
      'description': 'Надійний та легкий у використанні.',
      'image': 'https://example.com/glock.jpg',
    },
    {
      'title': 'Штурмова гвинтівка АК-47',
      'description': 'Популярний автомат, який служить роками.',
      'image': 'https://example.com/ak47.jpg',
    },
    {
      'title': 'Мисливський ніж',
      'description': 'Ідеально підходить для полювання.',
      'image': 'https://example.com/knife.jpg',
    },
    {
      'title': 'Тактичний ліхтар',
      'description': 'Потужний ліхтар для тактичного використання.',
      'image': 'https://example.com/flashlight.jpg',
    },
  ];

  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  bool _isConnected = true;

  @override
  void initState() {
    super.initState();
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      bool connected = result != ConnectivityResult.none;
      if (connected != _isConnected) {
        setState(() {
          _isConnected = connected;
        });
        if (!_isConnected) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Відсутній зв’язок з інтернетом')),
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  Future<void> _logout(BuildContext context) async {
    // Clearing session data and navigating back to login
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ви успішно вийшли з системи')));
  }

  Future<void> _navigateToProfile(BuildContext context) async {
    // Navigating to profile screen only if connected
    if (_isConnected) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? firstName = prefs.getString('firstName');
      String? lastName = prefs.getString('lastName');
      String? email = prefs.getString('email');
      if (firstName != null && lastName != null && email != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileScreen(
              firstName: firstName,
              lastName: lastName,
              email: email,
            ),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Перегляд профілю недоступний без інтернету')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Зброярний магазин'),
        backgroundColor: Colors.brown,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: Image.network(
                item['image']!,
                width: 60,
                fit: BoxFit.cover,
              ),
              title: Text(item['title']!, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(item['description']!),
              trailing: const Icon(Icons.arrow_forward),
              onTap: _isConnected
                  ? () {
                      // Handle navigation
                    }
                  : null,
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToProfile(context),
        backgroundColor: _isConnected ? Colors.brown : Colors.grey,
        child: const Icon(Icons.person),
      ),
    );
  }
}
