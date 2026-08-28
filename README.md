# Waypoint — Mini Travel Expense App

Waypoint is a clean, modern mini travel expense app built in Flutter following target enterprise guidelines: Riverpod codegen, Clean Architecture, freezed immutability, functional error handling with `fpdart`, `get_it` dependency injection, `go_router` navigation with redirect guards, and unit-tested domain logic.

---

## 01 Stack & Architecture Decisions

- **State Management (`flutter_riverpod` + `riverpod_generator`)**:
  Used `@riverpod` annotations and `AsyncNotifier` over legacy Provider for compile-time safety, seamless async state handling (data/loading/error), and testable notifiers without manual `ProviderBase` boilerplate.
- **Clean Architecture Structure**:
  Strict per-feature split into `data`, `domain`, and `presentation` layers. The `domain` layer is pure Dart with zero Flutter dependencies, allowing domain use cases to be tested without widget test harnesses.
- **Models (`freezed` + `json_serializable`)**:
  Immutable domain entities and data layer DTOs with copyWith, equality, and JSON serialization out of the box.
- **Error Handling (`fpdart` `Either<Failure, T>`)**:
  Exceptions are caught at the outermost data source edge and converted into typed `Failure` union variants (`Failure.serverError`, `Failure.unauthorized`, `Failure.unexpected`).
- **Dependency Injection (`get_it`)**:
  A single `locator.dart` registers all repositories, data sources, and use cases lazily. Repositories are exposed via abstract interfaces to allow mock injection in tests.
- **Navigation (`go_router`)**:
  Uses `ShellRoute` for app layout and redirect-based auth guard that automatically redirects to `/login` when no authenticated session exists.

---

## 02 Key Assumptions & Documented Decisions

1. **Mock Auth**: Accepts any well-formed email & password (password >= 4 chars) and stores a token via `TokenStorage`.
2. **Seeded Expense Data**: Pre-seeded with 9 mock expense items across categories (Meals, Transit, Lodging, Other).
3. **Currency**: Fixed to USD (`$`) for this exercise, while keeping a `currency` property on the `Expense` entity for future multi-currency support without breaking changes.
4. **Expense Detail**: Implemented as a clean read-only view accessible by tapping any row in the expense list, with an edit option that reuses the form.

---

## 03 Getting Started & Running the App

### Prerequisites
- Flutter SDK `^3.12` or higher
- Dart SDK `^3.12`

### Setup & Run Steps

1. **Fetch dependencies**:
   ```bash
   flutter pub get
   ```

2. **Generate code (Freezed & Riverpod)**:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

3. **Run unit & widget tests**:
   ```bash
   flutter test
   ```

4. **Run static analysis**:
   ```bash
   flutter analyze
   ```

5. **Build APK**:
   ```bash
   flutter build apk --debug
   ```
