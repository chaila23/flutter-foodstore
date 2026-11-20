import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_foodstore/bloc/auth/auth_bloc.dart';
import 'package:go_router/go_router.dart';

class _TabItem {
  final String path;
  final String label;
  final IconData icon;
  const _TabItem(this.path, this.label, this.icon);
}

class DashboardPage extends StatefulWidget {
  final Widget child;
  const DashboardPage({super.key, required this.child});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final TextEditingController _searchController = TextEditingController();

  static const _tabs = <_TabItem>[
    _TabItem('/dashboard/home', 'Home', Icons.home),
    _TabItem('/dashboard/order', 'My Orders', Icons.shopping_bag),
    _TabItem('/dashboard/cart', 'Cart', Icons.shopping_cart),
    _TabItem('/dashboard/profile', 'Account', Icons.person),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final isLoggedIn = context.watch<AuthBloc>().state.maybeWhen(
          authenticated: () => true,
          orElse: () => false,
        );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        toolbarHeight: 72,
        titleSpacing: 16,
        title: _buildSearchField(),
        actions: [
          isLoggedIn ? _buildLogoutButton(context) : _buildLoginButton(context),
          const SizedBox(width: 8),
        ],
      ),
      body: widget.child,
      bottomNavigationBar: _bottomNav(context, location),
    );
  }

  /// Search Field di App Bar
  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      textInputAction: TextInputAction.search,
      onSubmitted: (query) {
        final keyword = query.trim();
        if (keyword.isNotEmpty) {
          context
              .push('/search?query=${Uri.encodeQueryComponent(keyword)}')
              .then((_) {
            _searchController.clear();
          });
        }
      },
      decoration: InputDecoration(
        hintText: 'Search food...',
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return IconButton(
      onPressed: () {
        context.go('/login');
      },
      icon: const Icon(Icons.login_rounded),
      color: Colors.white,
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return IconButton(
      onPressed: () {
        // Logout user
        context.read<AuthBloc>().add(const AuthEvent.logoutRequested());
        context.go('/login');
      },
      icon: const Icon(Icons.logout_rounded),
      color: Colors.white,
    );
  }

  Widget _bottomNav(BuildContext context, String location) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 10),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: _tabs.map((tab) {
            final selected = location.startsWith(tab.path);
            return InkWell(
              onTap: () => context.go(tab.path),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                    decoration: BoxDecoration(
                      color: selected ? Colors.orange : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      tab.icon,
                      color: selected ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    tab.label,
                    style: const TextStyle(fontSize: 12, color: Colors.black87),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}