import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'main.dart';

class Bienvenido extends StatefulWidget {
  @override
  State<Bienvenido> createState() => _Bienvenido();
}

class _Bienvenido extends State<Bienvenido> {
  late TextEditingController controller;
  int? ico;

  List<String> iconos = [
    "iconos/mascota/mascotas/perro.gif",
    "iconos/mascota/mascotas/perro.gif",
    "iconos/mascota/mascotas/perro.gif",
    "iconos/mascota/mascotas/perro.gif",
    "iconos/mascota/mascotas/perro.gif",
    "iconos/mascota/mascotas/perro.gif",
    "iconos/mascota/mascotas/perro.gif",
    "iconos/mascota/mascotas/perro.gif",
    "iconos/mascota/mascotas/perro.gif",
    "iconos/mascota/mascotas/perro.gif",
  ];

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text("Bienvenido a HabitPets")),
      body: Container(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Elige a tu mascota:"),
              SizedBox(
                height: 80,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    GNav(
                      tabBackgroundColor: Colors.amber,
                      onTabChange: (index) => setState(() {
                        ico = index;
                      }),
                      tabs: [
                        for (int i = 0; i < this.iconos.length; i++)
                          ButtonsPet(
                            customIcon: Image.asset(
                              iconos[i],
                              width: 30,
                              height: 30,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              Text("Dale un nombre:"),
              TextField(
                controller: controller,

                decoration: InputDecoration(
                  hintText: "Nombre de tu mascota...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    String nombre = controller.text.trim();

                    if (nombre.isNotEmpty && ico != null) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyHomePage(
                            nombreMascota: nombre,
                            ico_mascota: iconos[ico!],
                          ),
                        ),
                      );
                    }
                  },
                  child: Text("Entrar"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ButtonsPet extends GButton {
  ButtonsPet({super.key, required Widget customIcon})
    : super(text: "", icon: Icons.circle, leading: customIcon);
}
