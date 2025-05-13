# 📘 iQuiz – Part 2: App Functionality

## 📋 Quiz Flow

### 🧭 Selection
Choosing a quiz topic leads to the first question.

---

### ❓ Question Scene
- Displays question text
- Includes 1 or more answer options (only one selectable)
- A **"Submit"** button becomes active after selecting an option

---

### ✅ Answer Scene
- Displays question text again
- Shows the **correct answer**
- Indicates whether the user's answer was **right or wrong**
- A **"Next"** button advances the quiz

---

### 🏁 Finished Scene
- Shows descriptive feedback based on score:
  - `🎉 Perfect!`
  - `😊 Almost!`
  - `💪 Keep practicing!`
- Displays the user’s score (e.g., _2 of 3 correct_)
- A **"Next"** button returns to the topic list

---

## 🔄 Navigation Logic

- **"Next"** leads to the **next question** or the **finished scene**
- **"Back"** button returns to the **main list of topics**

---

## ✅ Grading Criteria

| Requirement                      | Points |
|----------------------------------|--------|
| Question scene functions as intended | ✅ 1 point |
| Answer scene functions as intended   | ✅ 1 point |
| Finished scene functions as intended | ✅ 1 point |
| Segues between scenes               | ✅ 1 point |
| Back button functionality          | ✅ 1 point |

---

## ✨ Extra Credit: Swipe Gestures (Up to +3)

### ✅ Swipe Right

| Scene            | Action   |
|------------------|----------|
| **Question**     | Submit answer |
| **Answer**       | Proceed to next question or result |

---

### ✅ Swipe Left

- Abandons quiz and returns to the main topic list
- All quiz progress and score are **discarded**

---

### 💡 Discoverability (1 point)
Swipe gestures are not obvious by default.  
We include **gray hint labels** on each screen to inform users:

> "➡️ Swipe right to continue / ⬅️ Swipe left to quit"

---

## 🧪 Notes

- All gesture navigation works **alongside** buttons.
- Alert confirms before quitting on Question & Answer screens.
- Finished screen returns immediately with no alert.

