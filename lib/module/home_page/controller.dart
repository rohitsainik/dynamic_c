import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePageController extends GetxController {
  RxInt numberOfBoxes = 5.obs;
  RxInt topRowCount = 2.obs;
  RxList<bool> boxStates = <bool>[].obs;
  RxList<int> clickOrder = <int>[].obs;
  RxBool isAnimating = false.obs;
  Timer? animationTimer;
  TextEditingController inputController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    initializeBoxes(5);
    ever(numberOfBoxes, _updateBoxStates);
  }

  void _updateBoxStates(int n) {
    if (n >= 5 && n <= 25) {
      final currentStates = List<bool>.from(boxStates);
      if (n > currentStates.length) {

        boxStates.value = [
          ...currentStates,
          ...List.generate(n - currentStates.length, (_) => false)
        ];
      } else if (n < currentStates.length) {

        boxStates.value = currentStates.sublist(0, n);
      }
      topRowCount.value = (n / 3).ceil();
    }
  }

  void initializeBoxes(int n) {
    if (n >= 5 && n <= 25) {
      numberOfBoxes.value = n;
      topRowCount.value = (n / 3).ceil();
      boxStates.value = List.generate(n, (_) => false);
      clickOrder.clear();
    }
  }

  void toggleBox(int index) {
    if (!isAnimating.value && !boxStates[index]) {
      final newStates = List<bool>.from(boxStates);
      newStates[index] = true;
      boxStates.value = newStates;
      clickOrder.add(index);

      if (!boxStates.contains(false)) {
        Get.snackbar(
          "🎉 Congratulations!",
          "You tapped all ${numberOfBoxes.value} boxes! Watch them reset...",
          backgroundColor: Colors.green.shade50,
          colorText: Colors.black87,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
          icon: const Icon(Icons.celebration, color: Colors.amber),
          margin: const EdgeInsets.all(16),
          borderRadius: 10,
        );

        startReverseAnimation();
      }
    }
  }

  void incrementBoxes() {
    final currentValue = numberOfBoxes.value;
    if (currentValue < 25) {
      numberOfBoxes.value = currentValue + 1;
    }
  }

  void decrementBoxes() {
    final currentValue = numberOfBoxes.value;
    if (currentValue > 5) {
      numberOfBoxes.value = currentValue - 1;
    }
  }

  void startReverseAnimation() {
    isAnimating.value = true;
    var reversedOrder = List.from(clickOrder.reversed);
    var currentIndex = 0;

    animationTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (currentIndex < reversedOrder.length) {
        final newStates = List<bool>.from(boxStates);
        newStates[reversedOrder[currentIndex]] = false;
        boxStates.value = newStates;
        currentIndex++;
      } else {
        timer.cancel();
        clickOrder.clear();
        isAnimating.value = false;
      }
    });
  }

  @override
  void onClose() {
    animationTimer?.cancel();
    super.onClose();
  }
}
