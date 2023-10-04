Stream<int> abc() async* {
  int a = 1;
  while (a < 10) {
    yield a;
    a++;
  }
}

void main() {
  abc().listen((event) {
    print(event);
  });
}
