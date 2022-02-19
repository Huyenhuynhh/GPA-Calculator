//
//  Course.swift
//  GPA Calculator
//
//  Created by Huyen on 17/02/2022.
//

import Foundation

class Course {
    var id: Int!
    var title: String!
    var assessments = [Assessment]()
    var credit: Int!
    var grade: String?
    
    init(id: Int, title: String, assessments: [Assessment], credit: Int) {
        self.id = id
        self.title = title
        self.assessments = assessments
        self.credit = credit
        self.grade = getGrade()
    }
    
    func getGrade() -> String {
        var totalCourseMarks: Double = 0
        for assessment in assessments {
            totalCourseMarks += assessment.getMarks()
        }
        if totalCourseMarks >= 90 {
            self.grade = "A"
        } else if totalCourseMarks >= 80 {
            self.grade = "B"
        } else if totalCourseMarks >= 70 {
            self.grade = "C"
        } else if totalCourseMarks >= 60 {
            self.grade = "D"
        } else if totalCourseMarks < 60 {
            self.grade = "F"
        }
        return self.grade!
    }
    
    func getGradeInNumbers() -> Double {
        var gradeNumber: Double = 0
        switch self.grade {
        case "A":
            gradeNumber = 4 * Double(credit)
        case "B":
            gradeNumber = 3 * Double(credit)
        case "C":
            gradeNumber = 2 * Double(credit)
        case "D":
            gradeNumber = 1 * Double(credit)
        default:
            break
        }
        return gradeNumber
    }
}
