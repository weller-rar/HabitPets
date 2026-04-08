import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'main.dart';

class Bienvenido extends StatefulWidget {
  @override
  State<Bienvenido> createState() => _Bienvenido();
}

class _Bienvenido extends State<Bienvenido> {
  final _formkey = GlobalKey<FormState>();
  late TextEditingController controller;
  late List<String> iconos = [
    //Los iconos de las mascotas van aqui------------
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
  int ico = 0;

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
      body: Form(
        key: _formkey,
        child: Container(
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
                TextFormField(
                  controller: controller,

                  decoration: InputDecoration(
                    hintText: "Nombre de tu mascota...",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (valor) {
                    if (valor == null || valor.trim().isEmpty) {
                      return "Tu mascota necesita un nombre";
                    }
                    if (valor.length > 15) {
                      return "El nombre es muy largo";
                    }
                    return null;
                  },
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      String nombre = controller.text.trim();

                      if (_formkey.currentState!.validate()) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyHomePage(
                              nombreMascota: nombre,
                              ico_mascota: iconos[ico],
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
      ),
    );
  }
}

class ButtonsPet extends GButton {
  ButtonsPet({super.key, required Widget customIcon})
    : super(text: "", icon: Icons.circle, leading: customIcon);
}
