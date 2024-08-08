# Fake Store Client

![coverage][coverage_badge]
[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![License: MIT][license_badge]][license_link]

Bienvenido al paquete de **Fake Store Client**, el cual consulta datos de la siguiente API [Fake Store Api](https://fakestoreapi.com/).

![demo](https://i.giphy.com/N0azSInDDFuwLiQlL7.webp)

---

## Funcionalidades

- **Consultar lista de categorias**
- **Consultar lista de productos en base a una categoria**
- **Consultar detalle de un producto por id**
- **Consultar todos los productos disponibles**

---

## Ejemplo de uso

### Importar paquete
```dart
import 'package:fake_store_client/fake_store_client.dart';
```

### Inicializar controller

```dart
final _controller = FakeStoreController();
```

### Obtener datos

```dart
final categoriesResult = await _controller.getAllCategories();
final productsResult = await _controller.getProductsByCategory(categoryName);
final productResult = await _controller.getProductDetail(productId);
final allProductsResult = await _controller.getAllProducts();
```

### Control de errores

```dart
final result = await _controller.getAllCategories();

if (result.isFailure) {
  // ? Obtenemos el error que es una exception
  final error = result.getException();
  return;
}

// ? Obtenemos los datos
final data = result.getSuccessValue();
```

La segunda forma de hacerlo parecida al paquete dartz es asi:

```dart
final result = await _controller.getAllCategories();

result.when(
  // ? Cuando es satisfactorio 
  (success) {
    final data = success.value;
  },

  // ? Cuando ocurre un error
  (failure) {
   final error = failure.exception;
  },
);
```

---

## Librerías Utilizadas

Esta aplicación utiliza una variedad de librerías para mejorar su funcionalidad y desarrollo. A continuación, se describen las librerías y su propósito:

### Dependencias

- **dio**: Una potente librería de HTTP cliente para Dart, utilizada para realizar solicitudes a la API.

---

## Instalación y Configuración

1. **Clonar el repositorio**:
   ```bash
   git clone https://github.com/criistian14/fase-3
   cd ruta-practica
   ```

2. **Instalar dependencias**:
   ```bash
   flutter pub get
   ```
3. **Ejecutar la aplicación**:
   ```bash
   cd example
   flutter run 
   ```
---

[coverage_badge]: coverage_badge.svg
[flutter_install_link]: https://docs.flutter.dev/get-started/install
[github_actions_link]: https://docs.github.com/en/actions/learn-github-actions
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[logo_black]: https://raw.githubusercontent.com/VGVentures/very_good_brand/main/styles/README/vgv_logo_black.png#gh-light-mode-only
[logo_white]: https://raw.githubusercontent.com/VGVentures/very_good_brand/main/styles/README/vgv_logo_white.png#gh-dark-mode-only
[mason_link]: https://github.com/felangel/mason
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
[very_good_cli_link]: https://pub.dev/packages/very_good_cli
[very_good_coverage_link]: https://github.com/marketplace/actions/very-good-coverage
[very_good_ventures_link]: https://verygood.ventures
[very_good_ventures_link_light]: https://verygood.ventures#gh-light-mode-only
[very_good_ventures_link_dark]: https://verygood.ventures#gh-dark-mode-only
[very_good_workflows_link]: https://github.com/VeryGoodOpenSource/very_good_workflows
