import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class Tienda extends StatefulWidget {
  const Tienda({super.key});

  @override
  State<Tienda> createState() => _Tienda();
}

class _Tienda extends State<Tienda> {
  int n_arti = 0;

  @override
  Widget build(BuildContext context) {
    final articulos = [
      Atuendo(context),
      Juguetes(context),
      Comida(context),
      Muebles(context),
    ];

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text("Store"),
      ),
      body: Container(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 400),
              Container(child: articulos[n_arti]),
              SizedBox(height: 50),
              Container(
                //Poner widget para que no cambie la posicion
                width: 310,
                padding: EdgeInsets.symmetric(vertical: 3, horizontal: 0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Color(0xffa6c98d),
                ),

                child: GNav(
                  mainAxisAlignment: MainAxisAlignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  tabBackgroundColor: Color(0xff202c3b),
                  tabBorderRadius: 15,

                  onTabChange: (index) => setState(() => n_arti = index),

                  tabs: [
                    GButton(
                      icon: Icons.home,
                      leading: icono(
                        ico: Icons.checkroom,
                        tex: "Atuendos",
                        activo: n_arti == 0,
                      ),
                    ),
                    GButton(
                      icon: Icons.home,
                      leading: icono(
                        ico: Icons.toys,
                        tex: "Juguetes",
                        activo: n_arti == 1,
                      ),
                    ),
                    GButton(
                      icon: Icons.home,
                      leading: icono(
                        ico: Icons.pets,
                        tex: "Comida",
                        activo: n_arti == 2,
                      ),
                    ),
                    GButton(
                      icon: Icons.home,
                      leading: icono(
                        ico: Icons.chair,
                        tex: "Muebles",
                        activo: n_arti == 3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget Atuendo(BuildContext context) {
    return Column(children: [Text("Atuendo")]);
  }

  Widget Juguetes(BuildContext context) {
    return Column(children: [Text("Juguetes")]);
  }

  Widget Comida(BuildContext context) {
    return Column(children: [Text("Comida")]);
  }

  Widget Muebles(BuildContext context) {
    return Column(children: [Text("Muebles")]);
  }
}

class icono extends StatelessWidget {
  final String tex;
  final IconData ico;
  final bool activo;

  const icono({
    super.key,
    required this.ico,
    required this.tex,
    required this.activo,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(ico, color: activo ? Color(0xffe3e6d6) : Colors.black),
        Text(
          tex,
          style: TextStyle(color: activo ? Color(0xffe3e6d6) : Colors.black),
        ),
      ],
    );
  }
}
