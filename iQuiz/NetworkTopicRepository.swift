//
//  NetworkTopicRepository.swift
//  iQuiz
//
//  Created by Haiyi Luo on 5/13/25.
//

import Foundation

class NetworkTopicRepository: TopicRepository {
    private let urlString: String

    init(urlString: String) {
        self.urlString = urlString
    }

    /// 从网络加载题库 JSON 并解析成 Topic 对象列表
    func fetchTopics(completion: @escaping ([Topic]) -> Void) {
        // 1. 验证 URL 是否有效
        guard let url = URL(string: urlString) else {
            print("❌ Invalid URL: \(urlString)")
            completion([])
            return
        }

        // 2. 发起网络请求
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            // 3. 检查是否成功返回数据
            guard let data = data, error == nil else {
                print("❌ Network request failed: \(error?.localizedDescription ?? "Unknown error")")
                completion([])
                return
            }

            do {
                // 🔍 顶层 JSON 是数组（而不是字典）
                if let topicsArray = try JSONSerialization.jsonObject(with: data) as? [[String: Any]] {
                    NSLog("📦 JSON parsed — total \(topicsArray.count) topics")

                    let topics: [Topic] = topicsArray.compactMap { topicDict -> Topic? in
                        guard let title = topicDict["title"] as? String,
                              let desc = topicDict["desc"] as? String,
                              let questionsArray = topicDict["questions"] as? [[String: Any]] else {
                            print("⚠️ Skipping invalid topic entry")
                            return nil
                        }

                        let questions = questionsArray.compactMap { questionDict -> Question? in
                            guard let text = questionDict["text"] as? String,
                                  let answerStr = questionDict["answer"] as? String,
                                  let answer = Int(answerStr),
                                  let answers = questionDict["answers"] as? [String] else {
                                print("⚠️ Skipping invalid question entry")
                                return nil
                            }

                            return Question(text: text, options: answers, correctIndex: answer)
                        }

                        return Topic(title: title, desc: desc, questions: questions)
                    }

                    DispatchQueue.main.async {
                        completion(topics)
                    }

                } else {
                    print("❌ JSON root is not an array")
                    DispatchQueue.main.async {
                        completion([])
                    }
                }

            } catch {
                print("❌ Failed to parse JSON: \(error)")
                DispatchQueue.main.async {
                    completion([])
                }
            }

        }

        task.resume()
    }
}

