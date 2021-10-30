// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

class _$ApiService extends ApiService {
  _$ApiService([ChopperClient client]) {
    if (client == null) return;
    this.client = client;
  }

  final definitionType = ApiService;

  Future<Response> getPopularMovies() {
    final $url = 'api/genres';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }

  Future<Response> loginUser(LoginBody body) {
    final $url = 'api/v1/auth/authenticate.json';
    final $body = body;
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<dynamic, dynamic>($request);
  }
  //
  // Future<Response> createUser(RegistrationBody body) {
  //   final $url = 'users.json';
  //   final $body = body;
  //   final $request = Request('POST', $url, client.baseUrl, body: $body);
  //   return client.send<dynamic, dynamic>($request);
  // }
  //
  // Future<Response> updateUser(ProfileBody body) {
  //   final $url = 'users.json';
  //   final $body = body;
  //   final $request = Request('PATCH', $url, client.baseUrl, body: $body);
  //   return client.send<dynamic, dynamic>($request);
  // }

  Future<Response> logOut() {
    final $url = 'api/v1/auth/logout.json';
    final $request = Request('DELETE', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }

  Future<Response> getSurveyList() {
    final $url = 'api/v1/surveys';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }

  Future<Response> getDashboardInfos() {
    final $url = 'api/v1/homes/dashboard';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }

  Future<Response> getSurveyListByToken(String token) {
    final $url = 'api/v1/surveys/for_token';
    final $params = <String, dynamic>{'survey_token': token};
    final $request = Request('POST', $url, client.baseUrl, parameters: $params);
    return client.send<dynamic, dynamic>($request);
  }

  Future<Response> enrollInSurvey(
      int surveyTokenId, int surveyId, bool isEnrol) {
    final $url = 'api/v1/surveys/enroll_current_user';
    final $params = <String, dynamic>{
      'survey_token_id': surveyTokenId,
      'survey_id': surveyId,
      'skip_enroll': isEnrol
    };
    final $request = Request('POST', $url, client.baseUrl, parameters: $params);
    return client.send<dynamic, dynamic>($request);
  }

  Future<Response> getSurveyResponseList(int surveyId, String filter) {
    final $url = 'api/v1/survey_responses';
    final $params = <String, dynamic>{'survey_id': surveyId, 'filter': filter};
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send<dynamic, dynamic>($request);
  }

  Future<Response> viewSurveyResponse(int id) {
    final $url = 'api/v1/survey_responses/show';
    final $params = <String, dynamic>{'id': id};
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send<dynamic, dynamic>($request);
  }

  Future<Response> createSurveyResponse(
      int id, Map<String, dynamic> responseBody) {
    final $url = 'api/v1/survey_responses';
    final $params = <String, dynamic>{'survey_id': id};
    final $body = responseBody;
    final $request =
        Request('POST', $url, client.baseUrl, parameters: $params, body: $body);
    return client.send<dynamic, dynamic>($request);
  }

  Future<Response> getThemes() {
    final $url = 'api/v1/themes';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }

  Future<Response> getBaseLines(double lat, double lang, int radius) {
    final $url = 'api/v1/baselines';
    final $params = <String, dynamic>{
      'lat': lat,
      'lng': lang,
      'radius_in_miles': radius
    };
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send<dynamic, dynamic>($request);
  }

  Future<Response> showBaseLineDetail(int id) {
    final $url = 'api/v1/baselines/show';
    final $params = <String, dynamic>{'id': id};
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send<dynamic, dynamic>($request);
  }

  Future<Response> getBaselineForms() {
    final $url = 'api/v1/baselines/all_forms';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }

  Future<Response> getProblemSolutionSubmissions() {
    final $url = 'api/v1/problem_solution_submissions';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }

  Future<Response> getProblemSolutionSubmissionDetail(int pss_id) {
    final $url = 'api/v1/problem_solution_submissions/show';
    final $params = <String, dynamic>{'pss_id': pss_id};
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send<dynamic, dynamic>($request);
  }

  Future<Response> getOngoingProblemSolutionSubmissionDetail(int pss_id) {
    final $url = 'api/v1/problem_solution_submissions/ongoing_submission';
    final $params = <String, dynamic>{'pss_id': pss_id};
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send<dynamic, dynamic>($request);
  }

  Future<Response> getProblemList(int baselineId, int pssId) {
    final $url = 'api/v1/problem_solution_submissions/problem_list';
    final $params = <String, dynamic>{
      'baseline_id': baselineId,
      'pss_id': pssId
    };
    final $request = Request('POST', $url, client.baseUrl, parameters: $params);
    return client.send<dynamic, dynamic>($request);
  }

  Future<Response> getProblemSolutionSubmissionOverview(int pss_id) {
    final $url = 'api/v1/problem_solution_paths/submission_overview';
    final $params = <String, dynamic>{'pss_id': pss_id};
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send<dynamic, dynamic>($request);
  }

  Future<Response> getCauseList(int problemId, int pssId) {
    final $url = 'api/v1/problem_solution_submissions/cause_list';
    final $params = <String, dynamic>{'problem_id': problemId, 'pss_id': pssId};
    final $request = Request('POST', $url, client.baseUrl, parameters: $params);
    return client.send<dynamic, dynamic>($request);
  }

  Future<Response> getSolutionList(List<int> causeIds, int pssId) {
    final $url = 'api/v1/problem_solution_paths/get_solution';
    final $params = <String, dynamic>{'cause_ids[]': causeIds, 'pss_id': pssId};
    final $request = Request('POST', $url, client.baseUrl, parameters: $params);
    return client.send<dynamic, dynamic>($request);
  }

  Future<Response> getActionList(int pssId, int solutionId) {
    final $url = 'api/v1/problem_solution_paths/get_actions';
    final $params = <String, dynamic>{
      'pss_id': pssId,
      'solution_id': solutionId
    };
    final $request = Request('POST', $url, client.baseUrl, parameters: $params);
    return client.send<dynamic, dynamic>($request);
  }

  Future<Response> getFeedback(int feedback_id) {
    final $url = 'api/v1/feedbacks';
    final $params = <String, dynamic>{'feedback_id': feedback_id};
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send<dynamic, dynamic>($request);
  }

  Future<Response> createProblem(String description, int pssId) {
    final $url = 'api/v1/problem_solution_submissions/create_problem';
    final $params = <String, dynamic>{
      'description': description,
      'pss_id': pssId
    };
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send<dynamic, dynamic>($request);
  }

  Future<Response> createCause(String description, int pssId, int problemId) {
    final $url = 'api/v1/problem_solution_submissions/create_cause';
    final $params = <String, dynamic>{
      'description': description,
      'pss_id': pssId,
      'problem_id': problemId
    };
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send<dynamic, dynamic>($request);
  }

  Future<Response> createSolution(String description, int pssId) {
    final $url = 'api/v1/problem_solution_paths/create_solution';
    final $params = <String, dynamic>{
      'description': description,
      'pss_id': pssId
    };
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send<dynamic, dynamic>($request);
  }

  Future<Response> createAction(
      String description, int pssId, int pathId, String taskType) {
    final $url = 'api/v1/problem_solution_paths/create_action';
    final $params = <String, dynamic>{
      'description': description,
      'pss_id': pssId,
      'path_id': pathId,
      'task_type': taskType
    };
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send<dynamic, dynamic>($request);
  }

  Future<Response> createEmailAction(String description, int pssId, int pathId,
      String taskType, int emailTemplateId) {
    final $url = 'api/v1/problem_solution_paths/create_action';
    final $params = <String, dynamic>{
      'description': description,
      'pss_id': pssId,
      'path_id': pathId,
      'task_type': taskType,
      'email_template_id': emailTemplateId
    };
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send<dynamic, dynamic>($request);
  }

  Future<Response> setTaskStatus(int taskId, String status, int pathId) {
    final $url = 'api/v1/problem_solution_paths/set_task_status';
    final $params = <String, dynamic>{
      'task_id': taskId,
      'status': status,
      'path_id': pathId
    };
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send<dynamic, dynamic>($request);
  }

  Future<Response> saveNote(String note, int taskId, int pathId) {
    final $url = 'api/v1/problem_solution_paths/save_note';
    final $params = <String, dynamic>{
      'note': note,
      'task_id': taskId,
      'path_id': pathId
    };
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send<dynamic, dynamic>($request);
  }

  Future<Response> viewNote(int taskId, int pathId) {
    final $url = 'api/v1/problem_solution_paths/view_note';
    final $params = <String, dynamic>{'task_id': taskId, 'path_id': pathId};
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send<dynamic, dynamic>($request);
  }

  Future<Response> GetDataForForwardingProblemSubmission(int pss_id) {
    final $url = 'api/v1/problem_solution_submissions/forward_submission';
    final $params = <String, dynamic>{'pss_id': pss_id};
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send<dynamic, dynamic>($request);
  }

  Future<Response> redirectSubmission(int pssId, int userId) {
    final $url = 'api/v1/problem_solution_submissions/redirect_submission';
    final $params = <String, dynamic>{'pss_id': pssId, 'user_id': userId};
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    print("pssid:${pssId},userid:${userId}");
    return client.send<dynamic, dynamic>($request);
  }

  Future<Response> submitProblemSubmission(int pssId) {
    final $url =
        'api/v1/problem_solution_submissions/submit_problem_submission';
    final $params = <String, dynamic>{'pss_id': pssId};
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);

    return client.send<dynamic, dynamic>($request);
  }

  Future<Response> getFeedbackForm(int pathId, int taskId) {
    final $url = 'api/v1/feedbacks/form';
    final $params = <String, dynamic>{'path_id': pathId, 'task_id': taskId};
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send<dynamic, dynamic>($request);
  }

  Future<Response> saveFeedbackForm(int pathId, int taskId, List<int> answerIds,
      int rating, String comment, int problemSolvedStatus) {
    final $url = 'api/v1/feedbacks/save_feedback';
    final $params = <String, dynamic>{
      'path_id': pathId,
      'task_id': taskId,
      'answer_ids[]': answerIds,
      'feedback_star_rating': rating,
      'feedback_comment': comment,
      'problem_solved_status': problemSolvedStatus
    };
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send<dynamic, dynamic>($request);
  }

  Future<Response> getChatRooms() {
    final $url = 'api/v1/rooms/room_list';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }

  Future<Response> getNotifications() {
    final $url = 'api/v1/notifications';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }

  Future<Response> getNotificationDetail(int notificationId) {
    final $url = 'api/v1/notifications/notifiable_details';
    final $params = <String, dynamic>{
      'notification_id': notificationId,
    };
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send<dynamic, dynamic>($request);
  }

  Future<Response> getLastNotificationReadStatus() {
    final $url = 'api/v1/notifications/last_notification_read_status';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }

  Future<Response> sendSingleChatInvitation(int user_id) {
    final $url = 'api/v1/rooms/send_invitation';
    final $params = <String, dynamic>{'user_id': user_id};
    final $request = Request('POST', $url, client.baseUrl, parameters: $params);
    return client.send<dynamic, dynamic>($request);
  }

  Future<Response> getRoomMessages(int roomId, int pageNo, int size) {
    final $url = 'api/v1/rooms/room_messages';
    final $params = <String, dynamic>{
      'room_id': roomId,
      'page_no': pageNo,
      'size': size
    };
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send<dynamic, dynamic>($request);
  }

  Future<Response> createMessage(
      int roomId, String message, http.MultipartFile file) {
    final $url = 'api/v1/rooms/room_messages';
    final $parts = <PartValue>[
      PartValue<int>('room_id', roomId),
      PartValue<String>('message', message),
      PartValueFile<http.MultipartFile>('file', file),
    ];
    final $request =
        Request('POST', $url, client.baseUrl, parts: $parts, multipart: true);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> uploadPhoto(
      int taskId, int pathId, List<http.MultipartFile> multipartFiles) {
    final $url = 'api/v1/problem_solution_paths/add_photos';
    //final $headers = {'Content-Disposition': 'inline'};
    final $parts = <PartValue>[
      PartValue<int>('task_id', taskId),
      PartValue<int>('path_id', pathId),
      PartValueFile<List<http.MultipartFile>>('file', multipartFiles)
    ];
    final $request =
        Request('POST', $url, client.baseUrl, parts: $parts, multipart: true);
    return client.send<dynamic, dynamic>($request);
  }

  Future<Response> showPhotos(int pathId, int taskId) {
    final $url = 'api/v1/problem_solution_paths/get_photos';
    final $params = <String, dynamic>{'path_id': pathId, 'task_id': taskId};
    final $request = Request('POST', $url, client.baseUrl, parameters: $params);
    return client.send<dynamic, dynamic>($request);
  }

  Future<Response> deletePhoto(String signedId) {
    final $url = 'api/v1/problem_solution_paths/delete_photo';
    final $params = <String, dynamic>{'signed_id': signedId};
    final $request = Request('POST', $url, client.baseUrl, parameters: $params);
    return client.send<dynamic, dynamic>($request);
  }

  Future<Response> getPSSListByBaseline(int baselineId) {
    final $url =
        'api/v1/problem_solution_submissions/submitted_problem_submissions';
    final $params = <String, dynamic>{'baseline_id': baselineId};
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send<dynamic, dynamic>($request);
  }

  Future<Response> getTaskCreationData(int pssId) {
    final $url = 'api/v1/problem_solution_paths/get_task_data';
    final $params = <String, dynamic>{'pss_id': pssId};
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send<dynamic, dynamic>($request);
  }

  Future<Response> getPublicRoomUserList() {
    final $url = 'api/v1/rooms/room_user_list';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }

  Future<Response> createPublicChatRoom(String roomName, List<int> userIds) {
    final $url = 'api/v1/rooms/create';
    final $params = <String, dynamic>{'name': roomName, 'user_ids[]': userIds};
    final $request = Request('POST', $url, client.baseUrl, parameters: $params);
    return client.send<dynamic, dynamic>($request);
  }

  Future<Response> GetChatRoomMembers(int roomId) {
    final $url = 'api/v1/rooms/member_list';
    final $params = <String, dynamic>{'room_id': roomId};
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send<dynamic, dynamic>($request);
  }

  Future<Response> GetChatRoomAdmin(int roomId) {
    final $url = 'api/v1/rooms/get_admin';
    final $params = <String, dynamic>{'room_id': roomId};
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send<dynamic, dynamic>($request);
  }

  Future<Response> updateChatRoom(
      int roomId, String roomName, int roomAdminId, List<int> roomUsers) {
    final $url = 'api/v1/rooms/update';
    final $params = <String, dynamic>{
      'room[id]': roomId,
      'room[name]': roomName,
      'room[admin_id]': roomAdminId,
      'room[user_ids][]': roomUsers
    };
    final $request =
        Request('PATCH', $url, client.baseUrl, parameters: $params);
    return client.send<dynamic, dynamic>($request);
  }

  Future<Response> deleteChatRoom(int roomId) {
    final $url = 'api/v1/rooms/destroy';
    final $params = <String, dynamic>{'room_id': roomId};
    final $request =
        Request('DELETE', $url, client.baseUrl, parameters: $params);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> setEmail(
      int taskId,
      int pathId,
      String receiverEmail,
      String subject,
      String body,
      List<http.MultipartFile> multipartFiles) {
    final $url = 'api/v1/problem_solution_paths/email_details';
    final $parts = <PartValue>[
      PartValue<int>('task_id', taskId),
      PartValue<int>('path_id', pathId),
      PartValue<String>('receiver_email', receiverEmail),
      PartValue<String>('subject', subject),
      PartValue<String>('body', body),
      PartValueFile<List<http.MultipartFile>>('file', multipartFiles)
    ];
    final $request =
        Request('POST', $url, client.baseUrl, parts: $parts, multipart: true);
    return client.send<dynamic, dynamic>($request);
  }

  Future<Response> sendEmail(int taskId, int pathId) {
    final $url = 'api/v1/problem_solution_paths/send_email';
    final $params = <String, dynamic>{'task_id': taskId, 'path_id': pathId};
    final $request = Request('POST', $url, client.baseUrl, parameters: $params);
    return client.send<dynamic, dynamic>($request);
  }

  Future<Response> getInvoiceList() {
    final $url = 'api/v1/invoices/list';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }

  Future<Response> getInvoice(int invoiceId) {
    final $url = 'api/v1/invoices/show';
    final $params = <String, dynamic>{'invoice_id': invoiceId};
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send<dynamic, dynamic>($request);
  }

  Future<Response> deleteInvoice(int invoiceId) {
    final $url = 'api/v1/invoices/destroy';
    final $params = <String, dynamic>{'invoice_id': invoiceId};
    final $request =
        Request('DELETE', $url, client.baseUrl, parameters: $params);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> uploadInvoice(
      String purposeOfUse,
      String description,
      String date,
      double amount,
      double vat,
      double tax,
      String comment,
      List<http.MultipartFile> multipartFiles) {
    final $url = 'api/v1/invoices/create';
    //final $headers = {'Content-Disposition': 'inline'};
    final $parts = <PartValue>[
      PartValue<String>('invoice[purpose_of_use]', purposeOfUse),
      PartValue<String>('invoice[description]', description),
      PartValue<String>('invoice[date]', date),
      PartValue<double>('invoice[amount]', amount),
      PartValue<double>('invoice[vat]', vat),
      PartValue<double>('invoice[tax]', tax),
      PartValue<String>('invoice[comment]', comment),
      PartValueFile<List<http.MultipartFile>>('file', multipartFiles)
    ];
    final $request =
        Request('POST', $url, client.baseUrl, parts: $parts, multipart: true);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> updateInvoice(
      int id,
      String purposeOfUse,
      String description,
      String date,
      double amount,
      double vat,
      double tax,
      String comment,
      List<http.MultipartFile> multipartFiles,
      List<String> attachmentUrls) {
    final $url = 'api/v1/invoices/update';
    //final $headers = {'Content-Disposition': 'inline'};
    final $parts = <PartValue>[
      PartValue<int>('invoice[id]', id),
      PartValue<String>('invoice[purpose_of_use]', purposeOfUse),
      PartValue<String>('invoice[purpose_of_use]', purposeOfUse),
      PartValue<String>('invoice[description]', description),
      PartValue<String>('invoice[date]', date),
      PartValue<double>('invoice[amount]', amount),
      PartValue<double>('invoice[vat]', vat),
      PartValue<double>('invoice[tax]', tax),
      PartValue<String>('invoice[comment]', comment),
      PartValue<List<String>>(
          'invoice[keep_attachment_link][]', attachmentUrls),
      PartValueFile<List<http.MultipartFile>>('file', multipartFiles)
    ];
    final $request =
        Request('PATCH', $url, client.baseUrl, parts: $parts, multipart: true);
    return client.send<dynamic, dynamic>($request);
  }
}
