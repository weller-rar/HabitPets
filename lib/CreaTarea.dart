import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CreaTarea extends StatelessWidget {
  const CreaTarea({super.key});

  @override
  Widget build(BuildContext context) {
    String? tipo;
    String? titulo;
    String? tiempo;
    bool? estado;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      width: double.infinity,

      decoration: BoxDecoration(
        color: Color(0xFFdbeaf1),
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: Sub(text: "Añadir Nueva Tarea", tamano: 23)),
          SizedBox(height: 20),
          Sub(text: "Tipo", tamano: 18),
          SizedBox(
            height: 80,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                TipoIco(imagen: "iconos/mascota/mascota_ico.png"),
                TipoIco(imagen: "iconos/mascota/mascota_ico.png"),
                TipoIco(imagen: "iconos/mascota/mascota_ico.png"),
                TipoIco(imagen: "iconos/mascota/mascota_ico.png"),
                TipoIco(imagen: "iconos/mascota/mascota_ico.png"),
                TipoIco(imagen: "iconos/mascota/mascota_ico.png"),
                TipoIco(imagen: "iconos/mascota/mascota_ico.png"),
                TipoIco(imagen: "iconos/mascota/mascota_ico.png"),
              ],
            ),
          ),
          SizedBox(height: 5),
          Sub(text: "Título", tamano: 18),
          SizedBox(height: 5),
          TextField(
            decoration: InputDecoration(
              hintText: "Escribe el título aquí...",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          SizedBox(height: 15),
          Sub(text: "Hora", tamano: 18),
          IconButton(
            icon: Icon(Icons.access_time),
            onPressed: () async {
              final TimeOfDay? picked = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );

              if (picked != null) {
                print(picked.format(context));
              }
            },
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Cancelar",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset("iconos/otros/chulo.png", width: 20),
                    SizedBox(width: 8),
                    Text(
                      "Guardar",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ), //h
        ],
      ),
    );
  }
}

class tip {
  String img;
  tip(this.img);

  String regresar() {
    return img;
  }
}

class TipoIco extends StatelessWidget {
  final String imagen;
  const TipoIco({super.key, required this.imagen});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        tip(imagen).regresar();
      },
      icon: Image.asset(imagen),
    );
  }
}

class Sub extends StatelessWidget {
  final String text;
  final double tamano;

  const Sub({super.key, required this.text, required this.tamano});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: tamano),
    );
  }
}
