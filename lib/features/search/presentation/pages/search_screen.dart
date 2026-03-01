import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/features/product/presentation/page/porduct_browse_screen.dart';
import 'package:hamro_deal/features/product/presentation/view_model/product_browse_view_model.dart';

const _kBlack = Color(0xFF1C1C1C);
const _kGrey = Color(0xFFEEEEEE);
const _kBgGrey = Color(0xFFF5F5F5);

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  final List<String> _popularSearches = [
    'Electronics',
    'Clothing',
    'Books',
    'Home & Garden',
    'Sports',
    'Toys',
    'Footwear',
    'Jewelry',
  ];

  @override
  void initState() {
    super.initState();
    // Auto focus on open
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _performSearch() {
    final query = _controller.text.trim();
    if (query.isNotEmpty) {
      ref.read(productBrowseViewModelProvider.notifier).updateSearch(query);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const PorductBrowseScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: _kGrey,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back, color: _kBlack, size: 20),
          ),
        ),
        title: const Text(
          'Search',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: _kBlack,
          ),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: _kGrey),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Search field ──
              Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(color: Colors.grey, width: 1),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Colors.grey, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        focusNode: _focusNode,
                        onSubmitted: (_) => _performSearch(),
                        onChanged: (_) => setState(() {}),
                        style: const TextStyle(fontSize: 15, color: _kBlack),
                        decoration: InputDecoration(
                          hintText: 'What do you need?',
                          hintStyle: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[400],
                          ),
                          border: InputBorder.none,
                          isDense: true,
                        ),
                      ),
                    ),
                    if (_controller.text.isNotEmpty)
                      GestureDetector(
                        onTap: () {
                          _controller.clear();
                          setState(() {});
                        },
                        child: const Icon(
                          Icons.close,
                          color: Colors.grey,
                          size: 18,
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // ── Search button ──
              if (_controller.text.isNotEmpty)
                GestureDetector(
                  onTap: _performSearch,
                  child: Container(
                    width: double.infinity,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(2),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Search "${_controller.text}"',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ),

              const SizedBox(height: 28),

              // ── Popular searches ──
              Text(
                'Popular Searches',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[500],
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _popularSearches
                    .map((label) => _buildChip(label))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChip(String label) {
    return GestureDetector(
      onTap: () {
        _controller.text = label;
        setState(() {});
        _performSearch();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: _kBgGrey,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search, size: 14, color: Colors.grey[500]),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: _kBlack,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
