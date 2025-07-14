import 'dart:convert';

import 'package:hsp_mobile/core/models/dtos/response/base_response.dart';
import 'package:hsp_mobile/core/models/task_claim.dart';
import 'package:hsp_mobile/core/utils/constants.dart';
import 'package:hsp_mobile/core/utils/shared_prefs_utils.dart';
import 'package:http/http.dart' as http;

class TaskService {
  final String baseUrl = '${AppConstants.baseLocalUrl}/job/taskclaims';

  // Headers cho các yêu cầu HTTP
  Future<Map<String, String>> get _headers async {
    final token = await SharedPrefsUtils.getAccessToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  //fetch task claims
  Future<BaseResponse<List<TaskClaim>>> fetchClaimedTasks() async {
    try {
      //get url
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: await _headers,
      );
      //map to json
      final json = jsonDecode(response.body);
      return BaseResponse.fromJson(
        json,
        (data) => (data as List).map((e) => TaskClaim.fromMap(e)).toList(),
      );
    } catch (e) {
      return BaseResponse<List<TaskClaim>>(
        statusCode: 500,
        message: 'Failed to fetch task: $e',
      );
    }
  }


  //fetch task claim by id

  //create task claim

  //update task claim

  //search task claim

  //change status

  //search task claim by userID

  //search task claim by booking detailId
}
