import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'controller.dart';

class HomePage extends GetView<HomePageController> {
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('C-Shape Box Game'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              buildCounter(),
              const SizedBox(height: 24),
              buildDynamicC(),
            ],
          ),
        ));
  }

  Widget buildDynamicC() {
    return Expanded(
      child: Obx(() {
        if (controller.numberOfBoxes.value < 5) return const SizedBox();

        return LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = constraints.maxWidth;
            final screenHeight = constraints.maxHeight;

            final topCount = controller.topRowCount.value;
            final bottomCount = topCount;
            final middleCount =
                controller.numberOfBoxes.value - (topCount + bottomCount);

            final horizontalBoxSize =
                (screenWidth - 32 - (topCount - 1) * 8) / topCount;
            final verticalSpacePerBox =
                (screenHeight - (middleCount * 8) - 100) / (middleCount + 2);
            final boxSize = horizontalBoxSize < verticalSpacePerBox
                ? horizontalBoxSize
                : verticalSpacePerBox;

            final boxes = List.generate(
                controller.numberOfBoxes.value, (i) => buildBox(i, boxSize));

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Row(
                      children: List.generate(topCount, (i) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8, bottom: 8),
                          child: boxes[i],
                        );
                      }),
                    ),
                  ),

                  Column(
                    children: List.generate(middleCount, (i) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 4, bottom: 4),
                        child: boxes[topCount + i],
                      );
                    }),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: 4, top: 4),
                    child: Row(
                      children: List.generate(bottomCount, (i) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: boxes[
                              controller.numberOfBoxes.value - bottomCount + i],
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 32), // Extra space for safe bottom
                ],
              ),
            );
          },
        );
      }),
    );
  }

  Widget buildCounter() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              const Text(
                'Number of Boxes',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: controller.decrementBoxes,
                    icon: const Icon(Icons.remove_circle_outline,
                        size: 30, color: Colors.red),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Obx(() {
                      return Text(
                        '${controller.numberOfBoxes.value}',
                        style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue),
                      );
                    }),
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    onPressed: controller.incrementBoxes,
                    icon: const Icon(Icons.add_circle_outline,
                        size: 30, color: Colors.blue),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Obx(() {
          final tappedCount =
              controller.boxStates.where((state) => state).length;
          final totalBoxes = controller.numberOfBoxes.value;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'Tapped: $tappedCount / $totalBoxes',
              style: const TextStyle(
                  fontSize: 16,
                  color: Colors.green,
                  fontWeight: FontWeight.bold),
            ),
          );
        }),
      ],
    );
  }

  Widget buildBox(int index, double size) {
    return Obx(() {
      final isGreen = controller.boxStates[index];
      final isAnimating = controller.isAnimating.value;

      return GestureDetector(
        onTap: () => controller.toggleBox(index),
        child: TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 300),
          tween: Tween<double>(
            begin: 0,
            end: isGreen ? 1.0 : 0.0,
          ),
          builder: (context, value, child) {
            return Transform.scale(
              scale: isAnimating ? 0.95 : 1.0,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: size,
                height: size,
                decoration: BoxDecoration(
                  color: Color.lerp(
                      Colors.red.shade300, Colors.green.shade400, value),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Color.lerp(
                        Colors.red.withOpacity(0.3),
                        Colors.green.withOpacity(0.3),
                        value,
                      )!,
                      spreadRadius: 1 + value,
                      blurRadius: 4 + (value * 4),
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: value,
                    child:
                        const Icon(Icons.check, color: Colors.white, size: 24),
                  ),
                ),
              ),
            );
          },
        ),
      );
    });
  }
}
