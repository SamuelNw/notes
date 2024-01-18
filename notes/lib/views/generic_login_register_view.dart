import "package:flutter/material.dart";

class GenLogRegView extends StatefulWidget {
  const GenLogRegView({super.key});

  @override
  State<GenLogRegView> createState() => _GenLogRegViewState();
}

class _GenLogRegViewState extends State<GenLogRegView> {
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
              padding: const EdgeInsets.only(left: 50, right: 50),
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
                    "From fleeting thought, to lasting note",
                    style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 29,
                      fontFamily: "Jost",
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 80),
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
