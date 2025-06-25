import 'package:flutter/material.dart';
import 'package:user_directory/screens/add_user.dart';
import 'package:user_directory/screens/user_detail_screen.dart';
import 'package:user_directory/screens/user_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/user_controllers.dart';
import '../widgets/user_card.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'User Directory', // Add a title
      initialRoute: '/home', // Use initialRoute instead of home
      getPages: [
        // Define your routes with GetPage
        GetPage(
          name: '/home',
          page: () => HomeScreen(),
          binding: AppBinding(), // Bind the controller for this specific page
        ),
        GetPage(
          name: '/add_user',
          page: () => const AddUserScreen(),
          // No binding needed here unless AddUserScreen also has a specific controller
        ),
        // UserDetailScreen will receive arguments, so its route is typically handled by Get.to() directly.
        // If you need a named route for it:
        // GetPage(
        //   name: '/user_detail',
        //   page: () => UserDetailScreen(user: Get.arguments),
        // ),
      ],
      // initialBinding: AppBinding(), // Removed: Binding now handled per-page
    );
  }
}

// Dependency injection
class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserController>(() => UserController());
  }
}


// screens/home_screen.dart


class HomeScreen extends StatelessWidget {
  final UserController userController = Get.find<UserController>();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: const Text(
          'User Directory',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
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
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () => userController.refreshUsers(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (value) => userController.updateSearchQuery(value),
              decoration: InputDecoration(
                hintText: 'Search users...',
                prefixIcon: Icon(Icons.search, color: Colors.blue[600]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),

          // User List
          Expanded(
            child: Obx(() {
              if (userController.isLoading.value) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Loading users...'),
                    ],
                  ),
                );
              }

              if (userController.errorMessage.value.isNotEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Error loading users',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Text(
                          userController.errorMessage.value,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => userController.refreshUsers(),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              if (userController.filteredUsers.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.person_search,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        userController.searchQuery.value.isEmpty
                            ? 'No users found'
                            : 'No users match your search',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                );
              }

              return LayoutBuilder(
                builder: (context, constraints) {
                  // Responsive layout
                  if (constraints.maxWidth > 1200) {
                    // Desktop: 3 columns
                    return _buildGridView(3);
                  } else if (constraints.maxWidth > 800) {
                    // Tablet: 2 columns
                    return _buildGridView(2);
                  } else {
                    // Mobile: List view
                    return _buildListView();
                  }
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.to(() => const AddUserScreen()),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        icon: const Icon(Icons.person_add),
        label: const Text('Add User'),
      ),
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      itemCount: userController.filteredUsers.length,
      itemBuilder: (context, index) {
        final user = userController.filteredUsers[index];
        return GestureDetector(
          onTap: () => Get.to(() => UserDetailScreen(user: user)),
          child: UserCard(user: user, index: index),
        );
      },
    );
  }

  Widget _buildGridView(int crossAxisCount) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 2.5,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: userController.filteredUsers.length,
      itemBuilder: (context, index) {
        final user = userController.filteredUsers[index];
        return GestureDetector(
          onTap: () => Get.to(() => UserDetailScreen(user: user)),
          child: UserCard(user: user, index: index),
        );
      },
    );
  }
}
