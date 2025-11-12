import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/concours.dart';
import '../models/candidate.dart';
import '../models/transaction.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:8000/api';
  
  final Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  Future<Map<String, String>> _getHeaders() async {
    // Ici vous pouvez ajouter le token d'authentification si nécessaire
    return headers;
  }

  // CONCOURS
  Future<List<Concours>> getConcoursList() async {
    final response = await http.get(
      Uri.parse('$baseUrl/concours'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Concours.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load concours');
    }
  }

  Future<Concours> getConcoursDetails(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/v1/admin/concours/$id'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return Concours.fromJson(data['concour']);
    } else {
      throw Exception('Failed to load concours details');
    }
  }

  // CANDIDATES
  Future<List<Candidate>> getCandidatesByConcours(int concoursId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/v1/admin/concours/$concoursId/candidates'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> candidatesData = data['candidates'];
      return candidatesData.map((json) => Candidate.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load candidates');
    }
  }

  Future<Map<String, dynamic>> getCandidateDetails(int candidateId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/v1/admin/candidates/$candidateId'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load candidate details');
    }
  }

  // TRANSACTIONS
  Future<Map<String, dynamic>> createVoteTransaction({
    required int concourId,
    required int candidateId,
    required String payerLastName,
    required String payerFirstName,
    required int votesRequested,
    required String paymentMethod,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/v1/votes'),
      headers: await _getHeaders(),
      body: json.encode({
        'concour_id': concourId,
        'candidate_id': candidateId,
        'payer_lastName': payerLastName,
        'payer_firstName': payerFirstName,
        'votes_requested': votesRequested,
        'payment_method': paymentMethod,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to create transaction');
    }
  }

  // ADMIN
  Future<Map<String, dynamic>> getDashboardStats() async {
    final response = await http.get(
      Uri.parse('$baseUrl/v1/admin/dashboard/stats'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load dashboard stats');
    }
  }

  Future<List<dynamic>> getTransactionsSummary() async {
    final response = await http.get(
      Uri.parse('$baseUrl/v1/admin/transactions/summary'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data['validated'];
    } else {
      throw Exception('Failed to load transactions summary');
    }
  }
}