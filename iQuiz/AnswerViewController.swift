//
//  AnswerViewController.swift
//  iQuiz
//
//  Created by Haiyi Luo on 5/6/25.
//

import UIKit

class AnswerViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var correctAnswerLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var gestureHintLabel: UILabel!

    // MARK: - Data from previous screen
    var questionText: String?
    var correctAnswerText: String?
    var userIsCorrect: Bool = false

    var isLastQuestion: Bool = false
    var totalCorrect: Int = 0
    var totalQuestions: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // 显示答题结果
        questionLabel.text = questionText
        correctAnswerLabel.text = "Answer: \(correctAnswerText ?? "N/A")"
        resultLabel.text = userIsCorrect ? "✅ Correct!" : "❌ Wrong."

        // 👉 Swipe right to continue
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeRight))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)

        // 👈 Swipe left to quit
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeLeftToQuit))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)

        // 👀 Discoverability label
        gestureHintLabel.text = "➡️ Swipe right to continue\n⬅️ Swipe left to quit"
        gestureHintLabel.textColor = .gray
        gestureHintLabel.font = UIFont.italicSystemFont(ofSize: 14)
        gestureHintLabel.numberOfLines = 2
    }

    // 👉 右滑继续
    @objc func handleSwipeRight() {
        print("➡️ Swipe right detected on AnswerViewController")
        nextTapped(UIButton())
    }

    // 👈 左滑退出确认
    @objc func handleSwipeLeftToQuit() {
        print("⬅️ Swipe left detected on AnswerViewController")

        let alert = UIAlertController(title: "Quit Quiz?",
                                      message: "This will discard your progress and return to the main screen.",
                                      preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Quit", style: .destructive) { _ in
            self.navigationController?.popToRootViewController(animated: true)
        })

        present(alert, animated: true)
    }

    // 🟢 “Next” 按钮 or swipe right
    @IBAction func nextTapped(_ sender: UIButton) {
        if isLastQuestion {
            performSegue(withIdentifier: "ShowFinished", sender: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }

    // 🔄 Prepare for finished screen
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowFinished",
           let destination = segue.destination as? FinishedViewController {
            destination.totalCorrect = totalCorrect
            destination.totalQuestions = totalQuestions
        }
    }
}
