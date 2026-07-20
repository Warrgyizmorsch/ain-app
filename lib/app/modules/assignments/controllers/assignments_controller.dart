// ignore_for_file: unnecessary_null_comparison

import 'dart:io';

import '../../../common/constant/app_imports.dart';
import '../../../core/models/order_now_model/feedback_request_model.dart';
import '../../../core/models/order_now_model/order_list_model.dart';
import '../../../core/models/payment_model/add_payment_sc_request_model.dart';
import '../../../core/models/payment_model/bank_list_model.dart';
import '../../../core/utils/api/order_now_api/feedback_api.dart';
import '../../../core/utils/api/order_now_api/order_list_api.dart';
import '../../../core/utils/api/order_now_api/raise_ticket_api.dart';
import '../../../core/utils/api/payment_api/add_payment_sc_api.dart';
import '../../../core/utils/api/payment_api/bank_list_api.dart';
import '../../../core/utils/helper/device_helper.dart';
enum OrderFilter { all, completed, inProgress, pending }
class AssignmentsController extends GetxController {
  final isLoading = false.obs;
  final isLoadingPayment = false.obs;
  final isLoadingTicket = false.obs;
  final isLoadingFeedback = false.obs;
  final orderResponse = Rxn<OrderListResponse>();
  final RxList<BankDetail> banksList = <BankDetail>[].obs;
  final isBankLoading = false.obs;

  List<dynamic> get allAssignments => [
    ...nonConfirmedLeads,
    ...(orderResponse.value?.data?.confirmedOrders ?? [])
  ];

  List<Lead> get nonConfirmedLeads =>
      orderResponse.value?.data?.nonConfirmedLeads ?? [];

  // 3. Completed (Jo Confirm ho gaye hain AUR Deliver ho gaye hain)
  List<ConfirmedOrder> get completedOrders {
    final allConfirmed = orderResponse.value?.data?.confirmedOrders ?? [];

    return allConfirmed.where((order) {
      final isConfirmed = order.confirmedStatus?.toLowerCase() == 'confirmed';
      final isDelivered = order.deliveryDate != null && order.deliveryDate!.toString().trim().isNotEmpty;

      return isConfirmed && isDelivered;
    }).toList();
  }

  List<dynamic> get activeAssignments {
    final allConfirmed = orderResponse.value?.data?.confirmedOrders ?? [];

    final activeConfirmed = allConfirmed.where((order) {
      final isConfirmed = order.confirmedStatus?.toLowerCase() == 'confirmed';
      final isNotDelivered = order.deliveryDate == null || order.deliveryDate!.toString().trim().isEmpty;

      return isConfirmed && isNotDelivered;
    }).toList();

    return [...nonConfirmedLeads, ...activeConfirmed];
  }
  final selectedFilter = OrderFilter.all.obs;

  List<dynamic> get filteredAssignments {
    final all = allAssignments;

    switch (selectedFilter.value) {
      case OrderFilter.completed:
        return all.where((item) => item is ConfirmedOrder &&
            item.deliveryDate != null && item.deliveryDate!.trim().isNotEmpty).toList();
      case OrderFilter.inProgress:
        return all.where((item) => item is ConfirmedOrder &&
            (item.deliveryDate == null || item.deliveryDate!.trim().isEmpty)).toList();
      case OrderFilter.pending:
        return all.whereType<Lead>().toList();
      case OrderFilter.all:
      return all;
    }
  }

  void updateFilter(OrderFilter filter) {
    selectedFilter.value = filter;
  }
  @override
  void onInit() {
    super.onInit();
    getOrderList();
    bankList();
  }

  Future<void> getOrderList() async {
    try {
      isLoading.value = true;

      final response = await OrderListApi.getOrderList();
      if (response != null) {
        orderResponse.value = response;
      }
    } catch (e) {
      debugPrint('Order List Error: $e');
    } finally {
      isLoading.value = false;
    }
  }
  Future<void> bankList() async {
    try {
      isBankLoading.value = true;

      final response = await BankListApi.getBankList();

      if (response.success == true && response.data != null) {
        banksList.assignAll(response.data!);
      } else {
        Get.snackbar(
          'Error',
          'Failed to load bank details',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint('Bank List Error: $e');
      Get.snackbar(
        'Error',
        'Something went wrong while fetching banks.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isBankLoading.value = false;
    }
  }

  Future<void> raiseTicket({
    required String orderId,
    required String comment,
    required BuildContext context,
  }) async {
    try {
      isLoadingTicket.value = true;

      final response = await RaiseTicketApi.addRaiseTicket(
        orderId: orderId,
        comment: comment,
      );

      if (response.success == true) {
        Get.back(); // Close dialog
        UDeviceHelper.showToast(
          response.message ?? "Ticket raised successfully!",
        );

        debugPrint("Ticket Number: ${response.data?.feedbackTicket}");
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
  Future<void> submitPaymentProof({
    required String orderId,
    required String amount,
    required String bankCountry,
    required String payeeName,
    required String reference,
    required File selectedFile,
  }) async {
    try {
      isLoadingPayment.value = true;

      final requestModel = AddPaymentRequestModel(
        orderId: orderId,
        paidAmount: amount,
        companyAccounts: bankCountry,
        payeeName: payeeName,
        reference: reference,
        screenshot: selectedFile,
      );

      final response = await AddPaymentScApi.addPayment(
        request: requestModel,
        files: [selectedFile],
      );

      if (response.success == true) {
        Get.back();
        Get.snackbar(
          'Success',
          response.message ?? 'Payment uploaded successfully!',
          backgroundColor: AppColors.success,
          colorText: AppColors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to upload payment details.',
          backgroundColor: AppColors.error,
          colorText: AppColors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString().replaceAll("Exception:", ""),
        backgroundColor: AppColors.error,
        colorText: AppColors.white,
      );
    } finally {
      isLoadingPayment.value = false;
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
         response.message ?? "Feedback submitted successfully!",
        );
        debugPrint("Feedback submitted for Order: ${request.orderId}");
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


}