import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/features/cart/presentation/view_model/cart_view_model.dart';
import 'package:hamro_deal/features/order/domain/entities/order_entity.dart';
import 'package:hamro_deal/features/order/domain/entities/order_item_entity.dart';
import 'package:hamro_deal/features/order/domain/entities/shipping_address_entity.dart';
import 'package:hamro_deal/features/order/presentation/pages/order_confirmation_screen.dart';
import 'package:hamro_deal/features/order/presentation/state/order_state.dart';
import 'package:hamro_deal/features/order/presentation/view_model/order_view_model.dart';

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
        // got to confirmation screem
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                OrderConfirmationScreen(order: next.currentOrder!),
          ),
        );
      }
      if (next.status == OrderViewStatus.error && next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: Colors.red,
          ),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: cartState.cart == null || cartState.cart!.isEmpty
          ? const Center(child: Text('Cart is empty'))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // order summary
                    _buildOrderSummary(cartState),
                    const SizedBox(height: 24),

                    // shipping details
                    _buildSectionTitle('Shipping Details'),
                    _buildShippingForm(),
                    const SizedBox(height: 24),

                    // payment method
                    _buildSectionTitle('Payment Method'),
                    _buildPaymentMethod(),
                    const SizedBox(height: 24),

                    // additional notes
                    _buildSectionTitle('Order Notes(optional)'),
                    TextFormField(
                      controller: _notesController,
                      decoration: const InputDecoration(
                        labelText: 'Order Notes (optional)',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 24),

                    // place order button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: orderState.status == OrderViewStatus.loading
                            ? null
                            : () => _placeOrder(cartState),

                        child: orderState.status == OrderViewStatus.loading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                'Place Order',
                                style: TextStyle(fontSize: 16),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildOrderSummary(cartState) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Order Summary',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            ...cartState.cart!.items.map(
              (item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '${item.product?.title ?? 'Product'} x${item.quantity}',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      'Rs. ${(item.price * item.quantity).toStringAsFixed(2)}',
                    ),
                  ],
                ),
              ),
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Rs. ${cartState.cart!.total.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShippingForm() {
    return Column(
      children: [
        TextFormField(
          controller: _fullNameController,
          decoration: const InputDecoration(
            labelText: 'Full Name',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your full name';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _phoneController,
          decoration: const InputDecoration(
            labelText: 'Phone Number',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your phone number';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _addressController,
          decoration: const InputDecoration(
            labelText: 'Address',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your address';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _cityController,
                decoration: const InputDecoration(
                  labelText: 'City',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Required';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: _zipCodeController,
                decoration: const InputDecoration(
                  labelText: 'Zip Code',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Required';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _stateController,
          decoration: const InputDecoration(
            labelText: 'State/Province (Optional)',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _countryController,
          decoration: const InputDecoration(
            labelText: 'Country',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Required';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildPaymentMethod() {
    return Column(
      children: [
        RadioListTile<PaymentMethod>(
          title: const Text('Cash on Delivery'),
          value: PaymentMethod.cashOnDelivery,
          groupValue: _selectedPaymentMethod,
          onChanged: (value) => setState(() => _selectedPaymentMethod = value!),
        ),
        RadioListTile<PaymentMethod>(
          title: const Text('Card Payment'),
          subtitle: const Text('Coming soon'),
          value: PaymentMethod.card,
          groupValue: _selectedPaymentMethod,
          onChanged: null, // Disabled for now
        ),
        RadioListTile<PaymentMethod>(
          title: const Text('Online Payment'),
          subtitle: const Text('Coming soon'),
          value: PaymentMethod.online,
          groupValue: _selectedPaymentMethod,
          onChanged: null, // Disabled for now
        ),
      ],
    );
  }

  void _placeOrder(cartState) {
    if (!_formKey.currentState!.validate()) return;

    final cart = cartState.cart!;

    // Convert cart items to order items
    final orderItems = cart.items
        .map<OrderItemEntity>(
          (item) => OrderItemEntity(
            productId: item.productId,
            productName: item.product?.title ?? 'Product',
            productImage: item.product?.images,
            quantity: item.quantity,
            price: item.price,
            sellerId:
                item.product?.sellerId ??
                '', // Assuming product has userId as sellerId
          ),
        )
        .toList();

    // Create shipping address
    final shippingAddress = ShippingAddressEntity(
      fullName: _fullNameController.text,
      phone: _phoneController.text,
      address: _addressController.text,
      city: _cityController.text,
      state: _stateController.text.isEmpty ? '' : _stateController.text,
      zipCode: _zipCodeController.text,
      country: _countryController.text,
    );

    // Create order entity
    final order = OrderEntity(
      orderNumber: '', // Backend will generate
      items: orderItems,
      shippingAddress: shippingAddress,
      paymentMethod: _selectedPaymentMethod,
      subtotal: cart.total,
      total: cart.total,
      status: OrderStatus.pending,
      notes: _notesController.text.isEmpty ? '' : _notesController.text,
    );

    // Create order
    ref.read(orderViewModelProvider.notifier).createOrder(order);
  }
}
