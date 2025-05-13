//
//  FinishedViewController.swift
//  iQuiz
//
//  Created by Haiyi Luo on 5/12/25.
//

import UIKit

class FinishedViewController: UIViewController {
    var totalCorrect: Int = 0
    var totalQuestions: Int = 0

    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var gestureHintLabel: UILabel!



    override func viewDidLoad() {
        super.viewDidLoad()
        enableRightSwipeToQuit()
        
        scoreLabel.text = "You got \(totalCorrect) out of \(totalQuestions) correct."

        if totalCorrect == totalQuestions {
            messageLabel.text = "🎉 Perfect!"
        } else if totalCorrect >= totalQuestions / 2 {
            messageLabel.text = "😊 Almost!"
        } else {
            messageLabel.text = "💪 Keep practicing!"
        }
        
        gestureHintLabel.text = "⬅️ Swipe right to return to topic list"
        gestureHintLabel.textColor = .white 
        gestureHintLabel.font = UIFont.italicSystemFont(ofSize: 14)
        gestureHintLabel.numberOfLines = 2

    }
    
    @IBAction func nextTapped(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func enableRightSwipeToQuit() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeRightToQuit))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
    }
    
    @objc func handleSwipeRightToQuit() {
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
