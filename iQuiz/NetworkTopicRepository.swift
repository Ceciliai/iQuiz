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
    func fetchTopics(completion: @escaping ([Topic], Error?) -> Void) {
        // 1. 验证 URL 是否有效
        guard let url = URL(string: urlString) else {
            print("❌ Invalid URL: \(urlString)")
            completion([], URLError(.badURL))
            return
        }

        // 2. 发起网络请求
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            // 3. 网络请求失败（如断网）
            if let error = error {
                print("❌ Network request failed: \(error.localizedDescription)")

                // ✅ 尝试读取本地 JSON
                if let localData = self.loadJsonFromLocal() {
                    print("📦 Using local JSON due to network error")
                    do {
                        if let topicsArray = try JSONSerialization.jsonObject(with: localData) as? [[String: Any]] {
                            let topics: [Topic] = topicsArray.compactMap { topicDict -> Topic? in
                                guard let title = topicDict["title"] as? String,
                                      let desc = topicDict["desc"] as? String,
                                      let questionsArray = topicDict["questions"] as? [[String: Any]] else {
                                    print("⚠️ Skipping invalid topic entry from local JSON")
                                    return nil
                                }

                                let questions = questionsArray.compactMap { questionDict -> Question? in
                                    guard let text = questionDict["text"] as? String,
                                          let answerStr = questionDict["answer"] as? String,
                                          let rawAnswer = Int(answerStr),
                                          rawAnswer > 0,
                                          let answers = questionDict["answers"] as? [String] else {
                                        print("⚠️ Skipping invalid question entry from local JSON")
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
                            return
                        }
                    } catch {
                        print("❌ Failed to parse local JSON: \(error)")
                    }
                }

                // 如果本地也失败，就返回原始错误
                completion([], error)
                return
            }

            // 4. 数据为空
            guard let data = data else {
                print("❌ No data received")
                completion([], URLError(.badServerResponse))
                return
            }

            do {
                // 👉 先保存到本地
                self.saveJsonToLocal(data: data)
                // 5. JSON 格式正确（是数组）
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
                                  let rawAnswer = Int(answerStr),
                                  rawAnswer > 0,
                                  let answers = questionDict["answers"] as? [String] else {
                                print("⚠️ Skipping invalid question entry")
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
                    print("❌ JSON root is not an array")
                    DispatchQueue.main.async {
                        completion([], NSError(domain: "InvalidJSON", code: 1))
                    }
                }

            } catch {
                print("❌ Failed to parse JSON: \(error)")
                DispatchQueue.main.async {
                    completion([], error)
                }
            }
        }

        task.resume()
    }
    
    // 保存 JSON 数据到本地文件
    func saveJsonToLocal(data: Data) {
        let fileURL = getLocalJsonURL()
        do {
            try data.write(to: fileURL)
            print("✅ JSON saved to local at \(fileURL)")
        } catch {
            print("❌ Failed to save JSON: \(error)")
        }
    }

    // 获取本地 JSON 文件路径
    func getLocalJsonURL() -> URL {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documents.appendingPathComponent("local_questions.json")
    }
    
    func loadJsonFromLocal() -> Data? {
        let fileURL = getLocalJsonURL()
        do {
            let data = try Data(contentsOf: fileURL)
            print("📂 Loaded JSON from local file")
            return data
        } catch {
            print("❌ Failed to load local JSON: \(error)")
            return nil
        }
    }

}
