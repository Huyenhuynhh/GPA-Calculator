//
//  Assessment.swift
//  GPA Calculator
//
//  Created by Huyen on 17/02/2022.
//

import Foundation

class Assessment {
    var pointsTaken: Int!
    var maxPoints: Int!
    var weight: Double!
    
    init(pointsTaken: Int, maxPoints: Int, weight: Double) {
        self.pointsTaken = pointsTaken
        self.maxPoints = maxPoints
        self.weight = weight
    }
    
    func getMarks() -> Double {
        let percentage: Double = Double(pointsTaken) / Double(maxPoints)
        let marks = percentage * weight
        return marks
    }
}
