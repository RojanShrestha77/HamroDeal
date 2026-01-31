import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Stack(
            alignment: Alignment.center,
            children: [
              TextField(
                controller: _controller,
                // textAlign: TextAlign.center,
                onChanged: (_) {
                  setState(() {});
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xFFE0E0E0),
                  hintText: "Search",
                  hintStyle: const TextStyle(
                    fontFamily: 'Jost Regular',
                    color: Color(0xFF9E9E9E),
                  ),

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: _controller.text.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.only(left: 150),
                          child: const Icon(Icons.search, color: Colors.black),
                        )
                      : null,
                  prefixIconConstraints: const BoxConstraints(
                    minWidth: 0,
                    minHeight: 0,
                  ),
                ),
              ),
              // const Positioned(
              //   left: 135,
              //   child: Icon(Icons.search, color: Colors.black),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
