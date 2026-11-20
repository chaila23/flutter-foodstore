import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:flutter_foodstore/resource/model/cart_response_model.dart';

class CartRemoteResource {
  final Dio _dio;

  CartRemoteResource(this._dio);

  /// Mengubah error Dio menjadi pesan.
  /// Kode 401 (belum login) dikembalikan sebagai teks '401'.
  String _errorMessage(DioException e) {
    if (e.response?.statusCode == 401) {
      return e.response?.statusCode.toString() ?? '';
    }
    final data = e.response?.data;
    if (data is Map && data['message'] != null) {
      return data['message'].toString();
    }
    return e.toString();
  }

  Future<Either<String, CartResponseModel>> fetchCart() async {
    try {
      final response = await _dio.get('public/carts');
      final result = CartResponseModel.fromMap(response.data['data']);
      return Right(result);
    } on DioException catch (e) {
      return Left(_errorMessage(e));
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, String>> cartStore(
    int productId,
    int qty,
  ) async {
    try {
      final response = await _dio.post(
        'public/carts',
        data: {
          'product_id': productId.toString(),
          'qty': qty.toString(),
        },
      );
      return Right(response.data['message']?.toString() ?? '');
    } on DioException catch (e) {
      return Left(_errorMessage(e));
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, String>> incrementCart(
    int productId,
    int cartId,
  ) async {
    try {
      final response = await _dio.post(
        'public/carts/increment',
        data: {
          'product_id': productId.toString(),
          'cart_id': cartId.toString(),
        },
      );
      return Right(response.data['message']?.toString() ?? '');
    } on DioException catch (e) {
      return Left(_errorMessage(e));
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, String>> decrementCart(
    int productId,
    int cartId,
  ) async {
    try {
      final response = await _dio.post(
        'public/carts/decrement',
        data: {
          'product_id': productId.toString(),
          'cart_id': cartId.toString(),
        },
      );
      return Right(response.data['message']?.toString() ?? '');
    } on DioException catch (e) {
      return Left(_errorMessage(e));
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, String>> removeCart(
    int cartId,
  ) async {
    try {
      final response = await _dio.delete(
        'public/carts/$cartId',
      );
      return Right(response.data['message']?.toString() ?? '');
    } on DioException catch (e) {
      return Left(_errorMessage(e));
    } catch (e) {
      return Left(e.toString());
    }
  }
}