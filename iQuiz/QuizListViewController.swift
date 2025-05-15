//
//  QuizListViewController.swift
//  iQuiz
//
//  Created by Haiyi Luo on 5/5/25.
// Edited by Cecilia on 5/13/2025
//

import UIKit

class QuizListViewController: UITableViewController {

    // 网络加载后的题库数组（替代原本写死的 quizzes）
    var topics: [Topic] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "iQuiz"
        self.navigationItem.backButtonTitle = "Back"

        NSLog("✅ viewDidLoad called — setting up quiz list")

        // Read the URL saved by the user from UserDefaults.
        //If there is none, use the default address.
        let savedURL = UserDefaults.standard.string(forKey: "quizDataURL") ??
            "http://tednewardsandbox.site44.com/questions.json"
        NSLog("🌐 Loading topics from URL: \(savedURL)")

        loadTopics(from: savedURL)
    }

    /// 根据提供的 URL 从远程服务器加载题库 JSON
    func loadTopics(from url: String) {
        NSLog("📡 Starting network fetch from \(url)")

        // Case 1: Empty URL
        if url.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            showAlert(title: "Load Failed", message: "URL is empty.")
            return
        }

        // Case 2: Invalid URL format
        guard URL(string: url) != nil else {
            showAlert(title: "Load Failed", message: "URL is invalid.")
            return
        }


        let repo = NetworkTopicRepository(urlString: url)

        repo.fetchTopics { downloadedTopics, networkError in
            DispatchQueue.main.async {
                // Case 3: No internet connection
                if let error = networkError as? URLError, error.code == .notConnectedToInternet {
                    self.showAlert(title: "Load Failed", message: "Network connection appears to be offline.")
                    return
                }

                // Case 4: Other failures
                if downloadedTopics.isEmpty {
                    self.showAlert(title: "Load Failed", message: "Failed to load quiz topics. Please check your internet connection or JSON URL")
                    return
                }

                // ✅ Success
                self.topics = downloadedTopics
                NSLog("✅ Loaded \(downloadedTopics.count) topics")
                self.tableView.reloadData()
            }
        }
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }



    /// 设置按钮点击事件：弹出 Alert，输入 URL，支持 “Check Now” 刷新
    @IBAction func settingsTapped(_ sender: UIBarButtonItem) {
        print("⚙️ Settings button tapped")

        let alert = UIAlertController(title: "Settings",
                                      message: "Enter custom JSON URL",
                                      preferredStyle: .alert)

        alert.addTextField { textField in
            textField.placeholder = "Enter JSON URL here"
            textField.text = UserDefaults.standard.string(forKey: "quizDataURL")
        }

        // 点击 Check Now：保存并重新加载
        alert.addAction(UIAlertAction(title: "Check Now", style: .default) { _ in
            guard let urlText = alert.textFields?.first?.text else { return }
            UserDefaults.standard.set(urlText, forKey: "quizDataURL")
            print("🔄 Check Now pressed — reloading from: \(urlText)")
            self.loadTopics(from: urlText)
        })

        // 只保存 URL，不立即加载
        alert.addAction(UIAlertAction(title: "Save & Close", style: .default) { _ in
            guard let urlText = alert.textFields?.first?.text else { return }
            UserDefaults.standard.set(urlText, forKey: "quizDataURL")
            print("💾 URL saved to UserDefaults: \(urlText)")
        })

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        present(alert, animated: true)
    }

    // MARK: - TableView 数据源方法

    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        NSLog("📊 numberOfRowsInSection — returning \(topics.count)")
        return topics.count
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath)
    -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuizCell", for: indexPath)
        let topic = topics[indexPath.row]

        // 设置标题与描述
        cell.textLabel?.text = topic.title
        cell.detailTextLabel?.text = topic.desc

        // 设置图片：根据 title 匹配已有资源图，否则用 default
        let title = topic.title.lowercased()
        let imageName: String

        if title.contains("marvel") {
            imageName = "marvel"
        } else if title.contains("math") {
            imageName = "math"
        } else if title.contains("science") {
            imageName = "science"
        } else {
            imageName = "default"
        }

        cell.imageView?.image = UIImage(named: imageName)

        NSLog("📋 Configuring cell at row \(indexPath.row): \(topic.title), image: \(imageName)")
        return cell
    }

    // MARK: - 页面跳转到答题界面

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowQuestion",
           let destination = segue.destination as? QuestionViewController,
           let indexPath = tableView.indexPathForSelectedRow {
            let selectedTopic = topics[indexPath.row]
            destination.questions = selectedTopic.questions
            print("➡️ Segue to QuestionViewController with topic: \(selectedTopic.title)")
        }
    }
}

