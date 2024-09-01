import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_vista/screens/auth/login_screen.dart';
import 'package:edu_vista/screens/home/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final StreamController<User?> _userController =
      StreamController<User?>.broadcast();
  AuthCubit() : super(AuthInitial()) {
    // Initialize user controller
    _userController.add(FirebaseAuth.instance.currentUser);
  }

  final ImagePicker _picker = ImagePicker();

  // Login Method
  Future<void> login({
    required BuildContext context,
    required TextEditingController emailController,
    required TextEditingController passwordController,
  }) async {
    try {
      var credentials = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      if (credentials.user != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.green,
          content: Text(
              'User: ${credentials.user?.displayName} logged in successfully'),
        ));

        emit(LoginSuccess());
        Navigator.pushReplacementNamed(context, HomeScreen.route);
      }
    } on FirebaseAuthException catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.message}'),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Something went wrong'),
        ),
      );
    }
  }

  // SignUp Method
  Future<void> signUp({
    required BuildContext context,
    required TextEditingController nameController,
    required TextEditingController emailController,
    required TextEditingController passwordController,
  }) async {
    try {
      var credentials =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      if (credentials.user != null) {
        credentials.user!.updateDisplayName(nameController.text);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text('Account created successfully'),
          ),
        );

        emit(SignupSuccess());
      }
    } on FirebaseAuthException catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sign up Error: ${e.message}'),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sign up Exception: $e'),
        ),
      );
    }
  }

  // Forgot Password Method
  Future<void> forgotPassword({
    required BuildContext context,
    required TextEditingController emailController,
  }) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailController.text,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text('Password reset email sent successfully'),
        ),
      );
      emit(ForgotPasswordSuccess());
    } on FirebaseAuthException catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.message}'),
        ),
      );
    }
  }

  // Reset Password Method
  Future<void> resetPassword({
    required BuildContext context,
    required String oobCode, // The code from the password reset email
    required TextEditingController newPasswordController,
  }) async {
    try {
      await FirebaseAuth.instance.confirmPasswordReset(
        code: oobCode,
        newPassword: newPasswordController.text,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text('Password reset successfully'),
        ),
      );

      emit(ResetPasswordSuccess());

      Navigator.pushReplacementNamed(context, LoginScreen.route);
    } on FirebaseAuthException catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.message}'),
        ),
      );
    }
  }

  Future<void> updateUserData({
    required String name,
    required String phone,
    String? password,
    required BuildContext context,
  }) async {
    try {
      emit(UpdateUserLoading());

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not logged in');

      // Reauthenticate if needed
      if (password != null && password.isNotEmpty) {
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: password,
        );

        try {
          await user.reauthenticateWithCredential(credential);
        } catch (e) {
          throw Exception('Reauthentication failed: ${e.toString()}');
        }
      }

      // Update profile display name if needed
      if (name.isNotEmpty) {
        await user.updateDisplayName(name);
      }

      // Create or update user document in Firestore
      final userRef =
          FirebaseFirestore.instance.collection('users').doc(user.uid);

      // Check if the document exists
      final userDoc = await userRef.get();
      if (!userDoc.exists) {
        // If not found, create the document with initial data
        await userRef.set({
          'displayName': name,
          'email': user.email,
          'phoneNumber': phone,
        });
      } else {
        // If found, update the document with new data
        await userRef.update({
          'displayName': name,
          'phoneNumber': phone,
        });
      }

      // Update password only if it's not empty
      if (password != null && password.isNotEmpty) {
        await user.updatePassword(password);
      }

      // Refresh user data
      await user.reload();
      final updatedUser = FirebaseAuth.instance.currentUser!;

      // Emit success state and show success message
      emit(UpdateUserSuccess(updatedUser));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text('User data updated successfully'),
        ),
      );
    } catch (e) {
      emit(UpdateUserFailed(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating user data: ${e.toString()}'),
        ),
      );
      print('updated user data error message =======================$e');
    }
  }

  // Method to pick an image
  Future<XFile?> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      return image;
    } catch (e) {
      emit(ProfileImageFailed('Error picking image: $e'));
      return null;
    }
  }

  // Stream to provide updates on the user
  Stream<User?> get userStream => _userController.stream;
  // Method to update profile image
  Future<void> updateProfileImage({
    required BuildContext context,
    required File imageFile,
  }) async {
    try {
      emit(ProfileImageUploading());

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not logged in');

      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_images/${user.uid}.jpg');

      final uploadTask = storageRef.putFile(imageFile);
      await uploadTask;

      final downloadUrl = await storageRef.getDownloadURL();
      await user.updatePhotoURL(downloadUrl);

      emit(ProfileImageUploaded(downloadUrl));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text('Profile image updated successfully'),
        ),
      );
    } catch (e) {
      emit(ProfileImageFailed(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating profile image: $e'),
        ),
      );
    }
  }
}
