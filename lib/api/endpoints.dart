class Endpoints {
  String loginEndpoint = 'login';

  String registerEndpoint = 'register';

  String getUserProfileEndpoint = 'admin/user-profile';

  String getDoctorProfileEndpoint = 'admin/doctor-profile';

  String getNurseProfileEndpoint = 'admin/nurse-profile';

  String getVendorProfileEndpoint = 'vendor-profile';

  String getImageSliderEndpoint = 'slider';

  String getPackageSliderEndpoint = 'package-slider';

  String getDepartmentEndpoint = 'admin/department';

  String getOurServicesEndpoint = 'service';

  String getAboutUsEndpoint = 'about';

  String getPackagesEndpoint = 'package';

  String familyListEndpoint = 'admin/addfamily';

  String getPaymentDetailsOfPackageWhileReqApproveEndpoints =
      'admin/userpackage/calculate-initial-payment';

  String postPaymentForFamilyApproveReq =
      'admin/userpackage/additional-payment';

  String checkSwitchPrimaryMemberStatusEndpoint =
      'admin/family/change-primary-member-list';

  String postPrimaryMemberSwitchEndpoint = 'admin/family/change-primary-member';

  String getAllFamilyLeaveRequestListEndpoint =
      'admin/family/get-leave-request';

  String familyRequestListEndpoint = 'admin/addfamily/family-request';

  String noneMemberTypeRequestListEndpoint = 'admin/addfamily/myrequest';

  String sendFriendRequest = 'admin/addfamily/store';

  String approveFamilyRequest1 = 'admin/addfamily/approved';

  String approveFamilyRequest2 = 'admin/addfamily/accept-family-request';

  String familyLeaveReqReject = 'admin/family/leave-request/reject';

  String familyLeaveReqApprove = 'admin/family/leave-request/approve';

  String leaveFamilyRequestByDependentEndpoint = 'admin/family/leave-request';

  String allPhoneDetails = 'admin/addfamily/user';

  String getPaymentStatementEndpoint = 'transaction-history';

  String getAllTopDoctors = 'top-doctors';

  String getDateEndpoint = 'admin/booking/date';

  String getTimeEndpoint = 'booking/time';

  String getIndividualDoctorTimingsEndpoint =
      'admin/booking-review/get-doctor-booking-slots';

  String getIndividualNurseShiftsEndpoints = 'admin/nurses/shifts';

  String postBookingReview = 'admin/booking-review/review';

  String getAppointmentBookingDetails = 'admin/booking-review';

  String getNurseAppointmentBookingDetails = 'admin/nurses/bookings';

  String getProductEndpoint = 'products';

  String getCategoryEndpoint = 'categories';

  // String getFamilyRequestDetails = 'admin/addfamily/?family_id=$family_id';

  String getIndividualPackageEndpoint = 'admin/userpackage';

  String postBookPackageEndpoint = 'admin/userpackage/store';

  String getInsuranceTypeEndpoint = 'insurance';

  String getInsuranceDetailsEndpoint = 'admin/insurance-details/insurance';

  String getClaimInsuranceDetailsEndpoint = 'admin/insurance-claim';

  String postClaimInsuranceEndpoint = 'admin/insurance-claim/store';

  String getIndividualUserInsurance = 'admin/insurance-claim';

  String getWishlistEndpoint = 'admin/wishlist';

  String postToWishlistEndpoint = 'admin/wishlist/addToWishlist';

  String deleteAllFromWishListEndpoint = 'admin/wishlist/allWishlistDelete';

  String postOrderEndpoint = 'admin/order/store';

  String getMyOrderEndpoint = 'admin/order';

  String postFCMTokenEndpoint = 'admin/store-token';

  String postReviewEndpoint = 'admin/product_review';

  String postDoctorReviewEndpoint = 'doctorReview';

  String postVendorReviewEndpoint = 'vendor-review';

  String postNurseReviewEndpoint = 'nurseReview';

  String getAllVendorsEndpoint = 'vendor-type';

  String getAllVendorsListEndpoint = 'vendor-details';

  String getMedicalServicesEndpoint = 'admin/medical-report/services';

  String getBrandEndpoint = 'brand';

  String getNewsMenuEndpoint = 'menu';

  String getNewsEndpoint = 'news';

  String postReferAFriend = 'referralFriend';

  String postCreateMeeting = 'admin/meetings';

  String postForgetPasswordEndpoint = 'forgot-password';

  String changePasswordEndpoint = 'change-password';

  String getZoomMeetingEndpoint = 'admin/meetings';

  String getCancelReasonEndpoint = 'admin/order/cancelReason';

  String getSymptomsEndpoint = 'admin/symptom';

  String postSearchBySymptomsEndpoint = 'admin/department/departmentBySymptoms';

  String getAllHospitalsEndpoint = 'hospital';

  String confirmPaymentEndpoint = 'admin/order/paymentOrder';

  String confirmDoctorPaymentEndpoint = 'admin/booking-review/payment';

  String confirmPaymentLabEndpoint = 'admin/lab-test/payment';

  String confirmPaymentPackageEndpoint = 'admin/userpackage/payment';

  String postBloodPressureEndpoint = 'admin/user-profile/updatebp';

  String postNurseBookingEndpoint = 'admin/nurses/book';

  String postVendorFollowEndpoint = 'vendor-follow';

  String getAllAmbulanceEndpoint = 'trips/driverList';

  String postChangePassword = 'change-old-password';

  String postNursePaymentEndpoint = 'admin/nurses/payment';

  String getLabServiceDepartmentsEndpoint = 'lab-test/department';

  String postLabBookingEndpoint = 'admin/lab-test/book-test';

  String getAllProvinceEndpoint = 'fetchprovince';

  String getViewGlobalForm = 'view-global-form';

  String postKYCPersonalInformationEndpoint = 'kyc/personal-information';

  String getmyReportDetailsEndpoint = 'admin/medical-report';

  String postDoctorTimings = 'admin/booking-review/doctor-booking-slots';

  String postNurseShifts = 'admin/nurses/addshifts';

  String getAppointmentsInDoctorSide = 'admin/booking-review/appointments';

  String getAppointmentsInNurseSide = 'admin/nurses/appointments';

  String getkycStatusEndpoint = 'kycstatus';

  String getShippingDetailsEndpoint = 'admin/order/shipping-details';

  String getMyLabBookedEndpoint = 'admin/lab-test';

  String postRequestToDriver = 'trips/driver-notification';

  String getUserNotificationEndpoint = 'trips/user-notification';

  String postAcceptAmbulanceReq = 'trips';

  String getUserTripEndpoint = 'trips/user-trip';

  String getMedicalAssistanceInAmbulanceBooking = 'trips/medical-assistance';

  String postAmbulanceBooking = 'trips/form-fillup';

  String postBecomePartnerDoctorEndpoint = 'admin/doctor-profile/store';

  String postBecomePartnerVendorEndpoint = 'vendor-profile/store';

  String postBecomePartnerRoEndpoint = 'relation-manager';

  String postBecomePartnerNurseEndpoint = 'admin/nurses/store';

  String postBecomePartnerDriverEndpoint = 'admin/driver-profile/store';

  String getGymPackagesEndpoint = 'fitness/fitness-pricing';

  String postGdFeedbackEndpoint = 'gd-feedback';

  String getSubjectListEndpoint = 'report-subject';

  String postReportProblemEndpoint = 'report-problem';

  String getFaqEndpoint = 'frequently-asked-question';

  String getDrinkWaterEndpoint = 'admin/water-intake';

  String postDrinkWaterTimingsEndpoint = 'admin/water-intake/store';

  String postWaterNotifcationEndpoint = 'admin/water-intake/notification';

  String getAppAnalyticsEndpoint = 'app-analytics';

  String postAppAnalyticsFcmEndpoint = 'app-analytics/store';

  String revokeTokenEndpoint = 'revoke-token';

  String checkTokenEndpoint = 'check-token';

  String getWebRtcAllMeetings = "admin/getAllMeeting";

  String postWebRtcCreateMeeting = "admin/createMeeting";

  String postAndReceiveQRkeyEndpoint = "login/create/qrcode";

  String postQrKeyEndpoint = "login/mobile/scan/qrcode";

  String qrLogoutEndpoint = "qr-logout";

  String deleteFCMWhileLogoutEndpoint = 'delete-fcm-while-logout';

  String postScreeningFeedbackEndpoint = 'admin/screening/review';

  String postGeneralNotiEndpoint = 'admin/store-topic-based-token';

  String checkGeneralNotiEndpoint = 'check-topic-fcm-while-logout';

  String delGeneralNotiEndpoint = 'delete-topic-fcm-while-logout';

  String postQRPhoneEndpoint = 'admin/family/qrscan';

  String postStepCountEndpoint = 'admin/user-profile/update-step-count';

  String getStepCountHistoryEndpoint = 'admin/user-profile/step-count';

  String postRescheduleScreeningEndpoint = 'admin/request-screening-change';

  String postToGetPackageMeetingLinkEndpoint = 'online-consultation-meeting';

  String postCompanyProfileEndpoint = 'company-school-profile';

  String getDeathInsuranceTypeEndpoint = 'admin/insurance-claim/details';

  String postDeathInsuranceClaimEndpoint =
      'admin/insurance-claim/death-claim-store';

  String getBecomeSecondaryToPrimaryMemberEndpoint =
      'admin/family/become-primary-member-list';

  String postBecomeSecondaryToPrimaryMemberEndpoint =
      'admin/family/become-primary-member';

  String updateEmailReceiveOtp = 'update-email';

  String verifyEmailOtp = 'verify-email-otp';

  String getExternalMedicalDetailsEndpoint =
      'admin/user-profile/medical-history';

  String postExternalMedicalDetailsEndpoint =
      'admin/user-profile/upload-reports';

  String apiKey = 'AIzaSyAn5wsAeXtYd97DyBHgnW2DariNEfKEevQ';
}

final endpoints = Endpoints();
