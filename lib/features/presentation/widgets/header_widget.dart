import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  final String title;
  const HeaderWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
              Container(
                alignment: Alignment.center,
                child: Text(title,
                 style: const TextStyle(
                  fontSize: 35,
                  color: Colors.black,
                  fontWeight: FontWeight.w400
                )),
              ),
              const SizedBox(height: 1),
              const Divider(thickness: 1),
              const SizedBox(height: 10),
      ],
    );
  }
}