//
//  Model.swift
//  Ebbinghaus
//
//  Created by keeki-fami on 2026/07/10.
//

import SwiftData
import SwiftUI

@Model
class ProblemData: Identifiable, Hashable {
    var problem: String
    var answer: String
    var keyword: [String]
    @Attribute(.unique)
    var id: String
    var missCount: Int
    var problemSet: ProblemSet?
    var problemType: ProblemType

    
    init(problem: String, answer: String, keyword: [String], problemSet: ProblemSet? = nil, problemType: ProblemType) {
        self.problem = problem
        self.answer = answer
        self.keyword = keyword
        self.problemSet = problemSet
        self.id = UUID().uuidString
        self.missCount = 0
        self.problemType = problemType
    }
    
    static func == (lhs: ProblemData, rhs: ProblemData) -> Bool {
        lhs.problem == rhs.problem &&
        lhs.answer == rhs.answer
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(problem)
        hasher.combine(answer)
        keyword.forEach{ hasher.combine($0) }
    }
}

enum Phase: Int, Codable {
    case phase1 = 1
    case phase2 = 2
    case phase3 = 3
    case phase4 = 4
    case phase5 = 5
    case complete = 6
}

enum ProblemType: Int, Codable {
    case wordProblem = 1 // 文章題
    case oneOnOne = 2 // 例題
}

@Model
class ProblemSet: Identifiable, Hashable {
    var setName: String
    @Relationship(deleteRule: .cascade) var problem: [ProblemData]
    var notifyDate: TimeInterval
    var status: Phase
    @Attribute(.unique)
    var id: String
    var counter: Int
    
    var rest: TimeInterval {
        notifyDate - Date().timeIntervalSince1970
    }
    
    init(setName: String, problem: [ProblemData], notifyDate: TimeInterval, status: Phase) {
        self.setName = setName
        self.problem = problem
        self.notifyDate = notifyDate
        self.status = status
        self.id = UUID().uuidString
        self.counter = 0
    }
    
    static func == (lhs: ProblemSet, rhs: ProblemSet) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
