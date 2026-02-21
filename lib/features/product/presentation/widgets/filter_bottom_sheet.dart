import 'package:flutter/material.dart';

class FilterBottomSheet extends StatefulWidget {
  final double? initialMinPrice;
  final double? initialMaxPrice;
  final String? initialSort;
  final Function(double?, double?, String?) onApply;

  const FilterBottomSheet({
    super.key,
    this.initialMinPrice,
    this.initialMaxPrice,
    this.initialSort,
    required this.onApply,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late TextEditingController _minPriceController;
  late TextEditingController _maxPriceController;
  String? _selectedSort;

  @override
  void initState() {
    super.initState();
    _minPriceController = TextEditingController(
      text: widget.initialMinPrice?.toString() ?? '',
    );
    _maxPriceController = TextEditingController(
      text: widget.initialMaxPrice?.toString() ?? '',
    );
    _selectedSort = widget.initialSort;
  }

  @override
  void dispose() {
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Filters',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Price Range
          const Text(
            'Price Range',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _minPriceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Min Price',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixText: 'Rs ',
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text('-'),
              ),
              Expanded(
                child: TextField(
                  controller: _maxPriceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Max Price',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixText: 'Rs ',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Sort By
          const Text(
            'Sort By',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          _buildSortOption('Price: Low to High', 'price_asc'),
          _buildSortOption('Price: High to Low', 'price_desc'),
          _buildSortOption('Newest First', 'newest'),
          const SizedBox(height: 24),

          // Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    _minPriceController.clear();
                    _maxPriceController.clear();
                    setState(() => _selectedSort = null);
                    widget.onApply(null, null, null);
                    Navigator.pop(context);
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Clear'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    final minPrice = _minPriceController.text.isEmpty
                        ? null
                        : double.tryParse(_minPriceController.text);
                    final maxPrice = _maxPriceController.text.isEmpty
                        ? null
                        : double.tryParse(_maxPriceController.text);

                    widget.onApply(minPrice, maxPrice, _selectedSort);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Apply',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSortOption(String label, String value) {
    return RadioListTile<String>(
      title: Text(label),
      value: value,
      groupValue: _selectedSort,
      onChanged: (val) => setState(() => _selectedSort = val),
      contentPadding: EdgeInsets.zero,
    );
  }
}
