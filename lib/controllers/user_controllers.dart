import 'package:get/get.dart';
import 'package:user_directory/services/api_servies.dart';
import '../models/user_model.dart';

class UserController extends GetxController {
  var users = <UserModel>[].obs;
  var filteredUsers = <UserModel>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  // ✅ Reactive search query
  var searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUsers();

    // ✅ Debounce search input to avoid frequent filtering
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

      final response = await ApiService.fetchUsers(results: 20);
      users.value = response.results;
      
      // ✅ Apply current search after fetching
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

  // ✅ Public method to update search query
  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  // ✅ PRIVATE: Called via debounce to prevent UI rebuilds
  void _performSearch(String query) {
    final searchLower = query.toLowerCase().trim();

    if (searchLower.isEmpty) {
      filteredUsers.value = List.from(users);
    } else {
      filteredUsers.value = users.where((user) {
        final fullName = user.fullName.toLowerCase();
        final email = user.email.toLowerCase();
        final username = user.login.username.toLowerCase();

        return fullName.contains(searchLower) ||
               email.contains(searchLower) ||
               username.contains(searchLower);
      }).toList();
    }
  }
}