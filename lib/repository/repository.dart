

abstract class IRepositoryApi<E> {
  final headers = {
    "content-type": "application/json",
    "accept": "application/json",
  };
  final String serverAdresse = 'http://192.168.43.186:8088';
}
