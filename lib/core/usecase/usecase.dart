abstract interface class IUsecase<T> {
  Future<T> call();
}
