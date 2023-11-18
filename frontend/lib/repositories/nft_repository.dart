import 'package:dio/dio.dart';

import '../models/nft/user_history_response.dart';

abstract class INftRepository {
  Future<List<UserHistory>> getUserHistory(String email);
  Future<List<UserHistory>> mint(String email, num locationId);
}

class NftRepository implements INftRepository {
  final Dio _client;

  NftRepository(this._client);

  @override
  Future<List<UserHistory>> getUserHistory(String email) async {
    try {
      final response = await _client.get("/history/$email");
      return UserHistoryResponse.fromJson(response.data).data;
    } catch (error) {
      print("getUserHistory() - ERROR: $error");
      rethrow;
    }
  }

  @override
  Future<List<UserHistory>> mint(String email, num locationId) async {
    print("STARTED minting FOR $email, location $locationId");
    try {
      final response = await _client.get("/mint/$email/$locationId");
      print("FINISHED minting FOR $email, location $locationId");
      return UserHistoryResponse.fromJson(response.data).data;
    } catch (error) {
      print("mint() - ERROR: $error");
      rethrow;
    }
  }
}
