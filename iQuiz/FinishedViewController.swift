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
        
        // 设置成绩和信息
        scoreLabel.text = "You got \(totalCorrect) out of \(totalQuestions) correct."

        if totalCorrect == totalQuestions {
            messageLabel.text = "🎉 Perfect!"
        } else if totalCorrect >= totalQuestions / 2 {
            messageLabel.text = "😊 Almost!"
        } else {
            messageLabel.text = "💪 Keep practicing!"
        }

        // 👈 添加左滑返回手势
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeLeftToHome))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)

        // 👀 提示文字
        gestureHintLabel.text = "⬅️ Swipe left to return to topic list"
        gestureHintLabel.textColor = .gray
        gestureHintLabel.font = UIFont.italicSystemFont(ofSize: 14)
        gestureHintLabel.numberOfLines = 2
    }

    // 👈 处理左滑退出
    @objc func handleSwipeLeftToHome() {
        print("⬅️ Swipe left on FinishedViewController — returning to home")
        navigationController?.popToRootViewController(animated: true)
    }

    // 点击 "Next" 按钮也回主页面
    @IBAction func nextTapped(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
}
