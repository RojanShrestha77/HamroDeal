import 'package:flutter/material.dart';

class VerticalProductCard extends StatelessWidget {
  final String title;
  final String image;

  const VerticalProductCard({
    super.key,
    required this.title,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      clipBehavior: Clip.antiAlias, // Ensures content respects rounded corners
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image - takes most of the space
          Expanded(
            child: Image.asset(
              image,
              width: double.infinity,
              fit: BoxFit.cover, // Fills the area perfectly, crops if needed
            ),
          ),
          Row(
            children: [
              // Title inside the card at the bottom
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Positioned(
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.favorite_outline),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
