import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';

class MyLibraryController extends GetxController {
  var isLoading = false.obs;

  // Information
  var facultyName = 'Velliyangiri Nataraj'.obs;
  var subject = 'Mathematics'.obs;

  // Form fields
  var title = ''.obs;
  var description = ''.obs;
  var fileName = ''.obs;
  var selectedFile = Rxn<File>();

  // Form validation
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final fileNameController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    // Load faculty and subject info from API or shared state
    loadLibraryInfo();
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    fileNameController.dispose();
    super.onClose();
  }

  Future<void> loadLibraryInfo() async {
    try {
      isLoading.value = true;
      // TODO: Load faculty and subject info from API
      await Future.delayed(const Duration(milliseconds: 500));
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
    }
  }

  void updateTitle(String value) {
    title.value = value;
  }

  void updateDescription(String value) {
    description.value = value;
  }

  void updateFileName(String value) {
    fileName.value = value;
  }

  void selectFile(File? file) {
    selectedFile.value = file;
    if (file != null) {
      // Extract file name without extension
      final nameWithoutExt = file.path.split('/').last.replaceAll('.pdf', '');
      fileNameController.text = nameWithoutExt;
      updateFileName(nameWithoutExt);
    }
  }

  String? validateTitle() {
    if (title.value.isEmpty) {
      return 'Title is required';
    }
    if (title.value.length > 160) {
      return 'Title must be 160 characters or less';
    }
    return null;
  }

  String? validateDescription() {
    if (description.value.isEmpty) {
      return 'Description is required';
    }
    if (description.value.length > 500) {
      return 'Description must be 500 characters or less';
    }
    return null;
  }

  String? validateFileName() {
    if (fileName.value.isEmpty) {
      return 'File name is required';
    }
    return null;
  }

  Future<void> uploadReadingMaterial() async {
    final titleError = validateTitle();
    final descError = validateDescription();
    final fileError = validateFileName();

    if (titleError != null || descError != null || fileError != null) {
      Get.snackbar(
        'Validation Error',
        titleError ?? descError ?? fileError ?? '',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;
      // TODO: Upload file to API
      await Future.delayed(const Duration(seconds: 2));

      // Reset form
      titleController.clear();
      descriptionController.clear();
      fileNameController.clear();
      title.value = '';
      description.value = '';
      fileName.value = '';
      selectedFile.value = null;

      isLoading.value = false;
      Get.snackbar(
        'Success',
        'Reading material uploaded successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        'Error',
        'Failed to upload reading material: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void resetForm() {
    titleController.clear();
    descriptionController.clear();
    fileNameController.clear();
    title.value = '';
    description.value = '';
    fileName.value = '';
    selectedFile.value = null;
  }
}

