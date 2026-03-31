import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'CreaTarea.dart';

class Tarea extends StatefulWidget {
  const Tarea({super.key});

  @override
  State<Tarea> createState() => _TareaState();
}

class _TareaState extends State<Tarea> {
  List<String> tareas = ['Aprender Flutter', 'Hacer ejercicio'];

  //Crear tarea

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      extendBodyBehindAppBar: true,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text("Habit"),
      ),

      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < this.tareas.length; i++) Text(this.tareas[i]),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(250, 55),
                  backgroundColor: Color(0xFF4d5156).withOpacity(0.01),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) {
                      return FractionallySizedBox(
                        heightFactor: 0.7,
                        child: CreaTarea(),
                      );
                    },
                  );
                },
                child: Text(""),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
