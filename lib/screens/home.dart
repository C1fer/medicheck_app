import 'package:flutter/material.dart';
import 'package:medicheck/styles/app_styles.dart';
import 'package:medicheck/utils/api/api_service.dart';
import '../models/usuario.dart';
import '../utils/jwt_service.dart';
import 'package:convert/convert.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  static const String id = 'Home';

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Usuario? currentUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchData();
  }

  void _fetchData() async {
    var _userInfo = await JWTService.decodeJWT();
    currentUser = await ApiService.getUserById(_userInfo!['IdUsuario']);
    print(currentUser);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              'Revisa tu informacion de cobertura',
              style: AppStyles.headingTextStyle,
            ),
            SizedBox(
              height: 24.0,
            ),
            Container(
              width: 324,
              height: 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(24)),
                  color: Color(0xffFBFBFB)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Row(children: [Icon(Icons.search), Text('Search')]),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
