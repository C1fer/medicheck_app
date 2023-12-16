import 'package:flutter/material.dart';
import 'package:medicheck/screens/login/login.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});
  static const String id = 'onboarding';

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  int step = 1;
  static const List<String> headlines = [
    "Consulta la cobertura de cualquier medicamento",
    "Encuentra centros cercanos afiliados",
    "Revisa tu historial de búsqueda"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                child: Text('Saltar'),
                onTap: () {
                  Navigator.pushNamed(context, Login.id);
                },
              )
            ],
          ),
          Container(
            width: 315,
            height: 441,
            decoration: ShapeDecoration(
              image: DecorationImage(
                image: AssetImage("assets/img/onboarding_${step}.png"),
                fit: BoxFit.fill,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(35),
              ),
            ),
          ),
          Text(headlines[step-1],
              style: TextStyle(
                color: Color(0xFF101522),
                fontSize: 22,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
              )),
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(step.toString()),
              FloatingActionButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                backgroundColor: Colors.white,
                child: Icon(Icons.arrow_right),
                onPressed: () {
                  if (step < 3) {
                    setState(() {
                      step++;
                    });
                  }
                  else{
                    Navigator.pushNamed(context, Login.id);
                  }
                },
              ),
            ],
          )
        ],
      ),
    ));
  }
}
