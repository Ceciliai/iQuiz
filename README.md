# iQuiz – Part 1: App Scaffolding

## 📝 Assignment Summary
This is Part 1 of a multi-part iOS app project for INFO 449.  
The goal is to scaffold the app UI using Storyboard and UIKit.

## ✅ Requirements for Part 1

- A TableView displays **3 quiz topics**:
  - Mathematics
  - Marvel Super Heroes
  - Science
- Each cell must include:
  - An **icon image**
  - A **title** (up to 30 characters)
  - A **short description** sentence
- A **navigation bar** at the top with a **Settings** button.
- Tapping **Settings** shows a UIAlertController with:
  - Message: "Settings go here"
  - One OK button

## 📌 Notes
- No networking yet — quizzes are stored in a hard-coded local array.
- App uses Storyboard for layout and navigation.

## 🧪 Grading Rubric (5 pts)
- TableView appears with non-empty cells: 1 point.
- Correct number of cells: 1 point.
- Cells display correct data: 1 point.
- Cells include icons and subtext: 1 point.
- Settings alert functions correctly: 1 point.

## iQuiz – Part 2: App Functionality (INFO 448)

This version includes all required features, scene transitions, and navigation logic for the iQuiz app.

---

### ✅ Features Implemented

- Topic selection (Mathematics, Marvel Super Heroes, Science)
- Question screen:
  - Dynamic question text and answer buttons
  - Only one answer selectable at a time
  - Submit button enabled after selection
- Answer screen:
  - Displays correct answer and user’s choice
  - Message indicating correctness
  - "Next" button to proceed
- Finished screen:
  - Shows score (e.g., "You got 2 out of 3 correct.")
  - Summary label (e.g., "Perfect!" or "Almost!")
  - "Next" button returns to home

---

### ⭐ Extra Credit Implemented

**1. Swipe Gestures**
- **Swipe left** on **Question screen**: acts as "Submit"
- **Swipe left** on **Answer screen**: acts as "Next"
- **Swipe right** on **any screen**: immediately quits the quiz and returns to the topic list

Note: I intentionally reversed the spec’s original direction to better match user expectations.  
In most apps, **swipe left = go forward**, **swipe right = go back**. I wanted to make the UX feel intuitive.

**2. Discoverability**
- Each screen has a subtle label explaining swipe behavior (e.g., “👉 Swipe left to submit”)
- Uses `.italicSystemFont` and light gray to avoid visual noise

---

### 🔁 Navigation Flow

- Tap topic → Question screen
- Submit → Answer screen
- Next → next Question or Finished screen
- Finished → back to topic list
- All scenes support swipe to navigate or quit

---

### 🛠 Built With

- Swift
- UIKit + Storyboard
- Xcode 15+

---

### ✅ Status

**All Part 2 requirements and all Extra Credit are fully implemented.**

