# LingoBreeze – My Vocabulary

A premium, production-ready language learning feature called **LingoBreeze – My Vocabulary**. Built as a technical assignment, it showcases **Clean Architecture**, robust state management using **Bloc**, seamless integration with a **Node.js Express** backend, and real-time syncing with **Firebase Firestore**.

---

## Project Overview

**LingoBreeze – My Vocabulary** allows language learners to dynamically retrieve curated vocabulary lists from a backend service, review their meanings and translations, and save selected terms directly to their personal vocabulary list.

### Key Features:
- **Node.js API Sync**: Dynamically queries vocabulary words with definitions and Spanish translations.
- **Firebase Sync**: Saves selected words to Firestore and loads them on the dashboard.
- **Material 3 Design**: Fully supports system dark/light modes, premium typography, custom cards, and micro-animations.
- **Robust State Handling**: Shows animated shimmer cards when loading, interactive error views with retry support, and contextual snackbars on success.

---

## Architecture

This project is built using **Clean Architecture** patterns to enforce strict separation of concerns, high testability, and clean dependency management.

```
                  ┌──────────────────────┐
                  │   Presentation UI    │
                  │   (Views/Widgets)    │
                  └──────────┬───────────┘
                             │ (Uses Bloc)
                             ▼
                  ┌──────────────────────┐
                  │  Presentation Bloc   │
                  │ (Events/States/Bloc) │
                  └──────────┬───────────┘
                             │ (Dispatches Usecases)
                             ▼
                  ┌──────────────────────┐
                  │     Domain Layer     │
                  │      (Usecases)      │
                  └──────────┬───────────┘
                             │ (Calls Contract)
                             ▼
                  ┌──────────────────────┐
                  │  Domain Repository   │
                  │     (Interfaces)     │
                  └──────────┬───────────┘
                             │ (Implemented By)
                             ▼
                  ┌──────────────────────┐
                  │   Data Repository    │
                  │   (Implementation)   │
                  └──────────┬───────────┘
                             │ (Fetches From)
                             ▼
                  ┌──────────────────────┐
                  │    Data Sources      │
                  │  (Dio / Firestore)   │
                  └──────────────────────┘
```

- **Domain Layer**: Contains the core business logic, entities, and use cases. Fully decoupled from framework dependencies.
- **Data Layer**: Handles serialization/deserialization (Models) and data retrieval (DataSources) from Node.js API (via Dio) and Firestore.
- **Presentation Layer**: Handles UI layouts (Views) and state updates (Bloc).

---

## Folder Structure

### Frontend (Flutter)
```
lib/
├── features/
│   └── vocabulary/
│       ├── data/
│       │   ├── datasource/
│       │   │   └── vocabulary_remote_datasource.dart   # Dio and Firestore integration
│       │   ├── models/
│       │   │   └── vocabulary_model.dart               # Serialization & JSON/Firestore parsers
│       │   └── repositories/
│       │       └── vocabulary_repository_impl.dart      # Business logic repository glue
│       ├── domain/
│       │   ├── entities/
│       │   │   └── vocabulary_entity.dart              # Plain Dart business object
│       │   ├── repositories/
│       │   │   └── vocabulary_repository.dart           # Repository contract interface
│       │   └── usecases/
│       │       ├── get_backend_words.dart              # Usecase: fetch from Express
│       │       ├── get_saved_words.dart                # Usecase: fetch from Firestore
│       │       └── save_word.dart                      # Usecase: save to Firestore
│       └── presentation/
│           ├── bloc/
│           │   ├── vocabulary_bloc.dart                # Business logic component
│           │   ├── vocabulary_event.dart
│           │   └── vocabulary_state.dart
│           └── views/
│               ├── vocabulary_screen.dart              # Main Dashboard Screen
│               └── widgets/
│                   ├── add_word_bottom_sheet.dart      # Words selector sheet
│                   ├── shimmer_loading.dart            # Placeholder shimmer cards
│                   └── word_card.dart                  # Material 3 display card
├── injection_container.dart                             # GetIt Dependency Injector Registry
└── main.dart                                            # Firebase/App initialization bootstrap
```

### Backend (Node.js)
```
backend/
├── src/
│   ├── controllers/
│   │   └── words.controller.js                         # Express routing controller
│   ├── routes/
│   │   └── words.routes.js                             # API Routes for GET /words
│   ├── services/
│   │   └── words.service.js                            # Axios external API fetch service
│   └── app.js                                          # App configurations and CORS setups
├── .env                                                # API Environment variables
└── package.json                                        # Dependencies & scripts
```

---

## Setup & Running Instructions

### 1. Backend Setup (Node.js)
1. Navigate to the `backend` folder:
   ```bash
   cd backend
   ```
2. Install dependencies:
   ```bash
   npm install
   ```
3. Configure the `.env` file (already created with defaults):
   ```env
   PORT=3000
   EXTERNAL_WORDS_API_URL=https://raw.githubusercontent.com/neev266/mock-words-api/main/words.json
   ```
4. Start the backend in development mode:
   ```bash
   npm run dev
   ```
   The server will start on `http://localhost:3000`.

### 2. Firebase Configuration
To sync with your Firestore instance:
1. Create a Firebase project in the [Firebase Console](https://console.firebase.google.com/).
2. Add an Android/iOS/Web app to the project.
3. Download the configuration files:
   - **Android**: `google-services.json` inside `android/app/`.
   - **iOS**: `GoogleService-Info.plist` inside `ios/Runner/`.
   - **Web**: Configure the config maps during Firebase CLI initialization.
4. Enable **Cloud Firestore** in your Firebase console and create a collection named `vocabulary`.
5. Set Firestore security rules to allow read/write access for development.

### 3. Frontend Setup (Flutter)
1. From the project root, fetch Flutter packages:
   ```bash
   flutter pub get
   ```
2. Verify dependency resolution and compile check.
3. Run the application:
   ```bash
   flutter run
   ```
   *Note: When running on an Android emulator, Flutter automatically routes backend requests through port translation `10.0.2.2:3000` to contact your host backend.*

---

## AI Contribution

- **UI Design & Aesthetics**: 95% (Designed dark-mode support, gradient accents, checkmarks, dynamic sheets, and shimmer loaders)
- **Code Generation**: 95% (Generated standard Clean Architecture boilerplate, models, repositories, and UI widgets)
- **Architecture Decisions**: 90% (Set up robust dependency injection, platform-agnostic networking urls, and strict separation of concern layers)
