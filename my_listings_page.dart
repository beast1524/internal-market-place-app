import 'package:flutter/material.dart';
import 'sell_listing_page.dart'; // to navigate back to Sell page
import 'account_page.dart';


class MyListingsPage extends StatefulWidget {
  const MyListingsPage({super.key});

  @override
  State<MyListingsPage> createState() => _MyListingsPageState();
}

class _MyListingsPageState extends State<MyListingsPage> {
  // 0:Home, 1:Wishlist, 2:Sell, 3:My Listings, 4:Account
  int _bottomNavIndex = 3;

  // For now we’ll use dummy data. Later: load from Supabase.
  bool _isLoading = true;
  List<Map<String, dynamic>> _myListings = [];

  @override
  void initState() {
    super.initState();
    _loadMyListings();
  }

  Future<void> _loadMyListings() async {
    setState(() {
      _isLoading = true;
    });

    // TODO: Replace this with Supabase query:
    // final userId = Supabase.instance.client.auth.currentUser?.id;
    // final response = await Supabase.instance.client
    //   .from('listings')
    //   .select()
    //   .eq('seller_id', userId)
    //   .order('created_at', ascending: false);

    await Future.delayed(const Duration(milliseconds: 500));

    // Dummy data for now
    _myListings = [
      {
        'title': 'Ergonomic Office Chair',
        'type': 'sell',
        'price': 2500.0,
        'status': 'Active',
        'created_at': DateTime.now().subtract(const Duration(days: 1)),
      },
      {
        'title': 'Mechanical Keyboard',
        'type': 'donation',
        'price': 0.0,
        'status': 'Active',
        'created_at': DateTime.now().subtract(const Duration(days: 3)),
      },
      {
        'title': 'Projector (Meeting Room)',
        'type': 'rent',
        'price': 500.0,
        'status': 'Inactive',
        'created_at': DateTime.now().subtract(const Duration(days: 10)),
      },
    ];

    setState(() {
      _isLoading = false;
    });
  }

  void _onBottomNavTap(int index) {
  if (index == _bottomNavIndex) return;

  setState(() {
    _bottomNavIndex = index;
  });

  if (index == 2) {
    // Sell
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const SellListingPage()),
    );
  } else if (index == 4) {
    // Account
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const AccountPage()),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content:
            Text('Navigation for this tab is not implemented yet. (TODO)'),
      ),
    );
  }
}


  String _typeLabel(String type) {
    switch (type) {
      case 'sell':
        return 'Sell';
      case 'rent':
        return 'Rent';
      case 'donation':
        return 'Donation';
      default:
        return type;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Listings'),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadMyListings,
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _myListings.isEmpty
                  ? const Center(
                      child: Text(
                        'You haven\'t posted any listings yet.',
                        textAlign: TextAlign.center,
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: _myListings.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final item = _myListings[index];
                        final type = item['type'] as String? ?? 'sell';
                        final price = item['price'] as double? ?? 0.0;
                        final status = item['status'] as String? ?? 'Active';

                        return Card(
                          child: ListTile(
                            title: Text(item['title'] as String? ?? ''),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Text(
                                  'Type: ${_typeLabel(type)}',
                                  style: const TextStyle(fontSize: 12),
                                ),
                                if (type != 'donation')
                                  Text(
                                    'Price: ₹${price.toStringAsFixed(0)}',
                                    style: const TextStyle(fontSize: 12),
                                  )
                                else
                                  const Text(
                                    'Donation (Free)',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                Text(
                                  'Status: $status',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: status == 'Active'
                                        ? Colors.green
                                        : Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {
                              // TODO: open listing detail / edit page
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Open details for "${item['title']}" (TODO)'),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
        ),
      ),

      // -------- BOTTOM NAV BAR (same style) --------
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
