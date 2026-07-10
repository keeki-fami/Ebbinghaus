//
//  Model.swift
//  Ebbinghaus
//
//  Created by 櫻田聖和 on 2026/07/10.
//

import SwiftData
import SwiftUI

@Model
class ProblemData: Identifiable {
    var problem: String
    var answer: String
    var keyword: [String]
    var id: String
    
    init(problem: String, answer: String, keyword: [String]) {
        self.problem = problem
        self.answer = answer
        self.keyword = keyword
        self.id = UUID().uuidString
    }
}

enum Phase: Codable {
    case phase1
    case phase2
    case phase3
    case phase4
    case phase5
}

@Model
class ProblemSet: Identifiable {
    var setName: String
    @Relationship(deleteRule: .cascade) var problem: [ProblemData]
    var notifyDate: Date
    var status: Phase
    var id: String
    var counter: Int
    
    init(setName: String, problem: [ProblemData], notifyDate: Date, status: Phase) {
        self.setName = setName
        self.problem = problem
        self.notifyDate = notifyDate
        self.status = status
        self.id = UUID().uuidString
        self.counter = 0
    }
}
