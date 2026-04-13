import 'package:flutter/material.dart';
import 'main.dart';

class Bienvenido extends StatefulWidget {
  const Bienvenido({super.key});

  @override
  State<Bienvenido> createState() => _Bienvenido();
}

class _Bienvenido extends State<Bienvenido> {
  final _formkey = GlobalKey<FormState>();
  late TextEditingController controller;
  int ico = 0;

  final List<String> iconos = [
    'iconos/mascota/mascotas/gato.png',
    'iconos/mascota/mascotas/perro1.png',
    'iconos/mascota/mascotas/iqcat.png',
    'iconos/mascota/mascotas/huron.png',
    'iconos/mascota/mascotas/hamster.png',
    'iconos/mascota/mascotas/fatcat.png',
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
    final size = MediaQuery.of(context).size;
    final isSmall = size.width < 380;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        foregroundColor: Colors.black87,
        title: const Text('Bienvenido a HabitPets'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('paisajes/campo.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          color: Colors.white.withValues(alpha: 0.24),
          child: Form(
            key: _formkey,
            child: SafeArea(
              child: Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                      isSmall ? 16 : 24,
                      kToolbarHeight + 8,
                      isSmall ? 16 : 24,
                      16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Elige a tu mascota:',
                          style: TextStyle(
                            fontSize: isSmall ? 24 : 30,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 14),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final width = constraints.maxWidth;
                            int columns = 3;
                            if (width < 290) {
                              columns = 2;
                            } else if (width > 460) {
                              columns = 4;
                            }

                            return GridView.builder(
                              itemCount: iconos.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: columns,
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 12,
                                    childAspectRatio: 1,
                                  ),
                              itemBuilder: (context, index) {
                                final selected = ico == index;
                                return InkWell(
                                  borderRadius: BorderRadius.circular(999),
                                  onTap: () => setState(() => ico = index),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: selected
                                          ? const Color(0xFFFFD84D)
                                          : Colors.white,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: selected
                                            ? const Color(0xFFE2B400)
                                            : const Color(0xFFE6E6E6),
                                        width: selected ? 3 : 1.5,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: selected
                                              ? const Color(
                                                  0xFFFFD84D,
                                                ).withValues(alpha: 0.45)
                                              : Colors.black12,
                                          blurRadius: selected ? 14 : 8,
                                          spreadRadius: selected ? 2 : 0,
                                        ),
                                      ],
                                    ),
                                    child: ClipOval(
                                      child: Image.asset(
                                        iconos[index],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 18),
                        Text(
                          'Dale un nombre:',
                          style: TextStyle(
                            fontSize: isSmall ? 20 : 26,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: controller,
                          style: TextStyle(fontSize: isSmall ? 24 : 30),
                          decoration: InputDecoration(
                            hintText: 'Nombre de tu mascota...',
                            hintStyle: TextStyle(
                              fontSize: isSmall ? 18 : 20,
                              color: Colors.grey.shade600,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 14,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(
                                color: Color(0xFF8E8E8E),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(
                                color: Color(0xFF8E8E8E),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(
                                color: Color(0xFF41A766),
                                width: 2,
                              ),
                            ),
                          ),
                          validator: (valor) {
                            if (valor == null || valor.trim().isEmpty) {
                              return 'Tu mascota necesita un nombre';
                            }
                            if (valor.length > 15) {
                              return 'El nombre es muy largo';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              final nombre = controller.text.trim();

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
                            icon: const Icon(Icons.check),
                            label: const Text('Entrar'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF41A766),
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                horizontal: isSmall ? 28 : 36,
                                vertical: isSmall ? 12 : 15,
                              ),
                              textStyle: TextStyle(
                                fontSize: isSmall ? 24 : 30,
                                fontWeight: FontWeight.w700,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
