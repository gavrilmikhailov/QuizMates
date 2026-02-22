# 🎮 Party Games Collection

This application is a collection of interactive party games. The project is built using modern Apple ecosystem technologies, features a Tuist-based architecture, and is fully adapted to the strict concurrency safety standards of Swift 6.

Currently, the application includes **one game** — a custom quiz game (similar to "Jeopardy!").

## ✨ Features

### 🧠 Custom Quiz Game
- **Custom Content:** Before starting a match, users can write their own questions, categories, and answers.
- **Player Management:** Add participants and automatically track scores during the game.
- **Cloud Synchronization:** Thanks to **SwiftData + iCloud**, progress is saved automatically. You can start a game on your iPhone and seamlessly continue on your iPad or Mac (within the same Apple ID).
- **Session Flexibility:** The game can be paused at any time and resumed later across your devices, or you can completely reset the progress to start a fresh game.
- **Results:** Upon finishing a match, a results screen displays the leaderboard, points, and the winners.
- **Localization**: The game supports English and Russian localizations

## 📱 Supported Platforms
- Optimized for **iPhone** and **iPad**.
- Supported on **macOS** (Mac with Apple Silicon).

## 🛠 Tech Stack

The project is designed with a strong focus on modern architecture, data safety, and predictable code:

- **Language:** Swift 6
- **Project Generation:** [Tuist](https://tuist.io/) (Xcode project generation in code, no `.xcodeproj` or `.xcworkspace` committed to the repository).
- **UI Frameworks:** A hybrid approach utilizing **UIKit** and **SwiftUI**, leveraging the best of both paradigms.
- **Dependency Injection:** **Swinject** for loose coupling and testability.
- **Database:** SwiftData with CloudKit (iCloud) integration.
- **Concurrency:** The project is fully migrated to modern asynchronous standards:
  - `SWIFT_STRICT_CONCURRENCY = complete`
  - `ENABLE_GLOBAL_CONCURRENCY = true`

## 🚀 How to Run Locally

Since this project uses Tuist, the Xcode project files are not stored in version control. Follow these steps to generate the project and run it:

1. **Install Tuist** (if not already installed):
   ```bash
   curl -Ls [https://install.tuist.io](https://install.tuist.io) | bash
   ```
2. **Clone the repository**:
   ```bash
   git clone [https://github.com/your-username/your-repo.git](https://github.com/your-username/your-repo.git)
   cd your-repo
   ```
3. **Install dependencies**:
   ```bash
   tuist install
   ```
4. **Generate the project and open Xcode**:
   ```bash
   tuist generate
   ```

## 🗺 Roadmap
- [x] Release of the basic custom quiz mechanics
- [ ] Addition of new party games
- [ ] App localization expansion