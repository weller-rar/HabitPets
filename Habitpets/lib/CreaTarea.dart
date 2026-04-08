import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class CreaTarea extends StatefulWidget {
  @override
  State<CreaTarea> createState() => _CreaTarea();
}

class _CreaTarea extends State<CreaTarea> {
  final _formkey = GlobalKey<FormState>();
  late TextEditingController controller;
  late List<String> typeHabit;
  int ico = 0;
  String? time;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    typeHabit = [
      //Ey pela agrega los iconos aqui
      "iconos/tareas/agua_ico.png",
      "iconos/tareas/agua_ico.png",
      "iconos/tareas/agua_ico.png",
      "iconos/tareas/agua_ico.png",
      "iconos/tareas/agua_ico.png",
      "iconos/tareas/agua_ico.png",
    ];
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formkey,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color(0xFFdbeaf1),
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
                  GNav(
                    tabBackgroundColor: Colors.blue.withOpacity(0.2),
                    activeColor: Colors.blue,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    tabBorderRadius: 15,
                    onTabChange: (index) => setState(() {
                      ico = index;
                    }),
                    tabs: [
                      for (int i = 0; i < typeHabit.length; i++)
                        GButton(
                          icon: Icons.circle,
                          leading: Image.asset(
                            typeHabit[i],
                            width: 50,
                            height: 50,
                          ),
                          text: '',
                        ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 5),
            Sub(text: "Título", tamano: 18),
            SizedBox(height: 5),
            TextFormField(
              controller: controller,
              decoration: InputDecoration(
                hintText: "Escribe el título aquí...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              validator: (valor) {
                if (valor == null || valor.trim().isEmpty) {
                  return "Necesita un titulo";
                }
                if (valor.length > 15) {
                  return "Titulo muy grande";
                }
                return null;
              },
            ),
            SizedBox(height: 15),
            Sub(text: "Hora", tamano: 18),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.access_time),
                  onPressed: () async {
                    final TimeOfDay? picked = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );

                    if (picked != null) {
                      setState(() {
                        time = picked.format(context);
                      });
                    }
                  },
                ),
                if (time != null) Text(time!),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, null);
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
                  onPressed: () {
                    if (_formkey.currentState!.validate()) {
                      if (time == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Necesita una hora"),
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                      } else {
                        String nombre = controller.text.trim();
                        List<String> confi = [typeHabit[ico], nombre, time!];
                        Navigator.pop(context, confi);
                      }
                    }
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
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
                ),
              ],
            ),
          ],
        ),
      ),
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
