import 'package:get/get.dart';
import 'package:user_directory/services/api_servies.dart';
import '../models/user_model.dart';


class UserController extends GetxController {
  // Observable variables
  var isLoading = false.obs;
  var users = <UserModel>[].obs;
  var filteredUsers = <UserModel>[].obs;
  var searchQuery = ''.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  // Fetch users from API
  Future<void> fetchUsers() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final userResponse = await ApiService.fetchUsers();
      users.value = userResponse.data;
      filteredUsers.value = userResponse.data;
      
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // Search functionality
  void searchUsers(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredUsers.value = users;
    } else {
      filteredUsers.value = users
          .where((user) =>
              user.fullName.toLowerCase().contains(query.toLowerCase()) ||
              user.email.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  // Refresh users
  Future<void> refreshUsers() async {
    await fetchUsers();
  }
}
