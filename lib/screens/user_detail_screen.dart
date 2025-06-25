// screens/user_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:user_directory/controllers/user_controllers.dart';
import '../models/user_model.dart';

class UserDetailScreen extends StatelessWidget {
  final UserModel user;

  const UserDetailScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final userController = Get.find<UserController>();
    final isLocal = userController.isLocalUser(user.id);

    return Scaffold(
      backgroundColor: Colors.blue.shade50.withValues(alpha: 0.95),
      body: CustomScrollView(
        slivers: [
          // App Bar with User Avatar
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            backgroundColor: Colors.blue[700],
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                user.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.blue[800]!, Colors.blue[600]!],
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      Hero(
                        tag: 'user_avatar_${user.id}',
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.white.withOpacity(0.9),
                                Colors.white.withOpacity(0.7),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              _getInitials(user.name),
                              style: TextStyle(
                                color: Colors.blue[700],
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (isLocal)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green[600],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'LOCAL USER',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // User Details Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Personal Information Card
                  _buildInfoCard(
                    title: 'Personal Information',
                    icon: Icons.person,
                    color: Colors.blue,
                    children: [
                      _buildInfoRow(
                        Icons.person_outline,
                        'Full Name',
                        user.name,
                        Colors.blue[600]!,
                      ),
                      _buildInfoRow(
                        Icons.alternate_email,
                        'Username',
                        '@${user.username}',
                        Colors.purple[600]!,
                      ),
                      _buildInfoRow(
                        Icons.badge_outlined,
                        'User ID',
                        '#${user.id}',
                        Colors.grey[600]!,
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Contact Information Card
                  _buildInfoCard(
                    title: 'Contact Information',
                    icon: Icons.contact_phone,
                    color: Colors.green,
                    children: [
                      _buildInfoRow(
                        Icons.email_outlined,
                        'Email Address',
                        user.email,
                        Colors.green[600]!,
                        onTap: () => _launchEmail(user.email),
                      ),
                      _buildInfoRow(
                        Icons.phone_outlined,
                        'Phone Number',
                        user.phone,
                        Colors.green[600]!,
                        onTap: () => _launchPhone(user.phone),
                      ),
                      _buildInfoRow(
                        Icons.web_outlined,
                        'Website',
                        user.website,
                        Colors.green[600]!,
                        onTap: () => _launchWebsite(user.website),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Address Information Card
                  _buildInfoCard(
                    title: 'Address Information',
                    icon: Icons.location_on,
                    color: Colors.orange,
                    children: [
                      _buildInfoRow(
                        Icons.home_outlined,
                        'Street',
                        user.address.street,
                        Colors.orange[600]!,
                      ),
                      _buildInfoRow(
                        Icons.location_city_outlined,
                        'City',
                        user.address.city,
                        Colors.orange[600]!,
                      ),
                      _buildInfoRow(
                        Icons.markunread_mailbox_outlined,
                        'Zipcode',
                        user.address.zipcode,
                        Colors.orange[600]!,
                      ),
                      _buildInfoRow(
                        Icons.map_outlined,
                        'Coordinates',
                        '${user.address.geo.lat}, ${user.address.geo.lng}',
                        Colors.orange[600]!,
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Company Information Card
                  _buildInfoCard(
                    title: 'Company Information',
                    icon: Icons.business,
                    color: Colors.teal,
                    children: [
                      _buildInfoRow(
                        Icons.business_outlined,
                        'Company Name',
                        user.company.name,
                        Colors.teal[600]!,
                      ),
                      _buildInfoRow(
                        Icons.lightbulb_outline,
                        'Catch Phrase',
                        user.company.catchPhrase,
                        Colors.teal[600]!,
                      ),
                      _buildInfoRow(
                        Icons.description_outlined,
                        'Business',
                        user.company.bs,
                        Colors.teal[600]!,
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Action Buttons
                  if (isLocal)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => _showDeleteDialog(context, userController),
                        icon: const Icon(Icons.delete_outline),
                        label: const Text('Delete User'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[600],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required IconData icon,
    required Color color,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 0,
      color: Colors.blue.shade50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value,
    Color color, {
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      value,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              if (onTap != null)
                Icon(
                  Icons.open_in_new,
                  color: color,
                  size: 16,
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

  void _launchEmail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      Get.snackbar(
        'Error',
        'Could not launch email app',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void _launchPhone(String phone) async {
    final Uri phoneUri = Uri(
      scheme: 'tel',
      path: phone,
    );
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      Get.snackbar(
        'Error',
        'Could not launch phone app',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void _launchWebsite(String website) async {
    String url = website;
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      url = 'https://$url';
    }
    
    final Uri websiteUri = Uri.parse(url);
    if (await canLaunchUrl(websiteUri)) {
      await launchUrl(websiteUri, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar(
        'Error',
        'Could not launch website',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void _showDeleteDialog(BuildContext context, UserController controller) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('Delete User'),
        content: Text('Are you sure you want to delete ${user.name}? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              controller.removeUser(user.id);
              Get.back(); // Close dialog
              Get.back(); // Go back to list
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}