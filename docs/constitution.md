# Development Constitution & Clean Architecture 

This document establishes the architectural rules, coding standards, and governance principles for the development repository. Adherence to these guidelines is mandatory for all features and pull requests.

---

## 1. Minimal Stack & Dependency Management
* **Core Foundation:** Built strictly using **Flutter** and **Dart**.
* **Third-Party Packages:** Any additional third-party package or dependency must be justified, reviewed, and approved within the feature specification (`spec.md`) before being added to `pubspec.yaml`.
* **Block Approved:**
  * HTTP client library (restricted to the Data/Infrastructure layer).
  * Geolocation / GPS services (restricted to the Data/Infrastructure layer).

---

## 2. Specification-Driven Development (Spec-to-Code)
* **Strict Traceability:** No code enters the repository without an active and approved specification document located at `specs/<feature-id>/spec.md`.
* **Minimum Spec Requirements:**
  1. Clearly defined Use Cases.
  2. Input / Output data contracts and repository interfaces.
  3. Domain failure and exception handling strategies.
  4. Explicitly declared persistence mechanism.

---

## 3. Clean Architecture & Layer Separation
The codebase strictly adheres to the **Dependency Rule**: inner layers know nothing about outer layers.

```
┌─────────────────────────────────────────────────────────┐
│                    Presentation Layer                   │
│   (Widgets, State Management, ViewModels / Controllers) │
└────────────────────────────┬────────────────────────────┘
                             │ invokes
                             ▼
┌─────────────────────────────────────────────────────────┐
│                      Domain Layer                       │
│    (Entities, Use Cases / Interactors, Repo Contracts)  │
└────────────────────────────▲────────────────────────────┘
                             │ implements
┌────────────────────────────┴────────────────────────────┐
│                       Data Layer                        │
│     (Data Sources, DTO Models, Repository Implementations)│
└─────────────────────────────────────────────────────────┘
```

### A. Domain Layer (`lib/features/<feature>/domain` or `lib/core/domain`)
* **Responsibilities:** Enterprise & application business rules, entities, and use cases.
* **Contracts:** Defines interfaces/abstract classes for repositories and external gateways (*Dependency Inversion*).
* **Zero Framework Dependency:** Must be written in **pure Dart**. Importing `package:flutter/...` or UI/infrastructure packages into the domain layer is strictly forbidden.

### B. Data Layer (`lib/features/<feature>/data`)
* **Responsibilities:** Implements domain repository interfaces, manages local and remote data sources, handles serialization, and maps Data Transfer Objects (DTOs) to domain Entities.
* **Encapsulation:** External API models, database schemas, and networking logic are fully encapsulated here.

### C. Presentation Layer (`lib/features/<feature>/presentation`)
* **Responsibilities:** Renders UI components (Widgets) and manages transient presentation state.
* **Delegation:** Views only render UI and capture user events. All business logic execution is delegated to **Use Cases**. Direct access to repositories or data sources from UI widgets is prohibited.

---

## 4. Testing & Quality Assurance
* **Continuous Integration:** The complete test suite (`flutter test`) must pass with 100% success on every commit and pull request.
* **Coverage Standards:**
  * All domain logic (Entities, Value Objects, Use Cases) requires isolated unit tests with mock dependencies.
  * Every bug fix must include a corresponding regression test verifying the resolution before merge.

---

## 5. Persistence & State Management
* **Declared Storage:** All data persistence must be executed through a domain repository interface backed by a concrete data source explicitly documented in the feature spec.
* **No Ad-Hoc Persistence:** Direct writes to disk, preferences, or local storage outside the designated data layer are strictly disallowed.
* **Ephemeral State:** In-memory UI/session state does not qualify as persistence and must remain strictly scoped to the presentation layer.

---

## 6. Language & Naming Conventions
* **Technical Codebase (English):** All identifiers, class names, method signatures, variable names, file names, folder paths, commit messages, and automated tests must be written in **English**.
* **User Interface (Spanish):** All user-facing strings, validation messages, and UI labels must be presented in **Spanish**, centralized via standard internationalization/localization (`l10n`) mechanisms.
