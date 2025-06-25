// controllers/user_controller.dart
import 'package:get/get.dart';
import 'package:user_directory/services/api_servies.dart';

import '../models/user_model.dart';

class UserController extends GetxController {
  var users = <UserModel>[].obs;
  var filteredUsers = <UserModel>[].obs;
  var localUsers = <UserModel>[].obs; // For locally added users
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  // Reactive search query
  var searchQuery = ''.obs;

  // Counter for generating IDs for new users
  int _nextLocalId = 1000;

  @override
  void onInit() {
    super.onInit();
    fetchUsers();

    // Debounce search input to avoid frequent filtering
    debounce(
      searchQuery,
      (query) => _performSearch(query),
      time: const Duration(milliseconds: 300),
    );
  }

  Future<void> fetchUsers() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final fetchedUsers = await ApiService.fetchUsers();
      users.value = fetchedUsers;
      
      // Combine API users with locally added users
      _combineUsers();
      
      // Apply current search after fetching
      _performSearch(searchQuery.value);
      
    } catch (e) {
      errorMessage.value = e.toString();
      print('Error fetching users: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshUsers() async {
    await fetchUsers();
  }

  // Public method to update search query
  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  // Add new user locally
  void addUser(NewUserModel newUser) {
  
    final userModel = newUser.toUserModel(_nextLocalId++);
    localUsers.add(userModel);
    
    // Recombine and refresh filtered list
    _combineUsers();
    _performSearch(searchQuery.value);
     Get.back();
    Get.snackbar(
      'Success',
      'User ${userModel.name} added successfully!',
      snackPosition: SnackPosition.BOTTOM,
    );
    
  }

  // Remove user (only locally added users can be removed)
  void removeUser(int userId) {
    localUsers.removeWhere((user) => user.id == userId);
    _combineUsers();
    _performSearch(searchQuery.value);
    
   
    
  }

  // Get user by ID
  UserModel? getUserById(int id) {
    final allUsers = [...users, ...localUsers];
    try {
      return allUsers.firstWhere((user) => user.id == id);
    } catch (e) {
      return null;
    }
  }

  // Check if user is locally added (can be edited/deleted)
  bool isLocalUser(int userId) {
    return localUsers.any((user) => user.id == userId);
  }

  // Private method to combine API and local users
  void _combineUsers() {
    final allUsers = <UserModel>[];
    allUsers.addAll(users);
    allUsers.addAll(localUsers);
    
    // Update the filtered list if no search is active
    if (searchQuery.value.isEmpty) {
      filteredUsers.value = allUsers;
    }
  }

  // PRIVATE: Called via debounce to prevent UI rebuilds
  void _performSearch(String query) {
    final searchLower = query.toLowerCase().trim();
    final allUsers = [...users, ...localUsers];

    if (searchLower.isEmpty) {
      filteredUsers.value = allUsers;
    } else {
      filteredUsers.value = allUsers.where((user) {
        final fullName = user.fullName.toLowerCase();
        final email = user.email.toLowerCase();
        final username = user.username.toLowerCase();
        final company = user.company.name.toLowerCase();
        final phone = user.phone.toLowerCase();

        return fullName.contains(searchLower) ||
               email.contains(searchLower) ||
               username.contains(searchLower) ||
               company.contains(searchLower) ||
               phone.contains(searchLower);
      }).toList();
    }
  }
}