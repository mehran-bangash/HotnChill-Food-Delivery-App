import 'package:flutter/material.dart';
import 'package:hotnchill/utils/routes/route_names.dart';
import 'package:hotnchill/view_model/auth_view_model.dart';
import 'package:hotnchill/view_model/user_view_model.dart';
import 'package:provider/provider.dart';
import '../resources/components/first_profile_card.dart';
import '../resources/components/second_profile_card.dart';
import '../utils/utils.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context);
    final authViewModel = Provider.of<AuthViewModel>(context);
    final user = userViewModel.user;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body:
          user == null
              ? const Center(child: CircularProgressIndicator())
              : LayoutBuilder(
                builder: (context, constraints) {
                  bool isWide = constraints.maxWidth > 600;
                  double avatarRadius = isWide ? 100 : 80;
                  double headerHeight = isWide ? 200 : 220;
                  double nameFontSize = isWide ? 32 : 25;
                  double profileCardPadding = isWide ? 24 : 14;

                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            // Background Header
                            Container(
                              height: headerHeight,
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.elliptical(150, 50),
                                  bottomRight: Radius.elliptical(150, 50),
                                ),
                              ),
                            ),

                            // Display Name above Avatar
                            Positioned(
                              top: headerHeight - avatarRadius - 60,
                              left: 0,
                              right: 0,
                              child: Center(
                                child: Text(
                                  "${user.displayName}",
                                  style: TextStyle(
                                    fontFamily: "poppins",
                                    color: Colors.white,
                                    fontSize: nameFontSize,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ),

                            // Profile Image
                            Positioned(
                              top: headerHeight - avatarRadius,
                              left: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () async {
                                  await userViewModel.pickImage();
                                },
                                child: Center(
                                  child: CircleAvatar(
                                    radius: avatarRadius,
                                    backgroundImage:
                                        userViewModel.imageFile != null
                                            ? FileImage(
                                              userViewModel.imageFile!,
                                            )
                                            : user.imageUrl != null
                                            ? NetworkImage(user.imageUrl!)
                                            : const AssetImage(
                                                  'assets/images/default_avatar.png',
                                                )
                                                as ImageProvider,
                                  ),
                                ),
                              ),
                            ),

                            // Update Button
                            Positioned(
                              top: headerHeight + avatarRadius + 10,
                              left: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () async {
                                  try {
                                    if (userViewModel.imageFile == null) {
                                      Utils.flushBarErrorMessage(
                                        "Please select an image.",
                                        context,
                                      );
                                      return;
                                    }
                                    await userViewModel.uploadedProfileImage();
                                    await userViewModel.updateUserDetail();

                                    // Show success message here
                                    Utils.toastMessage(
                                      "Profile image updated successfully!",
                                    );
                                  } catch (e) {
                                    Utils.toastMessage(
                                      "Error: ${e.toString()}",
                                    );
                                  }
                                },

                                child: Center(
                                  child: Container(
                                    height: screenHeight * 0.038,
                                    width: screenWidth * 0.5,
                                    decoration: BoxDecoration(
                                      color: Colors.black87,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(20),
                                      ),
                                    ),
                                    child: Center(
                                      child: const Text(
                                        "Update Profile Image",
                                        style: TextStyle(
                                          fontFamily: "poppins",
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 40),

                        // Profile Details Section
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: profileCardPadding,
                            vertical: 110,
                          ),
                          child: Column(
                            children: [
                              const SizedBox(height: 20),
                              FirstProfileCard(
                                firstTitle: "Name",
                                secondTitle: user.displayName ?? "N/A",
                                icon: Icons.person,
                              ),
                              const SizedBox(height: 20),
                              FirstProfileCard(
                                firstTitle: "Email",
                                secondTitle: user.email ?? "N/A",
                                icon: Icons.email_outlined,
                              ),
                              const SizedBox(height: 20),
                              const SecondProfileCard(
                                title: "Terms and Conditions",
                                icon: Icons.article,
                              ),
                              const SizedBox(height: 20),
                              GestureDetector(
                                onTap: () async {
                                  bool isLoggedOut =
                                      await authViewModel.logout();
                                  if (isLoggedOut) {
                                    Utils.toastMessage("Logout successful!");
                                    // Optionally navigate to login screen
                                    Navigator.pushNamed(
                                      context,
                                      RouteNames.login,
                                    );
                                  } else {
                                    Utils.toastMessage(
                                      "Logout failed. Try again.",
                                    );
                                  }
                                },
                                child: const SecondProfileCard(
                                  title: "Logout",
                                  icon: Icons.power_settings_new,
                                ),
                              ),

                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
    );
  }
}
