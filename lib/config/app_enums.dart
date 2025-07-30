enum ApiStatus { initial, loading, success, failure }

enum OperationStatus { initial, loading, success, failure }

enum ChooseApp {
  ar('AR'),
  caricature('Caricature'),
  boomerang('Boomerang'),
  collage('Collage');

  final String name;
  const ChooseApp(this.name);
}
