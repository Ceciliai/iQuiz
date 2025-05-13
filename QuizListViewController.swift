//
//  QuizListViewController.swift
//  iQuiz
//
//  Created by Haiyi Luo on 5/5/25.
//

import UIKit

class QuizListViewController: UITableViewController {
    
    struct Quiz {
        let title: String
        let description: String
        let iconName: String
    }
    
    let quizzes = [
        Quiz(title: "Mathematics", description: "Numbers and logic!", iconName: "math"),
        Quiz(title: "Marvel Super Heroes", description: "Know your heroes?", iconName: "marvel"),
        Quiz(title: "Science", description: "The world around us", iconName: "science")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "iQuiz"
        self.navigationItem.backButtonTitle = "Back"
        
        print("✅ viewDidLoad called")
        NSLog("Navigation title set to: %@", self.title ?? "nil")
        NSLog("Loaded \(quizzes.count) quizzes into the list")
    }
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        NSLog("tableView:numberOfRowsInSection called — returning \(quizzes.count)")
        return quizzes.count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath)
    -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuizCell", for: indexPath)
        let quiz = quizzes[indexPath.row]
        cell.textLabel?.text = quiz.title
        cell.detailTextLabel?.text = quiz.description
        cell.imageView?.image = UIImage(named: quiz.iconName)
        
        // 打印当前 cell 内容
        print("📋 Configuring cell at row \(indexPath.row): \(quiz.title)")
        return cell
    }
    
    @IBAction func settingsTapped(_ sender: UIBarButtonItem) {
        print("⚙️ Settings button tapped")
        let alert = UIAlertController(title: "Settings",
                                      message: "Settings go here",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowQuestion",
           let destination = segue.destination as? QuestionViewController,
           let indexPath = tableView.indexPathForSelectedRow {
            destination.selectedTopic = quizzes[indexPath.row].title
        }
    }
}
