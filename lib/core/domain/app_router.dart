abstract class AppRouter {
  void push<T>(String routePath, {T? args});
  void go<T>(String routePath, {T? args});
  void pop();
}
