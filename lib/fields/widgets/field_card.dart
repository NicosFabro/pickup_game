import 'package:flutter/material.dart';

// Packages
import 'package:field_repository/field_repository.dart';

class FieldCard extends StatelessWidget {
  const FieldCard({
    Key? key,
    required this.field,
  }) : super(key: key);

  final Field field;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      height: 150,
      child: Stack(
        children: [
          Image.network(
            field.logoUrl,
            width: 150,
            height: 150,
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 30,
              color: Colors.white70,
              child: Center(
                child: Text(
                  field.name,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
