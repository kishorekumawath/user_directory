import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import 'package:user_directory/controllers/user_controllers.dart';
import '../widgets/user_card.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen>
    with TickerProviderStateMixin {
  late AnimationController _searchAnimationController;
  late AnimationController _fabAnimationController;
  late Animation<double> _searchAnimation;
  late Animation<double> _fabAnimation;

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode(); // ✅ Add FocusNode

  // ✅ Get controller instance once to avoid rebuilds
  late final UserController userController;

  @override
  void initState() {
    super.initState();

    // ✅ Initialize controller once
    userController = Get.put(UserController());

    _searchAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _searchAnimation = CurvedAnimation(
      parent: _searchAnimationController,
      curve: Curves.elasticOut,
    );

    _fabAnimation = CurvedAnimation(
      parent: _fabAnimationController,
      curve: Curves.elasticOut,
    );

    Future.delayed(const Duration(milliseconds: 300), () {
      _searchAnimationController.forward();
    });

    Future.delayed(const Duration(milliseconds: 1000), () {
      _fabAnimationController.forward();
    });
  }

  @override
  void dispose() {
    _searchAnimationController.dispose();
    _fabAnimationController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose(); // ✅ Dispose FocusNode
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 800),
          tween: Tween(begin: -100.0, end: 0.0),
          curve: Curves.elasticOut,
          builder: (context, value, child) {
            return Transform.translate(offset: Offset(value, 0), child: child);
          },
          child: const Text(
            'EyeQlytics User Directory',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        backgroundColor: Colors.blue[700],
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.blue[700]!, Colors.blue[500]!],
            ),
          ),
        ),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: [
            // ✅ Search Bar - Wrapped in separate widget to prevent rebuilds
            _buildSearchBar(),

            // User List
            Expanded(
              child: Obx(() {
                if (userController.isLoading.value) {
                  return ListView.builder(
                    padding: const EdgeInsets.only(top: 8, bottom: 64),
                    itemCount: 6, // Number of skeletons
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Shimmer.fromColors(
                          baseColor: Colors.blue.shade100,
                          highlightColor: Colors.blue.shade100.withValues(alpha: 0.5),
                          child: Container(
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }

                if (userController.errorMessage.value.isNotEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 48,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          userController.errorMessage.value,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: userController.refreshUsers,
                          child: const Text("Retry"),
                        ),
                      ],
                    ),
                  );
                }

                if (userController.filteredUsers.isEmpty) {
                  return const Center(
                    child: Text(
                      "No users found.",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: userController.refreshUsers,
                  child: AnimationLimiter(
                    child: ListView.builder(
                      padding: const EdgeInsets.only(top: 8, bottom: 64),
                      itemCount: userController.filteredUsers.length,
                      itemBuilder: (context, index) {
                        return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: const Duration(milliseconds: 500),
                          child: SlideAnimation(
                            verticalOffset: 50.0,
                            child: FadeInAnimation(
                              child: UserCard(
                                user: userController.filteredUsers[index],
                                index: index,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: AnimatedBuilder(
        animation: _fabAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _fabAnimation.value,
            child: FloatingActionButton(
              onPressed: () {
                _fabAnimationController.reverse().then((_) {
                  _fabAnimationController.forward();
                });
                userController.refreshUsers();
              },
              backgroundColor: Colors.blue[600],
              child: const Icon(Icons.refresh, color: Colors.white),
            ),
          );
        },
      ),
    );
  }

  // ✅ Separate search bar widget with proper animation handling
  Widget _buildSearchBar() {
    return AnimatedBuilder(
      animation: _searchAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _searchAnimation.value,
          child: child, // ✅ Use child parameter to prevent TextField rebuilds
        );
      },
      child: Container(
        // ✅ Move TextField to child parameter
        padding: const EdgeInsets.only(left: 16,right: 16, top: 16),
        child: TextField(
          controller: _searchController,
          focusNode: _searchFocusNode,
          onChanged: (value) {
            userController.updateSearchQuery(value);
          },
          decoration: InputDecoration(
            hintText: 'Search users by name or email...',
            prefixIcon: const Icon(Icons.search, color: Colors.blue),
            suffixIcon: Obx(() {
              return userController.searchQuery.value.isNotEmpty
                  ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      userController.updateSearchQuery('');
                      _searchFocusNode.unfocus();
                    },
                  )
                  : const SizedBox.shrink();
            }),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.blue, width: 2),
            ),
          ),
        ),
      ),
    );
  }
}
