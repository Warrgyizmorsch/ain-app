

import '../../../common/constant/app_imports.dart';
import '../../../core/models/order_now_model/feedback_request_model.dart';
import '../../../core/models/order_now_model/order_list_model.dart';
import '../../../core/utils/api/order_now_api/feedback_api.dart';
import '../../../core/utils/api/order_now_api/order_list_api.dart';
import '../../../core/utils/api/order_now_api/raise_ticket_api.dart';
import '../../../core/utils/helper/device_helper.dart';

class AssignmentsController extends GetxController {
  // --- State Variables ---
  final isLoading = false.obs;
  final isLoadingTicket = false.obs;
  final isLoadingFeedback = false.obs;
  final orderResponse = Rxn<OrderListResponse>();

  // --- UI Convenience Getters ---
  // These make it easy for your TabBarView to grab the exact lists it needs
  List<ConfirmedOrder> get confirmedOrders => orderResponse.value?.data?.confirmedOrders ?? [];
  List<Lead> get nonConfirmedLeads => orderResponse.value?.data?.nonConfirmedLeads ?? [];

  @override
  void onInit() {
    super.onInit();
    // Fetch the list as soon as the controller initializes
    getOrderList();
  }

  Future<void> getOrderList() async {
    try {
      isLoading.value = true; // 1. TURN ON LOADING SPINNER

      final response = await OrderListApi.getOrderList();
      if (response != null) {
        orderResponse.value = response;
      }
    } catch (e) {
      debugPrint('Order List Error: $e');
    } finally {
      isLoading.value = false; // 2. TURN OFF SPINNER (Even if an error happens)
    }
  }
  Future<void> raiseTicket({
    required String orderId,
    required String comment,
    required BuildContext context
  }) async {
    try {
      isLoadingTicket.value = true;

      final response = await RaiseTicketApi.addRaiseTicket(
        orderId: orderId,
        comment: comment,
      );

      if (response.success == true) {
        Get.back(); // Close dialog
        UDeviceHelper.showToast(context,  response.message ?? "Ticket raised successfully!",);

        debugPrint(
          "Ticket Number: ${response.data?.feedbackTicket}",
        );
      } else {
        Get.snackbar(
          "Error",
          response.message ?? "Failed to raise ticket.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.error,
          colorText: AppColors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.error,
        colorText: AppColors.white,
      );
    } finally {
      isLoadingTicket.value = false;
    }
  }
  Future<void> submitFeedback({
    required FeedbackRequest request,
    required BuildContext context,
  }) async {
    try {
      isLoadingFeedback.value = true;

      final response = await FeedbackApi.addFeedBack(
        request: request,
      );

      if (response.success == true) {
        Get.back();

        UDeviceHelper.showToast(
          context,
          response.message ?? "Feedback submitted successfully!",
        );

        debugPrint(
          "Feedback submitted for Order: ${request.orderId}",
        );
      } else {
        Get.snackbar(
          "Error",
          response.message ?? "Failed to submit feedback.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.error,
          colorText: AppColors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.error,
        colorText: AppColors.white,
      );
    } finally {
      isLoadingFeedback.value = false;
    }
  }
  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}