import 'package:flutter/material.dart';

class RoundButtonWidget extends StatelessWidget {
  const RoundButtonWidget({Key? key, required this.title, required this.onTap, this.loading = false}) : super(key: key);
  final String title;
  final VoidCallback onTap;
  final bool loading;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        height: 50,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.deepPurple),
        child: loading
            ? CircularProgressIndicator(
                strokeWidth: 3,
                color: Colors.white,
              )
            : Text(
                title,
                style: TextStyle(color: Colors.white),
              ),
      ),
    );
  }
}
