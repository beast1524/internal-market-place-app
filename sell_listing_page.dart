import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'my_listings_page.dart';
import 'account_page.dart';
import 'package:flutter/services.dart';


/// Types of listing the user can create.
enum ListingType { sell, rent, donation }

class SellListingPage extends StatefulWidget {
  const SellListingPage({super.key});

  @override
  State<SellListingPage> createState() => _SellListingPageState();
}

class _SellListingPageState extends State<SellListingPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _locationController = TextEditingController();

  String? _selectedCategory;
  String? _selectedCondition;
  bool _isSubmitting = false;

  ListingType _selectedListingType = ListingType.sell;

  final List<XFile> _images = [];
  final ImagePicker _picker = ImagePicker();

  final List<String> _categories = [
    'Electronics',
    'Furniture',
    'Books',
    'Vehicles',
    'Office Items',
    'Others',
  ];

  final List<String> _conditions = [
    'New',
    'Like New',
    'Good',
    'Fair',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final picked = await _picker.pickMultiImage(
      imageQuality: 80,
    );

    // With newer image_picker, result is never null.
    if (picked.isNotEmpty) {
      setState(() {
        _images
          ..clear()
          ..addAll(picked);
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (_images.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one image')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      // Get price depending on listing type
      final double price = _selectedListingType == ListingType.donation
          ? 0.0
          : double.parse(_priceController.text.trim());

      // Example payload (later send this to Supabase)
      final payload = {
        'title': _titleController.text.trim(),
        'description': _descriptionController.text.trim(),
        'price': price,
        'category': _selectedCategory,
        'condition': _selectedCondition,
        'location': _locationController.text.trim(),
        'type': _selectedListingType.name, // 'sell' | 'rent' | 'donation'
        // 'images': _images, // you will upload and store URLs later
      };

      // TODO: replace this with a call to your Supabase repository
      // e.g. await ListingsRepository.createListing(payload, _images);

      await Future.delayed(const Duration(seconds: 1)); // fake API call

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Listing created successfully!')),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  // -------- BOTTOM NAVIGATION --------

  int _bottomNavIndex = 2; // 0:Home, 1:Wishlist, 2:Sell, 3:My Listings, 4:Account

  void _onBottomNavTap(int index) {
  if (index == _bottomNavIndex) return;

  setState(() {
    _bottomNavIndex = index;
  });

  if (index == 3) {
    // My Listings
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MyListingsPage()),
    );
  } else if (index == 4) {
    // Account
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const AccountPage()),
    );
  } else {
    // TODO: implement Home / Wishlist pages
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content:
            Text('Navigation for this tab is not implemented yet. (TODO)'),
      ),
    );
  }
}


  // -------- UI --------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sell an Item'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    hintText: 'e.g. Office Chair, Monitor, Laptop',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),

                // Description
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    hintText:
                        'Add details like condition, age, reason for selling',
                  ),
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),

                // ---- LISTING TYPE: Sell / Rent / Donation ----
                Text(
                  'Listing Type',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    ChoiceChip(
                      label: const Text('Sell'),
                      selected: _selectedListingType == ListingType.sell,
                      onSelected: (selected) {
                        if (!selected) return;
                        setState(() {
                          _selectedListingType = ListingType.sell;
                        });
                      },
                    ),
                    ChoiceChip(
                      label: const Text('Rent'),
                      selected: _selectedListingType == ListingType.rent,
                      onSelected: (selected) {
                        if (!selected) return;
                        setState(() {
                          _selectedListingType = ListingType.rent;
                        });
                      },
                    ),
                    ChoiceChip(
                      label: const Text('Donation'),
                      selected: _selectedListingType == ListingType.donation,
                      onSelected: (selected) {
                        if (!selected) return;
                        setState(() {
                          _selectedListingType = ListingType.donation;
                          _priceController.clear(); // clear price when donation
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Price (disabled for donation)
                TextFormField(
                  controller: _priceController,
                  decoration: InputDecoration(
                    labelText: 'Price',
                    prefixText: '₹ ',
                    hintText: _selectedListingType == ListingType.donation
                        ? 'Price disabled for donation'
                        : 'Enter price or 0 if free',
                  ),
                  enabled: _selectedListingType != ListingType.donation,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                      // Allows digits only
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    validator: (value) {
                      if (_selectedListingType == ListingType.donation) return null;
                      if (value == null || value.trim().isEmpty) {
                          return 'Please enter a price';
                      }
                      return null;
                    },
                  ),

                const SizedBox(height: 12),

                // Category
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Category',
                  ),
                  initialValue: _selectedCategory,
                  items: _categories
                      .map(
                        (c) => DropdownMenuItem(
                          value: c,
                          child: Text(c),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a category';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),

                // Condition
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Condition',
                  ),
                  initialValue: _selectedCondition,
                  items: _conditions
                      .map(
                        (c) => DropdownMenuItem(
                          value: c,
                          child: Text(c),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCondition = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select item condition';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),

                // Location (optional)
                TextFormField(
                  controller: _locationController,
                  decoration: const InputDecoration(
                    labelText: 'Pickup Location (optional)',
                    hintText: 'e.g. Building A, 3rd floor, Desk 42',
                  ),
                ),
                const SizedBox(height: 16),

                // Images
                Text(
                  'Images',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: _pickImages,
                      icon: const Icon(Icons.photo_library),
                      label: const Text('Add Images'),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      _images.isEmpty
                          ? 'No images selected'
                          : '${_images.length} image(s) selected',
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (_images.isNotEmpty)
                  SizedBox(
                    height: 90,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _images.length,
                      separatorBuilder: (_, i) =>
                          const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            File(_images[index].path),
                            width: 90,
                            height: 90,
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    ),
                  ),

                const SizedBox(height: 24),

                // Submit button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _submitForm,
                    child: _isSubmitting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Post Listing'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      // -------- BOTTOM NAV BAR --------
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _bottomNavIndex,
        onTap: _onBottomNavTap,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            activeIcon: Icon(Icons.favorite),
            label: 'Wishlist',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            activeIcon: Icon(Icons.add_circle),
            label: 'Sell',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_outlined),
            activeIcon: Icon(Icons.list),
            label: 'My Listings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}
