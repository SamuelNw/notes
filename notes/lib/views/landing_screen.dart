import "package:flutter/material.dart";

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/view_bgs/initial_bg.jpg"),
                fit: BoxFit.fill,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 80, right: 80),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Image(
                    image: AssetImage("assets/icon/icon.png"),
                    height: 70,
                    width: 70,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text(
                    "Think freely, remember precisely.",
                    style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 25,
                      fontFamily: "Jost",
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Capture. Organize. Create",
                    style: TextStyle(
                      color: Color.fromARGB(255, 168, 168, 168),
                      fontSize: 20,
                      fontFamily: "Jost",
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 70),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 25, 159, 153),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(120, 48),
                    ),
                    child: const Text(
                      "Get Started",
                      style: TextStyle(fontSize: 18, fontFamily: "Jost"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
