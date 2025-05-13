//
//  QuestionViewController.swift
//  iQuiz
//
//  Created by Haiyi Luo on 5/6/25.
//

import UIKit

struct Question {
    let text: String
    let options: [String]
    let correctIndex: Int
}

class QuestionViewController: UIViewController {

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet var optionButtons: [UIButton]!
    @IBOutlet weak var gestureHintLabel: UILabel!
    
    var selectedTopic: String?
    var questions: [Question] = []
    var currentQuestionIndex = 0
    var selectedAnswerIndex: Int? = nil
    var totalCorrectCount = 0
    var comingBackFromAnswerPage = false

    let allQuestions: [String: [Question]] = [
        "Mathematics": [
            Question(text: "What is 9 + 2?",
                     options: ["3", "11", "5", "6"],
                     correctIndex: 1),
            Question(text: "What is 9 × 3?",
                     options: ["27", "8", "10", "12"],
                     correctIndex: 0),
            Question(text: "What is (92+8)/4?",
                     options: ["97", "25", "20", "50"],
                     correctIndex: 1)
        ],
        "Marvel Super Heroes": [
            Question(text: "Which Marvel character is canonically a duck?",
                     options: ["Howard", "Quackson", "Donald", "Ducktor Strange"],
                     correctIndex: 0),
            Question(text: "Which hero uses a shield?",
                     options: ["Black Widow", "Captain America", "Hawkeye", "Thor"],
                     correctIndex: 1),
            Question(text: "Which Infinity Stone is red?",
                     options: ["Space", "Mind", "Reality", "Time"],
                     correctIndex: 2)
        ],
        "Science": [
            Question(text: "Which part of your body continues to grow after you die (temporarily)?",
                     options: ["Nails", "Eyes", "Liver", "Hair"],
                     correctIndex: 3),
            Question(text: "Which animal can survive in space?",
                     options: ["Octopus", "Tardigrade", "Cockroach", "Frog"],
                     correctIndex: 1),
            Question(text: "What is H₂O commonly known as?",
                     options: ["Salt", "Water", "Hydrogen", "Oxygen"],
                     correctIndex: 1)
        ]
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backButtonTitle = "Back"

        if let topic = selectedTopic {
            questions = allQuestions[topic] ?? []
        }

        // 👉 Right swipe = Submit
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeRight(_:)))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)

        // 👈 Left swipe = Quit
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeLeft(_:)))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)

        displayCurrentQuestion()
    }

    func displayCurrentQuestion() {
        guard currentQuestionIndex < questions.count else { return }

        let question = questions[currentQuestionIndex]
        questionLabel.text = question.text

        let brownColor = UIColor(red: 102/255.0, green: 54/255.0, blue: 14/255.0, alpha: 1.0)

        for (index, button) in optionButtons.enumerated() {
            button.setTitle(question.options[index], for: .normal)
            button.backgroundColor = brownColor
        }

        selectedAnswerIndex = nil

        // 👀 Discoverability
        gestureHintLabel.text = "➡️ Swipe right to submit\n⬅️ Swipe left to quit"
        gestureHintLabel.textColor = .gray
        gestureHintLabel.font = UIFont.italicSystemFont(ofSize: 14)
        gestureHintLabel.numberOfLines = 2
    }

    @IBAction func optionTapped(_ sender: UIButton) {
        guard let index = optionButtons.firstIndex(of: sender) else { return }
        selectedAnswerIndex = index

        let brownColor = UIColor(red: 102/255.0, green: 54/255.0, blue: 14/255.0, alpha: 1.0)
        let lightBrownColor = UIColor(red: 158/255.0, green: 82/255.0, blue: 20/255.0, alpha: 1.0)

        for (i, button) in optionButtons.enumerated() {
            button.backgroundColor = (i == selectedAnswerIndex) ? lightBrownColor : brownColor
        }
    }

    @IBAction func submitTapped(_ sender: UIButton) {
        guard let selectedIndex = selectedAnswerIndex else {
            print("⚠️ Submit tapped without selecting an answer.")
            return
        }

        let question = questions[currentQuestionIndex]
        let isCorrect = (selectedIndex == question.correctIndex)

        print("✅ Submit tapped — Q: \(question.text)")
        print("   Selected: \(selectedIndex), Correct: \(question.correctIndex), Result: \(isCorrect)")

        if isCorrect {
            totalCorrectCount += 1
        }

        comingBackFromAnswerPage = true
        performSegue(withIdentifier: "ShowAnswer", sender: isCorrect)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowAnswer",
           let destination = segue.destination as? AnswerViewController {
            let question = questions[currentQuestionIndex]
            let isCorrect = sender as? Bool ?? false

            destination.questionText = question.text
            destination.correctAnswerText = question.options[question.correctIndex]
            destination.userIsCorrect = isCorrect
            destination.totalQuestions = questions.count
            destination.totalCorrect = totalCorrectCount
            destination.isLastQuestion = (currentQuestionIndex == questions.count - 1)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if comingBackFromAnswerPage {
            currentQuestionIndex += 1
            if currentQuestionIndex < questions.count {
                displayCurrentQuestion()
            } else {
                navigationController?.popToRootViewController(animated: true)
            }
            comingBackFromAnswerPage = false
        }
    }

    @objc func handleSwipeRight(_ gesture: UISwipeGestureRecognizer) {
        print("➡️ Swipe right detected — submit")
        submitTapped(UIButton()) // 模拟按钮点击
    }

    @objc func handleSwipeLeft(_ gesture: UISwipeGestureRecognizer) {
        print("⬅️ Swipe left detected — quit confirmation")
        let alert = UIAlertController(title: "Quit Quiz?",
                                      message: "This will discard your progress and return to the main screen.",
                                      preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Quit", style: .destructive) { _ in
            self.navigationController?.popToRootViewController(animated: true)
        })

        present(alert, animated: true)
    }
}
