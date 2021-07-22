import 'package:audiobooks/app/routes/app_pages.dart';
import 'package:audiobooks/app/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/feedback_controller.dart';

class FeedbackView extends GetView<FeedbackController> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      navigationBar: const CupertinoNavigationBar(
        backgroundColor: Colors.transparent,
        previousPageTitle: 'Settings',
        middle: Text('Feedback'),
      ),
      child: SingleChildScrollView(
        child: SafeArea(
          child: Material(
            child: Container(
              height: SizeConfig.screenHeight * .9,
              padding: EdgeInsets.symmetric(
                  vertical: SizeConfig.blockSizeVertical * 1,
                  horizontal: SizeConfig.blockSizeHorizontal * 5.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InputField(
                        label: 'Name', controller: controller.nameController),
                    InputField(
                        label: 'Email', controller: controller.emailController),
                    InputField(
                        controller: controller.titleController,
                        label: 'Title',
                        hint: 'Write a descriptive title for your feedback'),
                    InputField(
                      controller: controller.feedbackController,
                      label: 'Feedback',
                      hint: 'So now tell me, whatsup ',
                      maxLines: 6,
                    ),
                    ElevatedButton(
                      onPressed: () =>
                          controller.submit(const FeedbackAlertDialog()),
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0)),
                          minimumSize: Size(
                              SizeConfig.blockSizeHorizontal * 45.0,
                              SizeConfig.blockSizeVertical * 8.0)),
                      child: const Text('Submit'),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class InputField extends StatelessWidget {
  const InputField(
      {Key? key,
      required this.label,
      this.hint,
      this.maxLines,
      required this.controller})
      : super(key: key);

  final String label;
  final String? hint;
  final int? maxLines;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      autovalidateMode: Get.find<FeedbackController>().validate
          ? AutovalidateMode.onUserInteraction
          : AutovalidateMode.always,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please fill the required fields';
        }
        return null;
      },
      maxLines: maxLines,
      decoration: InputDecoration(
          labelText: label,
          contentPadding: const EdgeInsets.only(left: 20.0, top: 30.0),
          hintText: hint,
          hintStyle: const TextStyle(fontSize: 12),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(15.0))),
    );
  }
}

class FeedbackAlertDialog extends StatelessWidget {
  const FeedbackAlertDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Text('Thank you for your feedback'),
      content: Column(
        children: const [
          SizedBox(height: 10.0),
          Icon(CupertinoIcons.check_mark_circled,
              color: CupertinoColors.activeGreen, size: 50.0),
          SizedBox(height: 10.0),
          Text('''
          Your feedback has been sent, I will get back to you shortly
            '''),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () {
              Get.find<FeedbackController>().clear();
              Get.back();
            },
            child: const Text('Submit another')),
        TextButton(
            onPressed: () => Get.offAllNamed(Routes.LIBRARY),
            child: const Text('Back')),
      ],
    );
  }
}
