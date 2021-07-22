import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:get/get.dart';

class FeedbackController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController feedbackController = TextEditingController();

  final _validate = false.obs;

  bool get validate => _validate.value;

  Future submit(Widget alertDialog) async {
    if (checkEmptyFields()) {
      final Email email = Email(
        body: '''
        Hi I'm ${nameController.text}
        <h2><b> ${titleController.text} </b></h2>
        <p> ${feedbackController.text} </p>
        <i> Thank you </i>
        ''',
        subject: 'Audiobooks feedback',
        recipients: ['roymatero@gmail.com'],
        // cc: ['cc@example.com'],
        // bcc: ['bcc@example.com'],
        // attachmentPaths: ['/path/to/attachment.zip'],
        isHTML: true,
      );

      await FlutterEmailSender.send(email);
    }
    // Get.dialog(alertDialog);
  }

  bool checkEmptyFields() {
    _validate.value = true;
    if (nameController.text == '' ||
        emailController.text == '' ||
        titleController.text == '' ||
        feedbackController.text == '') {
      Get.snackbar('Some fields are empty',
          'Please fill all the fields before submitting');
      return false;
    }
    return true;
  }

  void clear() {
    nameController.clear();
    emailController.clear();
    titleController.clear();
    feedbackController.clear();
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {}
}
