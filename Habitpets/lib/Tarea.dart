import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'CreaTarea.dart';

class Tarea extends StatefulWidget {
  const Tarea({super.key});

  @override
  State<Tarea> createState() => _TareaState();
}

class _TareaState extends State<Tarea> {
  List<DecoraTask> tareas = [];

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
              for (int i = 0; i < this.tareas.length; i++) ...[
                tareas[i],
                SizedBox(height: 5),
              ],
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(250, 55),
                  backgroundColor: Color(0xFF4d5156).withOpacity(0.01),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () => setState(() {
                  anadir();
                }),
                child: Text(""),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void anadir() async {
    List<String>? resultado = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return FractionallySizedBox(heightFactor: 0.7, child: CreaTarea());
      },
    );

    if (resultado != null) {
      DecoraTask ad = DecoraTask(
        tipo_ico: resultado[0],
        title: resultado[1],
        time: resultado[2],
      );

      setState(() {
        tareas.add(ad);
      });
    }
  }
}

class DecoraTask extends StatefulWidget {
  final String tipo_ico;
  final String title;
  final String time;

  const DecoraTask({
    super.key,
    required String this.tipo_ico,
    required String this.title,
    required String this.time,
  });
  State<DecoraTask> createState() => _DecoraTask();
}

class _DecoraTask extends State<DecoraTask> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,

      padding: EdgeInsets.symmetric(vertical: 3, horizontal: 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white70,
      ),
      child: Row(
        children: [
          Image.asset(widget.tipo_ico, width: 50, height: 50),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              Text(widget.time, style: TextStyle(fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }
}
