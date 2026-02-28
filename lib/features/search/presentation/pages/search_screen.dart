import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/features/product/presentation/page/porduct_browse_screen.dart';
import 'package:hamro_deal/features/product/presentation/view_model/product_browse_view_model.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _performSearch() {
    final query = _controller.text.trim();
    if (query.isNotEmpty) {
      // Update the product browse view model with search query
      ref.read(productBrowseViewModelProvider.notifier).updateSearch(query);

      // Navigate to browse screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const PorductBrowseScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Products'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Search TextField
              TextField(
                controller: _controller,
                onSubmitted: (_) => _performSearch(),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFE0E0E0),
                  hintText: "Search for products...",
                  hintStyle: const TextStyle(
                    fontFamily: 'Jost Regular',
                    color: Color(0xFF9E9E9E),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: const Icon(Icons.search, color: Colors.black),
                  suffixIcon: _controller.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _controller.clear();
                            setState(() {});
                          },
                        )
                      : null,
                ),
                onChanged: (_) => setState(() {}),
              ),

              const SizedBox(height: 16),

              // Search Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _performSearch,
                  icon: const Icon(Icons.search),
                  label: const Text('Search'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Search suggestions or recent searches
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Popular Searches',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildSearchChip('Electronics'),
                        _buildSearchChip('Clothing'),
                        _buildSearchChip('Books'),
                        _buildSearchChip('Home & Garden'),
                        _buildSearchChip('Sports'),
                        _buildSearchChip('Toys'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchChip(String label) {
    return ActionChip(
      label: Text(label),
      onPressed: () {
        _controller.text = label;
        setState(() {});
        _performSearch();
      },
      avatar: const Icon(Icons.search, size: 18),
    );
  }
}
