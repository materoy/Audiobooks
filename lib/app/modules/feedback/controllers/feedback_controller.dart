import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FeedbackController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController feedbackController = TextEditingController();

  Future submit() async {}

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {}
}
