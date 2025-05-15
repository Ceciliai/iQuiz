# 📱 iQuiz – Part 3: Networking

This project implements the networking features required for **INFO 449 – iQuiz Part 3**.

## ✅ Core Features (5 pts)

- **🌐 Download JSON from URL (2 pts)**  
  Loads quiz data from the default URL:  
  [`http://tednewardsandbox.site44.com/questions.json`](http://tednewardsandbox.site44.com/questions.json)  
  Users can also input their own JSON URL in the **Settings** panel.

- **🛠 Settings with "Check Now" (1 pt)**  
  Tapping the gear icon allows users to enter a custom JSON URL and instantly reload the quiz list with the "Check Now" button.

- **📶 Network Error Alerts (1 pt)**  
  Displays clear alerts for:
  - Empty URL
  - Invalid URL format
  - No internet connection
  - Valid URL but failed to fetch topics

- **💾 Persistent Settings (1 pt)**  
  The entered JSON URL and refresh interval are saved in `UserDefaults` and automatically reloaded on app launch.

## 🌟 Extra Credit (2 pts)

- **🔄 Pull to Refresh (1 pt)**  
  Swipe down on the quiz list to refresh the data manually.

- **⏱ Timed Auto-Refresh (1 pt)**  
  In Settings, users can specify a refresh interval (in seconds).  
  The app automatically fetches the latest quiz data at the specified interval in the background.

## 💡 How to Use

1. Launch the app — it fetches the quiz topics from either:
   - Saved custom URL from Settings, or
   - Default fallback URL.

2. Tap the gear ⚙️ icon to:
   - Enter a new JSON source
   - Set a timed refresh interval
   - Use "Check Now" to immediately reload

3. Swipe down on the list to manually refresh the data.

-------

Created by **Haiyi Luo**  
For INFO 449 – Spring 2025
