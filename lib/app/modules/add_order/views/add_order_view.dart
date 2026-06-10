
import '../../../common/constant/app_imports.dart';
import '../controllers/add_order_controller.dart';
import '../widget/assignment_step_one.dart';
import '../widget/assignment_step_two.dart';


class AddOrderView extends GetView<AddOrderController> {
  const AddOrderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => PopScope(
      // canPop is false when on Step 3, meaning we intercept the back gesture to run custom logic
      canPop: controller.currentStep.value == 1,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        // If the user is on Step 3, change the step back to 1 instead of closing the screen
        if (controller.currentStep.value == 3) {
          controller.onBack();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: CustomAppBar(
          title: controller.currentStep.value == 1
              ? 'Order Assignment'
              : 'Order Now',
          // Automatically inject a back button in Step 3 that calls controller.onBack()
          leading: controller.currentStep.value == 3
              ? IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
            onPressed: controller.onBack,
          )
              : null,
        ),
        body: controller.currentStep.value == 1
            ? AssignmentDetailsStep()
            : RequirementsAndPaymentStep(),
      ),
    ));
  }

}
