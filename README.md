📦 Merchant Product Management App (Flutter)

A production-grade Flutter application demonstrating clean architecture, offline-first design, automatic background sync, and scalable state management using GetX.

This project was built as part of a Senior Mobile Engineer (Flutter) technical assessment and focuses on system design and engineering quality, not visual polish.

🚀 Features
Core Functionality

📄 Product list with pagination (infinite scroll)

🔍 Product detail view

➕ Create product

✏️ Edit product

📡 Pull-to-refresh to fetch latest data

Offline-First Capabilities

App works fully offline

Create/update operations are stored locally first

Changes sync automatically when internet is restored

Unsynced products show a “Pending Sync” indicator

Smart Sync Engine

Background sync triggered on connectivity restoration

Automatic retry of failed sync operations

No data loss during offline usage

Production-Grade States

Loading indicators

Error handling with retry

Offline banner

Sync status indicators

Conflict detection strategy

🧠 Architecture Overview

The app follows Clean Architecture principles to ensure scalability, testability, and separation of concerns.

lib/
├── core/                # Shared utilities, connectivity, network config
├── features/
│   └── products/
│       ├── presentation/  # UI + GetX controllers
│       ├── domain/        # Entities, repositories, use cases
│       └── data/          # Models, data sources, repository implementation
└── injection_container.dart  # Dependency injection setup

Layer Responsibilities
Layer	Responsibility
Presentation	UI & state (GetX controllers only here)
Domain	Business logic, use cases, repository contracts
Data	Local DB, API calls, offline-first implementation
🧩 State Management

The app uses GetX for presentation-layer state management:

Reactive UI updates

Lightweight and performant

Controllers interact only with use cases, never with data sources directly

💾 Offline-First Strategy

This app follows a local-first architecture.

Source of Truth = Local Database (Hive)
Action	Behavior
View products	Read from local DB
Pull to refresh	Fetch from API → Save locally
Create product	Saved locally as isSynced = false
Update product	Updated locally as isSynced = false
Internet restored	Background sync pushes changes

Each product includes:

isSynced → whether server is up to date

syncAction → create/update

updatedAt → conflict detection

🔄 Automatic Sync Mechanism

A SyncService listens to connectivity changes.

Sync Flow
Offline → User edits → Saved locally (unsynced)
Online  → SyncService triggers
        → Unsynced items pushed to server
        → Marked as synced locally
        → Latest server data fetched


Failed sync attempts remain unsynced and retry automatically later.

📡 Connectivity Awareness

The app uses connectivity_plus to detect network state:

Displays a "You are offline" banner when disconnected

Automatically resumes syncing when connection returns

⚔️ Conflict Handling Strategy

Conflicts may occur if the server has a newer version of a product than the local copy.

Detection

When syncing updates, if the backend returns HTTP 409 Conflict, it indicates:

local.updatedAt < server.updatedAt

Resolution Strategy

Fetch the latest server version

Mark the product locally with hasConflict = true

UI notifies user of the conflict

User chooses resolution:

Option	Result
Keep My Changes	Local version is re-sent to server
Use Server Version	Local data replaced with server version

This prevents silent overwrites and keeps the user in control.

🛠 Tech Stack
Purpose	Technology
Framework	Flutter (latest stable)
State Management	GetX
Architecture	Clean Architecture
Networking	Dio
Local Storage	Hive
Connectivity	connectivity_plus
Dependency Injection	get_it
🧪 Testability

The domain layer is completely independent of Flutter and external libraries.

Use cases can be unit tested

Repository is abstracted via interfaces

Business logic is isolated from UI

▶️ How to Run the Project
1️⃣ Start the Mock Backend

Install Node.js (v16+)

cd mock-backend
npm install
npx json-server --watch db.json --port 3000


Backend runs at:

http://localhost:3000


Test in browser:

http://localhost:3000/products

2️⃣ Run Flutter App
flutter pub get
flutter run

📱 Platform Notes

If running on a physical device or emulator:

Platform	Base URL
Android Emulator	http://10.0.2.2:3000

iOS Simulator	http://localhost:3000

Update the base URL in DioClient if needed.

🎯 Engineering Decisions & Trade-offs
Decision	Reason
Hive for local DB	Fast, lightweight, great for offline caching
GetX	Simple, performant, minimal boilerplate
Local-first approach	Guarantees usability without network
Event-driven sync	More efficient than polling
Manual conflict resolution	Prevents silent data loss
✅ Summary

This project demonstrates:

Scalable Flutter architecture

Offline-first system design

Background sync engine

Conflict resolution strategy

Clean separation of concerns

Production-style engineering practices

This is not just a CRUD app — it’s a resilient, real-world mobile data system.