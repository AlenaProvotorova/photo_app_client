import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:photo_app/storage/token_storage.dart';
import 'package:photo_app/utils/error_handler.dart';

class UserRepository {
  final Dio _dio = Dio();

  Future<Response> signUp(String name, String email, String password) async {
    try {
      final response = await _dio.post(
        'http://localhost:3000/api/user',
        data: {'name': name, 'email': email, 'password': password},
      );
      return response;
    } catch (e) {
      throw Exception(ErrorHandler.handleError(e));
    }
  }

  Future<Response> logIn(context, String email, String password) async {
    try {
      final response = await _dio.post(
        'http://localhost:3000/api/auth/login',
        data: {'email': email, 'password': password},
      );
      TokenStorage.saveToken(response.data['token']);
      Navigator.of(context).pushNamed('/home');
      return response.data;
    } catch (e) {
      throw Exception(ErrorHandler.handleError(e));
    }
  }

  Future<Response> getUserProfile() async {
    try {
      final token = await TokenStorage.loadToken();

      _dio.options.headers['Authorization'] = 'Bearer $token';

      final response = await _dio.get(
        'http://localhost:3000/api/auth/profile',
      );
      return response;
    } catch (e) {
      throw Exception(ErrorHandler.handleError(e));
    }
  }
}
