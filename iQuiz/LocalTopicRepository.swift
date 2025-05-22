//
//  LocalTopicRepository.swift
//  iQuiz
//
//  Created by Haiyi Luo on 5/19/25.
//

import Foundation

/// A fallback topic loader that reads quiz data from a local file.
/// Used when no network connection is available or during offline mode.
class LocalTopicRepository: TopicRepository {

    /// Loads quiz topics from a local JSON file named `local_questions.json`.
    ///
    /// - Behavior: Tries to locate a stored  version of the quiz data on the device.
    ///   If the file exists and contains valid data, it reads and converts the
    ///   data into quiz topics for the app to display.
    ///
    /// - Exceptions: Returns an error if the file doesn't exist or contains invalid content.
    ///
    /// - Returns: A list of quiz topics parsed from the file, or an empty list on failure.
    func fetchTopics(completion: @escaping ([Topic], Error?) -> Void) {
        let fileManager = FileManager.default
        let documents = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documents.appendingPathComponent("local_questions.json")

        do {
            let data = try Data(contentsOf: fileURL)

            if let topicsArray = try JSONSerialization.jsonObject(with: data) as? [[String: Any]] {
                let topics: [Topic] = topicsArray.compactMap { topicDict -> Topic? in
                    guard let title = topicDict["title"] as? String,
                          let desc = topicDict["desc"] as? String,
                          let questionsArray = topicDict["questions"] as? [[String: Any]] else {
                        print("⚠️ Skipping invalid topic entry from local file")
                        return nil
                    }

                    let questions = questionsArray.compactMap { questionDict -> Question? in
                        guard let text = questionDict["text"] as? String,
                              let answerStr = questionDict["answer"] as? String,
                              let rawAnswer = Int(answerStr),
                              rawAnswer > 0,
                              let answers = questionDict["answers"] as? [String] else {
                            print("⚠️ Skipping invalid question entry from local file")
                            return nil
                        }

                        let correctIndex = rawAnswer - 1
                        return Question(text: text, options: answers, correctIndex: correctIndex)
                    }

                    return Topic(title: title, desc: desc, questions: questions)
                }

                DispatchQueue.main.async {
                    completion(topics, nil)
                }

            } else {
                // JSON format is incorrect
                DispatchQueue.main.async {
                    completion([], NSError(domain: "InvalidLocalJSON", code: 2))
                }
            }

        } catch {
            print("❌ Failed to read local JSON: \(error)")
            DispatchQueue.main.async {
                completion([], error)
            }
        }
    }
}
