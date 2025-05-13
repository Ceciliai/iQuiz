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
    
    @IBAction func nextTapped(_ sender: UIButton) {
        if isLastQuestion {
            
            performSegue(withIdentifier: "ShowFinished", sender: nil)
        } else {
           
            navigationController?.popViewController(animated: true)
        }
    }
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
        enableRightSwipeToQuit()

        questionLabel.text = questionText
        correctAnswerLabel.text = "Answer: \(correctAnswerText ?? "N/A")"
        resultLabel.text = userIsCorrect ? "✅ Correct!" : "❌ Wrong."
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeLeft))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
        
        gestureHintLabel.text = "👉 Swipe left to continue\n⬅️ Swipe right to quit"
        gestureHintLabel.textColor = .gray
        gestureHintLabel.font = UIFont.italicSystemFont(ofSize: 14)
        gestureHintLabel.numberOfLines = 2
    }
    
    @objc func handleSwipeLeft() {
        print("👉 Swipe left detected on AnswerViewController")
        nextTapped(UIButton())
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowFinished",
           let destination = segue.destination as? FinishedViewController {
            destination.totalCorrect = totalCorrect
            destination.totalQuestions = totalQuestions
        }
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
