# LingoBreeze – My Vocabulary

A premium, production-quality language learning module called **LingoBreeze – My Vocabulary**. This feature enables language learners to dynamically retrieve vocabulary words from a hosted backend, review meanings, and save them in real-time to a **Firebase Firestore** database.

The project features a clean, highly optimized **Bloc state management** architecture, Material 3 layouts, live search filtering, pull-to-refresh sync, and seamless database operations.

---

## Technical Stack
- **Frontend**: Flutter, Bloc, Dio (Networking), Firebase Firestore
- **Backend**: Node.js,
- **Database**: Cloud Firestore

---

## Folder Structure

### 1. Frontend (`flutter-app/`)
The frontend is organized in a clean, flat, feature-focused folder layout:
```text
lib/
├── features/
│   ├── api/
│   │   └── api.dart                                  # HTTP Service (Dio client)
│   └── vocabulary/
│       ├── bloc/
│       │   ├── vocabulary_bloc.dart                  # Bloc business logic & Firestore interactions
│       │   ├── vocabulary_event.dart
│       │   └── vocabulary_state.dart
│       ├── models/
│       │   └── vocabulary_model.dart                 # Data serialization & schemas (JSON/Firestore)
│       └── view/
│           ├── vocabulary_screen.dart                # Main Vocabulary dashboard screen
│           └── widgets/
│               ├── add_word_bottom_sheet.dart        # Word selection sheet
│               ├── shimmer_loading.dart              # Shimmer placeholders
│               └── word_card.dart                    # Word card item widget
├── firebase_options.dart                              # Firebase configurations
└── main.dart                                         # Entry point & Dependency Injection (GetIt)
```

### 2. Backend (`backend/`)
```text
backend/
├── src/
│   ├── controllers/
│   │   └── words.controller.js                       # Route request handler
│   ├── routes/
│   │   └── words.routes.js                           # Express GET /words route
│   ├── services/
│   │   └── words.service.js                          # Vocabulary Hindi dataset service
│   └── app.js                                        # Express configuration & CORS middlewares
├── .env                                              # Environment configurations
└── package.json                                      # Script and dependency registry
```

---

## Features Implemented

1. **Vocabulary Retrieval**: Fetches a dataset of **40 high-quality vocabulary words** containing English terms, definitions, and Hindi translations (e.g., *Resilient*, *Serendipity*, *Aesthetic*, *Ephemeral*).
2. **Add Word Flow**: Tap the Floating Action Button to slide up a **Modal Bottom Sheet**. It fetches words from the backend, validates choices (disables words already saved in your list), and saves selected words to Firestore.
3. **Interactive Dashboard**: Displays saved words in Material 3 cards featuring curved corners, elevation, and distinct color accents.
4. **Live Search Bar**: Real-time local search that filters words dynamically by word name, English meaning, or Hindi translation.
5. **Safety Word Deletion**: Added trash buttons next to word cards with safety confirmation dialogs to delete documents from Firestore instantly.
6. **Pull-to-Refresh**: Built-in pull-to-refresh swipe support on both filled lists and empty states.
7. **Multi-State UI States**: Features modern shimmering cards during load, custom illustrations for empty listings, and detailed error screens.

---

## Setup & Running Instructions

### 1. Run Node.js Backend Locally
1. Navigate to the backend folder:
   ```bash
   cd backend
   ```
2. Install dependencies:
   ```bash
   npm install
   ```
3. Run the development server:
   ```bash
   npm start
   ```
   The backend is configured to listen on port `3000`.

### 2. Hosted Backend API
The backend is deployed live at:
`https://lingobreeze-dpe5.onrender.com`

- **Endpoint**: `GET https://lingobreeze-dpe5.onrender.com/words`

### 3. Run Flutter App
The Flutter application is pre-configured to connect directly to the hosted Render backend by default.

1. Navigate to the app folder:
   ```bash
   cd flutter-app
   ```
2. Retrieve packages:
   ```bash
   flutter pub get
   ```
3. Run the application:
   ```bash
   flutter run
   ```

*Note: If you want to run the app pointing to a different backend server (like a local IP), compile/launch using `--dart-define`:*
```bash
flutter run --dart-define=BACKEND_URL=http://<YOUR_IP>:3000
```

### 4. Firebase Configuration
To link your own Firestore instance:
1. Initialize a project on the [Firebase Console](https://console.firebase.google.com/).
2. Under **Firestore Database**, click **Create Database** and start in test mode.
3. Run `flutterfire configure` to generate/overwrite `firebase_options.dart` inside the `lib/` folder, or add native configuration files (`google-services.json` on Android / `GoogleService-Info.plist` on iOS).

---

## AI Contribution

- **UI/UX Quality**: 95% (Dark mode support, custom shimmers, slide-up sheet, search view, confirmation dialogs)
- **Flutter Code Quality**: 95% (Clean folder architecture, dependency injection, and Bloc state management)
- **Backend API & Dataset**: 90% (Created 40 Hindi words list, clean routing controller)
- **Architecture Decisions**: 90% (Integrated Firebase initialization fallback and unified model schemas)
