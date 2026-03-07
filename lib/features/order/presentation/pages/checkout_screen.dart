import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/features/cart/presentation/view_model/cart_view_model.dart';
import 'package:hamro_deal/features/order/domain/entities/order_entity.dart';
import 'package:hamro_deal/features/order/domain/entities/order_item_entity.dart';
import 'package:hamro_deal/features/order/domain/entities/shipping_address_entity.dart';
import 'package:hamro_deal/features/order/presentation/pages/order_confirmation_screen.dart';
import 'package:hamro_deal/features/order/presentation/state/order_state.dart';
import 'package:hamro_deal/features/order/presentation/view_model/order_view_model.dart';

const _kBlack = Color(0xFF1C1C1C);
const _kGrey = Color(0xFFEEEEEE);
const _kBgGrey = Color(0xFFF5F5F5);

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();

  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipCodeController = TextEditingController();
  final _countryController = TextEditingController(text: 'Nepal');
  final _notesController = TextEditingController();

  PaymentMethod _selectedPaymentMethod = PaymentMethod.cashOnDelivery;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(cartViewModelProvider.notifier).getCart();
    });
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipCodeController.dispose();
    _countryController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartViewModelProvider);
    final orderState = ref.watch(orderViewModelProvider);

    ref.listen<OrderState>(orderViewModelProvider, (previous, next) {
      if (next.status == OrderViewStatus.orderCreated &&
          next.currentOrder != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                OrderConfirmationScreen(order: next.currentOrder!),
          ),
        );
      }
      if (next.status == OrderViewStatus.error && next.errorMessage != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(next.errorMessage!)));
      }
    });

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
          'Checkout',
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
      body: cartState.cart == null || cartState.cart!.isEmpty
          ? const Center(child: Text('Cart is empty'))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildOrderSummary(cartState),
                    const SizedBox(height: 24),

                    _buildSectionTitle('Shipping Details'),
                    _buildShippingForm(),
                    const SizedBox(height: 24),

                    _buildSectionTitle('Payment Method'),
                    _buildPaymentMethod(),
                    const SizedBox(height: 24),

                    _buildSectionTitle('Order Notes'),
                    _buildTextField(
                      controller: _notesController,
                      label: 'Add a note (optional)',
                      maxLines: 3,
                    ),
                    const SizedBox(height: 32),

                    // Place Order button
                    GestureDetector(
                      onTap: orderState.status == OrderViewStatus.loading
                          ? null
                          : () => _placeOrder(cartState),
                      child: Container(
                        width: double.infinity,
                        height: 52,
                        decoration: BoxDecoration(
                          color: orderState.status == OrderViewStatus.loading
                              ? Colors.grey[400]
                              : _kBlack,
                          borderRadius: BorderRadius.circular(2),
                        ),
                        alignment: Alignment.center,
                        child: orderState.status == OrderViewStatus.loading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              )
                            : const Text(
                                'Place Order',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.3,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: _kBlack,
        ),
      ),
    );
  }

  Widget _buildOrderSummary(cartState) {
    final subtotal = cartState.cart!.total;
    const shippingFee = 50.0;
    const taxRate = 0.13;
    final taxAmount = subtotal * taxRate;
    final total = subtotal + shippingFee + taxAmount;

    return Container(
      decoration: BoxDecoration(
        color: _kBgGrey,
        borderRadius: BorderRadius.circular(4),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order Summary',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: _kBlack,
            ),
          ),
          const SizedBox(height: 12),

          // Items
          ...cartState.cart!.items.map(
            (item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '${item.product?.title ?? 'Product'} ×${item.quantity}',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 13, color: _kBlack),
                    ),
                  ),
                  Text(
                    'Rs. ${(item.price * item.quantity).toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: _kBlack,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(color: _kGrey, height: 1),
          ),

          _buildSummaryRow('Subtotal', 'Rs. ${subtotal.toStringAsFixed(0)}'),
          const SizedBox(height: 6),
          _buildSummaryRow('Shipping', 'Rs. ${shippingFee.toStringAsFixed(0)}'),
          const SizedBox(height: 6),
          _buildSummaryRow('Tax (13%)', 'Rs. ${taxAmount.toStringAsFixed(0)}'),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(color: _kGrey, height: 1),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  'Total',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: _kBlack,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Rs. ${total.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: _kBlack,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: _kBlack,
          ),
        ),
      ],
    );
  }

  Widget _buildShippingForm() {
    return Column(
      children: [
        _buildTextField(
          controller: _fullNameController,
          label: 'Full Name',
          validator: (v) =>
              v == null || v.isEmpty ? 'Please enter your full name' : null,
        ),
        const SizedBox(height: 12),
        _buildTextField(
          controller: _phoneController,
          label: 'Phone Number',
          keyboardType: TextInputType.phone,
          validator: (v) =>
              v == null || v.isEmpty ? 'Please enter your phone number' : null,
        ),
        const SizedBox(height: 12),
        _buildTextField(
          controller: _addressController,
          label: 'Address',
          validator: (v) =>
              v == null || v.isEmpty ? 'Please enter your address' : null,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                controller: _cityController,
                label: 'City',
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildTextField(
                controller: _zipCodeController,
                label: 'Zip Code',
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildTextField(
          controller: _stateController,
          label: 'State / Province (Optional)',
        ),
        const SizedBox(height: 12),
        _buildTextField(
          controller: _countryController,
          label: 'Country',
          validator: (v) => v == null || v.isEmpty ? 'Required' : null,
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      maxLines: maxLines,
      style: const TextStyle(fontSize: 14, color: _kBlack),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontSize: 13, color: Colors.grey[500]),
        filled: true,
        fillColor: _kBgGrey,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(2),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(2),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(2),
          borderSide: const BorderSide(color: _kBlack, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(2),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(2),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
      ),
    );
  }

  Widget _buildPaymentMethod() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: _kGrey),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        children: [
          _buildPaymentTile(
            value: PaymentMethod.cashOnDelivery,
            title: 'Cash on Delivery',
            icon: Icons.money_outlined,
            enabled: true,
          ),
          const Divider(height: 1, color: _kGrey),
          _buildPaymentTile(
            value: PaymentMethod.card,
            title: 'Card Payment',
            subtitle: 'Coming soon',
            icon: Icons.credit_card_outlined,
            enabled: false,
          ),
          const Divider(height: 1, color: _kGrey),
          _buildPaymentTile(
            value: PaymentMethod.online,
            title: 'Online Payment',
            subtitle: 'Coming soon',
            icon: Icons.account_balance_outlined,
            enabled: false,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentTile({
    required PaymentMethod value,
    required String title,
    required IconData icon,
    String? subtitle,
    required bool enabled,
  }) {
    final isSelected = _selectedPaymentMethod == value && enabled;

    return GestureDetector(
      onTap: enabled
          ? () => setState(() => _selectedPaymentMethod = value)
          : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        color: Colors.white,
        child: Row(
          children: [
            Icon(icon, size: 22, color: enabled ? _kBlack : Colors.grey[400]),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: enabled ? _kBlack : Colors.grey[400],
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 11, color: Colors.grey[400]),
                    ),
                ],
              ),
            ),
            // Custom radio
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? _kBlack : Colors.grey[400]!,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: _kBlack,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  void _placeOrder(cartState) {
    if (!_formKey.currentState!.validate()) return;

    final cart = cartState.cart!;

    final subtotal = cart.total;
    const shippingFee = 50.0;
    const taxRate = 0.13;
    final taxAmount = subtotal * taxRate;
    final total = subtotal + shippingFee + taxAmount;

    try {
      final orderItems = cart.items.map<OrderItemEntity>((item) {
        final sellerId = item.product?.sellerId;
        if (sellerId == null || sellerId.isEmpty) {
          throw Exception('Product ${item.product?.title ?? item.productId} has no seller information.');
        }

        return OrderItemEntity(
          productId: item.productId,
          productName: item.product?.title ?? 'Product',
          productImage: item.product?.firstImage,
          quantity: item.quantity,
          price: item.price,
          sellerId: sellerId,
        );
      }).toList();

      final shippingAddress = ShippingAddressEntity(
        fullName: _fullNameController.text,
        phone: _phoneController.text,
        address: _addressController.text,
        city: _cityController.text,
        state: _stateController.text.isEmpty ? '' : _stateController.text,
        zipCode: _zipCodeController.text,
        country: _countryController.text,
      );

      final order = OrderEntity(
        orderNumber: '',
        items: orderItems,
        shippingAddress: shippingAddress,
        paymentMethod: _selectedPaymentMethod,
        subtotal: subtotal,
        shippingCost: shippingFee,
        tax: taxAmount,
        total: total,
        status: OrderStatus.pending,
        notes: _notesController.text.isEmpty ? '' : _notesController.text,
      );

      ref.read(orderViewModelProvider.notifier).createOrder(order);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }
}
