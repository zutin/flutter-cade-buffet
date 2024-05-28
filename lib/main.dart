import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Cadê Buffet? - Flutter',
      home: ApplicationPage(),
    );
  }
}

// MODELS CLASSES

Future<List<Buffet>> fetchBuffets() async {
  final response = await http.get(Uri.parse('http://localhost:3000/api/v1/buffets'));
  if (response.statusCode == 200) {
    List<dynamic> buffetsJson = jsonDecode(response.body) as List<dynamic>;
    return buffetsJson.map((json) => Buffet.fromJson(json as Map<String, dynamic>)).toList();
  } else {
    throw Exception('Failed to load buffets.');
  }
}

class Buffet {
  final String trading_name;
  final String contact_number;
  final String email;
  final String address;
  final String district;
  final String state;
  final String city;
  final String zipcode;
  final String description;
  final String payment_methods;
  final double average_rating;

  const Buffet({
    required this.trading_name,
    required this.contact_number,
    required this.email,
    required this.address,
    required this.district,
    required this.state,
    required this.city,
    required this.zipcode,
    required this.description,
    required this.payment_methods,
    required this.average_rating,
  });

  factory Buffet.fromJson(Map<String, dynamic> json) {
    return Buffet(
      trading_name: json['trading_name'] as String,
      contact_number: json['contact_number'] as String,
      email: json['email'] as String,
      address: json['address'] as String,
      district: json['district'] as String,
      state: json['state'] as String,
      city: json['city'] as String,
      zipcode: json['zipcode'] as String,
      description: json['description'] as String,
      payment_methods: json['payment_methods'] as String,
      average_rating: json['average_rating'] as double,
    );
  }
}

// COMPONENTS

class BuffetCard extends StatelessWidget {
  const BuffetCard({super.key, required this.buffet});
  final Buffet buffet;

  @override
  Widget build(BuildContext context) {
    return Card(
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          splashColor: Colors.deepPurple.withAlpha(90),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BuffetDetailScreen(buffet: buffet),
              ),
            );
          },
          child: SizedBox(
            width: 150,
            height: 100,
            child: Center(
              child: Text(buffet.trading_name),
            ),
          ),
        ),
      );
  }
}

// PAGES CLASSES

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Buffet>> buffets;

  @override
  void initState() {
    super.initState();
    buffets = fetchBuffets();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Buffet>>(
      future: buffets,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: snapshot.data!.map((buffet) {
                  return BuffetCard(buffet: buffet);
                }).toList(),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return const Text('Sem conexão com o serviço de buffets.');
        }

        return const CircularProgressIndicator();
      },
    );
  }
}

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text('Users');
  }
}

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text('About');
  }
}

class BuffetDetailScreen extends StatelessWidget {
  const BuffetDetailScreen({super.key, required this.buffet});

  final Buffet buffet;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Visualizando ${buffet.trading_name}"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: ListView(
          children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: Text(buffet.description, style: const TextStyle(fontSize: 16)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Text('Telefone de contato:', style: TextStyle(fontWeight: FontWeight.bold)),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(buffet.contact_number),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text('E-mail:', style: TextStyle(fontWeight: FontWeight.bold)),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(buffet.email),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text('Endereço:', style: TextStyle(fontWeight: FontWeight.bold)),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(buffet.address),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text('Bairro:', style: TextStyle(fontWeight: FontWeight.bold)),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(buffet.district),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text('Cidade:', style: TextStyle(fontWeight: FontWeight.bold)),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("${buffet.city} - ${buffet.state}"),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text('CEP:', style: TextStyle(fontWeight: FontWeight.bold)),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(buffet.zipcode),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text('Métodos de pagamento:', style: TextStyle(fontWeight: FontWeight.bold)),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(buffet.payment_methods),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ]
        ),
      ),
    );
  }
}

// NAVIGATION CLASSES

class ApplicationPage extends StatefulWidget {
  const ApplicationPage({super.key});

  @override
  State<ApplicationPage> createState() => _ApplicationPageState();
}

class _ApplicationPageState extends State<ApplicationPage> {
  int _selectedIndex = 0;
  String _appTitle = 'Início';

  void _onItemTapped(int index, String title) {
    setState(() {
      _selectedIndex = index;
      _appTitle = title;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (_selectedIndex) {
      case 0:
        page = const HomePage();
        break;
      case 1:
        page = const UsersPage();
        break;
      case 2:
        page = const AboutPage();
        break;
      default:
        throw UnimplementedError('no widget for $_selectedIndex');
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_appTitle),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      body: Center(
        child: page
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                image: DecorationImage(image: NetworkImage("https://cdn.pixabay.com/photo/2021/05/24/15/58/pastries-6279692_960_720.jpg"),
                fit: BoxFit.cover)
              ),
              child: Text(''),
            ),
            ListTile(
              title: const Row(
                children: [
                  Icon(Icons.home),
                  SizedBox(width: 8),
                  Text('Início'),
                ],
              ),
              selected: _selectedIndex == 0,
              onTap: () {
                _onItemTapped(0, 'Início');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Row(
                children: [
                  Icon(Icons.people),
                  SizedBox(width: 8),
                  Text('Usuários'),
                ],
              ),
              selected: _selectedIndex == 1,
              onTap: () {
                _onItemTapped(1, 'Usuários');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Row(
                children: [
                  Icon(Icons.info),
                  SizedBox(width: 8),
                  Text('Saiba mais'),
                ],
              ),
              selected: _selectedIndex == 2,
              onTap: () {
                _onItemTapped(2, 'Saiba mais');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
