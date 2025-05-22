# iQuiz: Offline-Capable iOS Quiz App

**iQuiz** is a customizable, offline-compatible iOS quiz app built with Swift and UIKit.  
Users can configure the quiz source URL and refresh interval through the iOS Settings app, while the app automatically caches downloaded quizzes for offline use. iQuiz is designed to demonstrate resilient mobile design, offline-first thinking, and dynamic configuration with minimal user effort.

---

## 🎯 Key Features

- 📥 **Dynamic Quiz Loading**  
  Quizzes are fetched from a user-defined JSON URL using `URLSession`.

- 📴 **Full Offline Support**  
  All quiz data is cached locally as JSON. If network access fails, the app seamlessly falls back to the most recent downloaded copy.

- ⚙️ **Native Settings Integration**  
  Through `Settings.bundle`, users can:
  - Set a custom JSON URL
  - Set auto-refresh interval (e.g. 60 seconds)

- 🔄 **Auto Refresh**  
  A timer automatically triggers quiz reloading based on the configured interval.

- 🚫 **Graceful Network Error Handling**  
  Network failures trigger fallback to cached data, ensuring continuity of experience.

---

## 🧠 Motivation

The goal of iQuiz is to explore building robust iOS applications that remain functional even in unstable network environments. It demonstrates:

- How to use `Settings.bundle` for native settings UI
- How to persist data using the file system
- How to combine user-configured settings with asynchronous data loading
- How to gracefully recover from failed network calls

---

## 📂 JSON Data Format

The app consumes JSON with the following structure:

```json
[
  {
    "title": "Math",
    "desc": "Test your math skills!",
    "questions": [
      {
        "text": "What is 2 + 2?",
        "answer": "2",
        "answers": ["3", "4", "5", "6"]
      }
    ]
  }
]
