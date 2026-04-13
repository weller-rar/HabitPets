import 'package:flutter/material.dart';
import 'Menu.dart';

class Mascota extends StatelessWidget {
  final String nombre;
  final String mascota;

  const Mascota({super.key, required this.nombre, required this.mascota});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      extendBodyBehindAppBar: true,
      //AppBar
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          //--PONGANLE ICONO A ESTE BOTON--
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => Menu()));
          },
          icon: const Text("Menu"),
        ),
      ),

      //Body
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(mascota, width: 350),
              Text(this.nombre), //--QUE EL NOMBRE SE VEA BIEN
            ],
          ),
        ),
      ),
    );
  }
}
