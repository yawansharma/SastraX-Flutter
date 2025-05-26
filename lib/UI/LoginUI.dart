import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';

class LoginUI extends StatelessWidget {
  const LoginUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/background.png'),
              fit: BoxFit.fill
          )
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            left: 30,
            width: 80,
            height: 200,
            child: FadeInUp(duration: Duration(seconds: 1), child: Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/light-1.png')
                  )
              ),
            )),
          ),
          Positioned(
            left: 140,
            width: 80,
            height: 150,
            child: FadeInUp(duration: Duration(milliseconds: 1200), child: Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/light-2.png')
                  )
              ),
            )),
          ),
          Positioned(
            child: FadeInUp(duration: Duration(milliseconds: 1600), child: Container(
              margin: EdgeInsets.only(top: 50),
            )),
          )
        ],
      ),
    );
  }
}
