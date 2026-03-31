import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'Bienvenido.dart';
import 'Mascota.dart';
import 'Tarea.dart';
import 'Racha.dart';
import 'Tienda.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'HabitPets', home: Bienvenido());
  }
}

class MyHomePage extends StatefulWidget {
  final String nombreMascota;
  final String ico_mascota;

  const MyHomePage({
    super.key,
    required this.nombreMascota,
    required this.ico_mascota,
  });
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<Widget> pantallas;
  int pantalla = 0;

  @override
  void initState() {
    super.initState();
    pantallas = [
      Mascota(nombre: widget.nombreMascota, mascota: widget.ico_mascota),
      Tarea(),
      Racha(),
      Tienda(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("paisajes/campo.gif"),
            fit: BoxFit.cover,
          ),
        ),
        child: pantallas[pantalla],
      ),

      //NavigatorBar
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ), //la parte de los lados
        margin: const EdgeInsets.only(
          bottom: 0,
        ), //esto espara la parte de abajo

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              const Color(0xFF1E2E43),
              const Color(0xFF1E2E43).withOpacity(0.4),
            ],
          ),
        ),

        child: GNav(
          onTabChange: (index) => setState(() => pantalla = index),

          tabBackgroundColor: Color(0xFF1E2E43),
          tabActiveBorder: Border.all(color: Color(0xFF47C2D4), width: 2),
          tabBorderRadius: 20,
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          tabs: [
            GButton(
              icon: Icons.home,
              leading: Column(
                children: [
                  Image.asset("iconos/mascota/mascota_ico.png", width: 50),
                ],
              ),
            ),
            GButton(
              icon: Icons.home,
              leading: Column(
                children: [
                  Image.asset(
                    "iconos/tareas/tarea_ico.png",
                    width: 30,
                    height: 35,
                  ),
                ],
              ),
            ),
            GButton(
              icon: Icons.home,
              leading: Column(
                children: [
                  Image.asset("iconos/racha/racha_ico.png", width: 40),
                ],
              ),
            ),
            GButton(
              icon: Icons.home,
              leading: Column(
                children: [
                  Image.asset("iconos/tienda/tienda_ico.png", width: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
