# Waypoint — Mini Travel Expense App

Waypoint is a clean, modern mini travel expense application built with Flutter following strict enterprise guidelines: **Reso Coder Clean Architecture**, Riverpod codegen, Freezed immutability, functional error handling with `fpdart`, `get_it` dependency injection, `go_router` declarative navigation, and 100% test coverage for domain and presentation components.

---

## 1. How to Run the Project

### Prerequisites
- **Flutter SDK**: `^3.12.0` (or compatible Dart `^3.9.0`)
- **Dart SDK**: `^3.12.0`

### Step-by-Step Setup

1. **Clone & Navigate**:
   ```bash
   git clone https://github.com/webapps-rvcits/waypoint.git
   cd waypoint
   ```

2. **Install Dependencies**:
   ```bash
   flutter pub get
   ```

3. **Generate Code (Freezed & Riverpod)**:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **Run Static Analysis**:
   ```bash
   flutter analyze
   ```

5. **Run All Unit & Widget Tests**:
   ```bash
   flutter test
   ```

6. **Launch Application**:
   ```bash
   flutter run
   ```

---

## 2. Key Architectural Decisions

1. **Reso Coder Feature-First Clean Architecture**:
   - Organized into isolated feature modules (`lib/features/auth/` and `lib/features/expenses/`), each containing strict `domain/`, `data/`, and `presentation/` layers, alongside `lib/core/` (`usecase.dart`, `failure.dart`, `exceptions.dart`, `storage/`).
   - **Why**: Keeps the domain layer pure (free of Flutter, Riverpod, or JSON framework dependencies). Use cases accept pure domain entities (`User`, `Expense`) and return `Either<Failure, T>`, making business logic easily testable with zero mock framework overhead.

2. **Declarative Navigation with `go_router`**:
   - Sub-routes defined under root (`/`, `/expense/new`, `/expense/edit`, `/expense/detail`) with an `authNotifierProvider` redirect guard.
   - **Why**: Prevents double navigation bugs, preserves browser back button history on Web, and seamlessly handles session state transitions (automatic redirect to `/login` when unauthenticated).

3. **Riverpod (`@riverpod` Generator) + `get_it` Dependency Injection**:
   - Presentation notifiers use `@riverpod` annotations for compile-time safety and automatic async state handling. Core singletons (repositories, datasources, usecases) are lazily registered in `locator.dart`.
   - **Why**: Decouples UI controllers from concrete implementations, allowing unit tests to inject mocks into Riverpod providers without overriding provider trees.

---

## 3. Assumptions Made

1. **Authentication Credentials & Complexity Rules**:
   - Assumed a mock server environment that accepts any RFC-compliant email and password satisfying strict complexity criteria ($\ge 6$ chars, 1 uppercase, 1 lowercase, 1 digit, 1 special character: `$,#,@,_,&,!,*,^,-,+,~`). Passwords matching `wrongpassword` or emails containing `error` simulate mock server failure.

2. **Mock Persistence & Default App State**:
   - Assumed fresh app launches start in an **Unauthenticated** state (`/login`). Upon signing in with `email@company.com` / `Pass@123`, a mock JWT token is persisted in `SharedPreferences`, and 9 pre-seeded travel expenses are rendered in the ledger.

3. **Currency Handling**:
   - Fixed default currency symbol to USD (`$`) while storing `currency` as a distinct property on the `Expense` domain entity for seamless future multi-currency support.
