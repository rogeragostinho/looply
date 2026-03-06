abstract class AbstractService<T, R> {

  R repository;

  AbstractService(this.repository);

  Future<int> insert(T item);
  Future<int> update(T item);
  Future<int> delete(int id);
  Future<T?> getById(int id);
  Future<List<T>> getAll();
  
}