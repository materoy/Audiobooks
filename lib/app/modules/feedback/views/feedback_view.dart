import 'package:audiobooks/app/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/feedback_controller.dart';

class FeedbackView extends GetView<FeedbackController> {
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
                    maxLines: 4,
                  ),
                  ElevatedButton(
                    onPressed: () => controller.submit(),
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0)),
                        minimumSize: Size(SizeConfig.blockSizeHorizontal * 45.0,
                            SizeConfig.blockSizeVertical * 8.0)),
                    child: const Text('Submit'),
                  )
                ],
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
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
          labelText: label,
          contentPadding: const EdgeInsets.only(left: 20.0, top: 25.0),
          hintText: hint,
          hintStyle: const TextStyle(fontSize: 12),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(15.0))),
    );
  }
}
