import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/features/product/presentation/state/product_browse_state.dart';
import 'package:hamro_deal/features/product/presentation/view_model/product_browse_view_model.dart';
import 'package:hamro_deal/features/product/presentation/widgets/category_filter_chips.dart';
import 'package:hamro_deal/features/product/presentation/widgets/filter_bottom_sheet.dart';
import 'package:hamro_deal/features/product/presentation/widgets/product_browse_grid.dart';
import 'package:hamro_deal/features/product/presentation/widgets/product_search_bar.dart';

class PorductBrowseScreen extends ConsumerStatefulWidget {
  const PorductBrowseScreen({super.key});

  @override
  ConsumerState<PorductBrowseScreen> createState() => _PorductBrowseScreenState();
}

class _PorductBrowseScreenState extends ConsumerState<PorductBrowseScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch products when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(productBrowseViewModelProvider.notifier).refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(productBrowseViewModelProvider);
    final viewModel = ref.watch(productBrowseViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Browse Products'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.tune),
                onPressed: () =>
                    _showFilterBottomSheet(context, state, viewModel),
              ),
              if (state.minPrice != null ||
                  state.maxPrice != null ||
                  state.sortOption != null)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
          // clear filters
          if (state.hasFilters)
            IconButton(
              icon: const Icon(Icons.clear_all),
              onPressed: () => viewModel.clearFilters(),
              tooltip: 'Clear all filters',
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => viewModel.refresh(),
        child: Column(
          children: [
            // searhc bar
            ProductSearchBar(
              initialValue: state.searchQuery,
              onSearch: (query) => viewModel.updateSearch(query),
            ),

            // caegoryfilter
            CategoryFilterChips(
              selectedCategoryId: state.selectedCategoryId,
              onCategorySelected: (categoryId) =>
                  viewModel.selectCategory(categoryId),
            ),

            // activefilteres
            if (state.hasFilters)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Wrap(
                  spacing: 8,
                  children: [
                    if (state.searchQuery != null)
                      Chip(
                        label: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.6,
                          ),
                          child: Text(
                            'Search: ${state.searchQuery}',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        onDeleted: () => viewModel.updateSearch(''),
                        deleteIcon: const Icon(Icons.close, size: 18),
                      ),
                    if (state.minPrice != null || state.maxPrice != null)
                      Chip(
                        label: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.6,
                          ),
                          child: Text(
                            'Price: Rs${state.minPrice ?? 0} - Rs ${state.maxPrice ?? '∞'}',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        onDeleted: () => viewModel.updatePriceRange(
                          minPrice: null,
                          maxPrice: null,
                        ),
                        deleteIcon: const Icon(Icons.close, size: 18),
                      ),
                    if (state.sortOption != null)
                      Chip(
                        label: Text(_getSortLabel(state.sortOption!)),
                        onDeleted: () => viewModel.updateSort(null),
                        deleteIcon: const Icon(Icons.close, size: 18),
                      ),
                  ],
                ),
              ),
            // Error Message
            if (state.status == ProductBrowseStatus.error)
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.red.shade50,
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.red.shade700),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        state.error ?? 'An error occurred',
                        style: TextStyle(color: Colors.red.shade700),
                      ),
                    ),
                  ],
                ),
              ),

            // porduct grid
            Expanded(
              child: ProductBrowseGrid(
                products: state.products,
                isLoading: state.status == ProductBrowseStatus.loading,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterBottomSheet(
    BuildContext context,
    ProductBrowseState state,
    ProductBrowseViewModel viewModel,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheet(
        initialMinPrice: state.minPrice,
        initialMaxPrice: state.maxPrice,
        initialSort: state.sortOption,
        onApply: (minPrice, maxPrice, sort) {
          viewModel.updatePriceRange(minPrice: minPrice, maxPrice: maxPrice);
          if (sort != state.sortOption) {
            viewModel.updateSort(sort);
          }
        },
      ),
    );
  }

  String _getSortLabel(String sort) {
    switch (sort) {
      case 'price_asc':
        return 'Price: Low to High';
      case 'price_desc':
        return 'Price: High to Low';
      case 'newest':
        return 'Newest First';
      default:
        return sort;
    }
  }
}
