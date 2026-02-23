import 'package:flutter/material.dart';

class AddReviewDialog extends StatefulWidget {
  final Function(int rating, String comment) onSubmit;
  final int? initalRating;
  final String? initialComment;
  const AddReviewDialog({
    super.key,
    required this.onSubmit,
    this.initalRating,
    this.initialComment,
  });

  @override
  State<AddReviewDialog> createState() => _AddReviewDialogState();
}

class _AddReviewDialogState extends State<AddReviewDialog> {
  int _rating = 0;
  TextEditingController? _commentController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _rating = widget.initalRating ?? 0;
    _commentController = TextEditingController(text: widget.initialComment);
  }

  @override
  void dispose() {
    _commentController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.initalRating != null ? 'Edit Review' : 'Add Review'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Rating', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  onPressed: () {
                    setState(() {
                      _rating = index + 1;
                    });
                  },
                  icon: Icon(
                    index < _rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 32,
                  ),
                );
              }),
            ),
            const SizedBox(height: 16),
            const Text(
              'Comment',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _commentController!,
              maxLines: 4,
              maxLength: 500,
              decoration: const InputDecoration(
                hintText: 'Write your review here...',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a commment';
                }
                if (value.trim().length < 10) {
                  return 'Comment must be at least 10 characters';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate() && _rating > 0) {
              widget.onSubmit(_rating, _commentController!.text.trim());
              Navigator.pop(context);
            } else if (_rating == 0) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please select a rating')),
              );
            }
          },
          child: const Text('Submit'),
        ),
      ],
    );
  }
}
