import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
   final IconData icon;
  final String title;
  final Function onPressed;

  const  CustomButton(
      {super.key, 
        required this.icon,
        required this.title,
        required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return    InkWell(
      onTap: () {
        onPressed();
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: Icon(
                  icon,
                  color: const Color.fromARGB(255, 255, 4, 4),
                  size: 40,
                ),
              ),
            ),
            Container(
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 255, 4, 4),
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(10))
                ),
                width: double.maxFinite,
                height: 40,
                child: Center(
                  child: Text(
                    title,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}