// widgets/user_card.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user_directory/controllers/user_controllers.dart';
import '../models/user_model.dart';

class UserCard extends StatelessWidget {
  final UserModel user;
  final int index;

  const UserCard({super.key, required this.user, required this.index});

  @override
  Widget build(BuildContext context) {
    final userController = Get.find<UserController>();
    final isLocal = userController.isLocalUser(user.id);
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              isLocal ? Colors.green.shade50 : Colors.white,
              isLocal ? Colors.green.shade100 : Colors.grey.shade50,
            ],
          ),
          border: isLocal 
            ? Border.all(color: Colors.green.shade300, width: 2)
            : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // User Avatar (using initials since JSONPlaceholder doesn't have images)
              Hero(
                tag: 'user_avatar_${user.id}',
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.blue.shade300,
                        Colors.blue.shade600,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      _getInitials(user.name),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // User Info
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name with local indicator
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            user.displayName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isLocal) ...[
                          const SizedBox(width: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.shade600,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'LOCAL',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Username
                    Row(
                      children: [
                        Icon(
                          Icons.alternate_email,
                          size: 14,
                          color: Colors.purple.shade600,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            '@${user.username}',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.purple.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Email
                    Row(
                      children: [
                        Icon(
                          Icons.email_outlined,
                          size: 16,
                          color: Colors.blue.shade600,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            user.email,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade700,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Location
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 16,
                          color: Colors.orange.shade600,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            user.address.city,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Company
                    Row(
                      children: [
                        Icon(
                          Icons.business_outlined,
                          size: 14,
                          color: Colors.teal.shade600,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            user.company.name,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.teal.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Action Buttons
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Contact button
                  IconButton(
                    onPressed: () {
                      _showContactOptions(context);
                    },
                    icon: Icon(Icons.phone, color: Colors.green.shade600),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.green.shade50,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  
                  // Delete button for local users
                  if (isLocal) ...[
                    IconButton(
                      onPressed: () {
                        _showDeleteDialog(context, userController);
                      },
                      icon: Icon(Icons.delete_outline, color: Colors.red.shade600),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.red.shade50,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ] else ...[
                    // User ID for API users
                    Text(
                      '#${user.id}',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getInitials(String name) {
    final names = name.split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    } else if (names.isNotEmpty) {
      return names[0][0].toUpperCase();
    }
    return 'U';
  }

  void _showContactOptions(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.blue[50],
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Contact ${user.name}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              tileColor: Colors.white,
              leading: Icon(Icons.phone, color: Colors.green.shade600),
              title: Text(user.phone),
              subtitle: const Text('Phone'),
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.grey.shade300, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              onTap: () {
                Navigator.pop(context);
                // Implement phone call functionality
              },
            ),
            const SizedBox(height: 10),
            ListTile(
              tileColor: Colors.white,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.grey.shade300, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              leading: Icon(Icons.email, color: Colors.orange.shade600),
              title: Text(user.email),
              subtitle: const Text('Email'),
              onTap: () {
                Navigator.pop(context);
                // Implement email functionality
              },
            ),
            const SizedBox(height: 10),
            ListTile(
              tileColor: Colors.white,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.grey.shade300, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              leading: Icon(Icons.web, color: Colors.blue.shade600),
              title: Text(user.website),
              subtitle: const Text('Website'),
              onTap: () {
                Navigator.pop(context);
                // Implement website opening functionality
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, UserController controller) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete User'),
        content: Text('Are you sure you want to delete ${user.name}?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              controller.removeUser(user.id);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}