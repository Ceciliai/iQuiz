//
//  TopicRepository.swift
//  iQuiz
//
//  Created by Haiyi Luo on 5/13/25.
//

protocol TopicRepository {
    func fetchTopics(completion: @escaping ([Topic], Error?) -> Void)
}

