import 'package:flutter/material.dart';
import 'components/tab_content.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              // add a gradient to the container
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF0066FF),
                    Color(0xFF00D6FF),
                  ],
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Welcome back,',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontFamily: 'Inter',
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(200),
                      child: Image.asset(
                        'assets/images/mozartiscute.jpg',
                        height: height * 0.2,
                        width: height * 0.2,
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                      ),
                    ),
                    Text(
                      'Wolfgang Amadeus Mozart',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Inter'),
                    ),
                    Text(
                      'B95CS001',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Inter'),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(child: TabContent(isDaily: true)),
          ],
        ),
      ),
    );
  }
}
