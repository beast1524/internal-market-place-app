import 'package:flutter/material.dart';
import 'edit_profile_page.dart';
import 'sell_listing_page.dart';
import 'my_listings_page.dart';
import 'history_page.dart';




class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  // 0:Home, 1:Wishlist, 2:Sell, 3:My Listings, 4:Account
  int _bottomNavIndex = 4;
  HistoryFilter _historyFilter = HistoryFilter.bought;

  // Profile data stored in state (later: load/save with Supabase)
  String _name = 'John Doe';
  String _email = 'john.doe@company.com';
  String? _phone;
  String? _department;
  String? _location;

  // Dummy history data for now. Later: replace with Supabase queries.
  final List<Map<String, dynamic>> _history = [
    {
      'title': 'Noise Cancelling Headphones',
      'type': HistoryFilter.bought,
      'date': '2025-12-01',
      'amount': 3500.0,
    },
    {
      'title': 'Ergonomic Chair',
      'type': HistoryFilter.sold,
      'date': '2025-11-28',
      'amount': 2500.0,
    },
    {
      'title': 'Old Books Set',
      'type': HistoryFilter.donated,
      'date': '2025-11-15',
      'amount': 0.0,
    },
    {
      'title': 'Desk Lamp',
      'type': HistoryFilter.bought,
      'date': '2025-11-10',
      'amount': 600.0,
    },
  ];

  // --------- BOTTOM NAVIGATION ---------

  void _onBottomNavTap(int index) {
    if (index == _bottomNavIndex) return;

    setState(() => _bottomNavIndex = index);

    if (index == 2) {
      // Sell
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const SellListingPage()),
      );
    } else if (index == 3) {
      // My Listings
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MyListingsPage()),
      );
    } else {
      // Home / Wishlist not implemented yet
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Navigation for this tab is not implemented yet. (TODO)'),
        ),
      );
    }
  }

  // --------- PROFILE EDIT ---------

  void _onEditProfile() async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (_) => EditProfilePage(
          name: _name,
          email: _email,
          phone: _phone,
          department: _department,
          location: _location,
        ),
      ),
    );

    // Debug: see what comes back
    // Check your debug console when you press Save
    print('EditProfile result: $result');

    if (result != null && mounted) {
      setState(() {
        if (result['name'] != null &&
            (result['name'] as String).trim().isNotEmpty) {
          _name = (result['name'] as String).trim();
        }
        if (result['email'] != null &&
            (result['email'] as String).trim().isNotEmpty) {
          _email = (result['email'] as String).trim();
        }

        final phone = (result['phone'] as String?)?.trim() ?? '';
        _phone = phone.isNotEmpty ? phone : null;

        final dept = (result['department'] as String?)?.trim() ?? '';
        _department = dept.isNotEmpty ? dept : null;

        final loc = (result['location'] as String?)?.trim() ?? '';
        _location = loc.isNotEmpty ? loc : null;
      });
    }
  }

  // --------- HISTORY HELPERS ---------

  

  

  void _openHistory(HistoryFilter filter) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => HistoryPage(
          filter: filter,
          history: _history,
        ),
      ),
    );
  }

  // --------- LOGOUT BOTTOM SHEET ---------

  void _showLogoutOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout from this device'),
              onTap: () {
                Navigator.pop(context);
                _onLogoutThisDevice();
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout from all devices'),
              onTap: () {
                Navigator.pop(context);
                _onLogoutAllDevices();
              },
            ),
            const SizedBox(height: 12),
          ],
        );
      },
    );
  }

  // --------- OTHER ACTIONS ---------

  void _onHelpAndSupport() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Help & Support screen not implemented yet. (TODO)'),
      ),
    );
  }

  void _onLogoutThisDevice() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Logout (this device) not implemented yet. (TODO)'),
      ),
    );
  }

  void _onLogoutAllDevices() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Logout (all devices) not implemented yet. (TODO)'),
      ),
    );
  }

  // --------- UI ---------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---------- PROFILE SECTION ----------
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      child: Text(
                        _name.isNotEmpty ? _name[0].toUpperCase() : '?',
                        style: const TextStyle(fontSize: 32),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _email,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    if (_department != null && _department!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        _department!,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                    if (_location != null && _location!.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        _location!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    TextButton.icon(
                      onPressed: _onEditProfile,
                      icon: const Icon(Icons.edit),
                      label: const Text('Edit profile'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // ---------- BUY / SELL / DONATE CARDS ----------
              Text(
                'History',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),

              Row(
                children: [
                  Expanded(
                    child: Card(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () {
                          setState(() {
                            _historyFilter = HistoryFilter.bought;
                          });
                          _openHistory(HistoryFilter.bought);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 8,
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.shopping_cart,
                                color: _historyFilter == HistoryFilter.bought
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.grey,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Buy',
                                style: TextStyle(
                                  fontWeight:
                                      _historyFilter == HistoryFilter.bought
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Card(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () {
                          setState(() {
                            _historyFilter = HistoryFilter.sold;
                          });
                          _openHistory(HistoryFilter.sold);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 8,
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.sell,
                                color: _historyFilter == HistoryFilter.sold
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.grey,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Sell',
                                style: TextStyle(
                                  fontWeight:
                                      _historyFilter == HistoryFilter.sold
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Card(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () {
                          setState(() {
                            _historyFilter = HistoryFilter.donated;
                          });
                          _openHistory(HistoryFilter.donated);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 8),
                          child: Column(
                            children: [
                              Icon(
                                Icons.volunteer_activism,
                                color: _historyFilter == HistoryFilter.donated
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.grey,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Donate',
                                style: TextStyle(
                                  fontWeight:
                                      _historyFilter == HistoryFilter.donated
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

            

              // ---------- ACCOUNT SETTINGS ----------
              Text(
                'Account Settings',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),

              Card(
                child: ListTile(
                  leading: const Icon(Icons.help_outline),
                  title: const Text('Help & Support'),
                  onTap: _onHelpAndSupport,
                ),
              ),
              const SizedBox(height: 4),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Logout'),
                  onTap: _showLogoutOptions,
                ),
              ),
            ],
          ),
        ),
      ),

      // ---------- BOTTOM NAVIGATION ----------
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
