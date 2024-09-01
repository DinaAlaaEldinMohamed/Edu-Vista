import 'dart:io'; // Import this for File
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_vista/cubit/auth_cubit.dart';
import 'package:edu_vista/screens/layout/base_layout.dart';
import 'package:edu_vista/utils/colors_utils.dart';
import 'package:edu_vista/utils/images_utils.dart';
import 'package:edu_vista/utils/text_utility.dart';
import 'package:edu_vista/widgets/app/appButtons/app_elvated_btn.dart';
import 'package:edu_vista/widgets/app/app_text_form_field.widget.dart';
import 'package:edu_vista/widgets/app/cart_icon_btn.widget.dart';
import 'package:edu_vista/widgets/app/custom_expansion_tile.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  static const String route = '/profile';

  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final AuthCubit _authCubit;
  late User? _user;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _authCubit = BlocProvider.of<AuthCubit>(context);
    _user = FirebaseAuth.instance.currentUser;
    _nameController.text = _user?.displayName ?? '';
    _fetchUserPhoneNumber();
  }

  Future<void> _fetchUserPhoneNumber() async {
    if (_user != null) {
      final userRef =
          FirebaseFirestore.instance.collection('users').doc(_user!.uid);

      final userDoc = await userRef.get();
      if (userDoc.exists) {
        _phoneController.text = userDoc['phoneNumber'] ?? '';
      }
    }
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _authCubit.pickImage();
    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);
      await _authCubit.updateProfileImage(
        context: context,
        imageFile: imageFile,
      );
    }
  }

  void _updateUserData() {
    if (_formKey.currentState?.validate() ?? false) {
      _authCubit.updateUserData(
        name: _nameController.text,
        phone: _phoneController.text,
        password: _passwordController.text,
        context: context,
      );
    }
  }

  Future<void> _logOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacementNamed(
          context, '/login'); // Navigate to login screen
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error logging out: ${e.toString()}'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      changeAppbar: true,
      customAppBar: AppBar(
        title: const Center(
            child: Text('Profile', style: TextUtils.headlineStyle)),
        actions: const [CartIconButton()],
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is UpdateUserSuccess) {
            // Refresh user data
            setState(() {
              _user = state.user;
            });
          } else if (state is UpdateUserFailed) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error updating user data: ${state.error}'),
              ),
            );
          }

          if (state is ProfileImageUploaded) {
            // Refresh user data
            setState(() {
              _user = FirebaseAuth.instance.currentUser;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Colors.green,
                content: Text('Profile image updated successfully'),
              ),
            );
          } else if (state is ProfileImageFailed) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error updating profile image: ${state.error}'),
              ),
            );
          }
        },
        builder: (context, state) {
          return Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(
                        radius: 100,
                        backgroundImage: _user?.photoURL != null
                            ? NetworkImage(_user!.photoURL!)
                            : const AssetImage('assets/images/user.png')
                                as ImageProvider,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 15,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: ColorUtility.primaryColor,
                              width: 1,
                            ),
                          ),
                          child: IconButton(
                            icon: Image.asset(
                              ImagesUtils.pickImageIcon,
                            ),
                            onPressed: _pickImage,
                          ),
                        ),
                      ),
                      if (state is ProfileImageUploading)
                        const Positioned(
                          child: CircularProgressIndicator(),
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(_user?.displayName ?? 'No Name',
                      style: TextUtils.headlineStyle),
                  Text(_user?.email ?? 'No Email',
                      style: TextUtils.subheadline),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Form(
                          key: _formKey,
                          child: CustomExpansionTile(title: 'Edit', children: [
                            AppTextFormField(
                              hintText: 'Name',
                              labelText: 'Name',
                              controller: _nameController,
                              validator: (value) => value?.isEmpty ?? true
                                  ? 'Name cannot be empty'
                                  : null,
                            ),
                            AppTextFormField(
                              hintText: 'Phone',
                              labelText: 'Phone',
                              controller: _phoneController,
                              validator: (value) => value?.isEmpty ?? true
                                  ? 'Phone cannot be empty'
                                  : null,
                            ),
                            AppTextFormField(
                                hintText: '********************',
                                labelText: 'Password',
                                controller: _passwordController,
                                obscureText: true,
                                validator: (value) => value!.isNotEmpty
                                    ? value.length < 10
                                        ? 'short password'
                                        : null
                                    : null),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AppElvatedBtn(
                                    onPressed: () {
                                      _formKey.currentState?.reset();
                                    },
                                    title: 'Cancel',
                                    backgroundColor: Colors.red,
                                  ),
                                  const SizedBox(width: 8),
                                  AppElvatedBtn(
                                    onPressed: _updateUserData,
                                    title: 'Update',
                                  ),
                                ],
                              ),
                            )
                          ]),
                        ),
                        const CustomExpansionTile(
                            title: 'Setting', children: []),
                        const CustomExpansionTile(
                            title: 'Achievements', children: []),
                        const CustomExpansionTile(
                            title: 'About Us', children: []),
                      ],
                    ),
                  ),
                  TextButton(
                      onPressed: _logOut,
                      child: const Text(
                        'Log Out',
                        style: TextStyle(color: Colors.red),
                      ))
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
