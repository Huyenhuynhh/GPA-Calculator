//
//  ViewController.swift
//  GPA Calculator
//
//  Created by Huyen on 15/02/2022.
//

import UIKit

class ViewController: UIViewController {

    // MARK:- Outlets
    @IBOutlet weak var courseTitleTextField: UITextField!
    
    @IBOutlet weak var assignmentsPointTextField: UITextField!
    @IBOutlet weak var assignmentsMaxTextField: UITextField!
    @IBOutlet weak var assignmentsPercentageTextField: UITextField!
    
    @IBOutlet weak var midtermPointTextField: UITextField!
    @IBOutlet weak var midtermMaxTextField: UITextField!
    @IBOutlet weak var midtermPercentageTextField: UITextField!
    
    @IBOutlet weak var finalPointTextField: UITextField!
    @IBOutlet weak var finalMaxTextField: UITextField!
    @IBOutlet weak var finalPercentageTextField: UITextField!
    
    @IBOutlet weak var creditsTextField: UITextField!
    
    @IBOutlet weak var firstCourseLabel: UILabel!
    @IBOutlet weak var secondCourseLabel: UILabel!
    @IBOutlet weak var thirdCourseLabel: UILabel!
    @IBOutlet weak var fourthCourseLabel: UILabel!
    
    @IBOutlet weak var firstCourseGrade: UIImageView!
    @IBOutlet weak var secondCourseGrade: UIImageView!
    @IBOutlet weak var thirdCourseGrade: UIImageView!
    @IBOutlet weak var fourthCourseGrade: UIImageView!
    
    @IBOutlet weak var gpaLabel: UILabel!
    
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var courseIdToDeleteTextField: UITextField!
    
    // MARK:- Properties
    private var courses: [Course] = []
    
    // MARK:- LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    // MARK:- Actions
    @IBAction func addCourseTapped(_ sender: Any) {
        view.endEditing(true)
        if isValidData() {
            startCalculations()
        }
    }
    
    @IBAction func deleteCourseTapped(_ sender: Any) {
        view.endEditing(true)
        if let courseIdToDelete = getCourseIdToDelete() {
            removeCourse(id: courseIdToDelete)
        }
    }
    
    
}

// MARK:- Private Methods
extension ViewController {
    private func isValidData() -> Bool {
        guard courses.count < 4 else {
            showAlert(message: "Max course allowed is 4")
            return false
        }
        guard let courseTitle = courseTitleTextField.text?.trimmingCharacters(in: .whitespaces), !courseTitle.isEmpty else {
            showAlert(message: "Please enter valid course title")
            return false
        }
        for course in courses {
            if course.title == courseTitle {
                showAlert(message: "This course title is already entered before")
                return false
            }
        }
        if !isValidAssignmentsData() || !isValidMidtermData() || !isValidFinalData() {
            return false
        }
        if !isValidTotalWeight() {
            return false
        }
        guard let creditHours = creditsTextField.text?.trimmingCharacters(in: .whitespaces), !creditHours.isEmpty, let creditInt = Int(creditHours), creditInt > 0, creditInt <= 4 else {
            showAlert(message: "Credit hours should be more than 0 and less than or equal 4")
            return false
        }
        return true
    }
    
    private func isValidAssignmentsData() -> Bool {
        guard let assignmentPoint = assignmentsPointTextField.text?.trimmingCharacters(in: .whitespaces), !assignmentPoint.isEmpty, let takenPointInt = Int(assignmentPoint) else {
            showAlert(message: "Please enter valid assignments taken point")
            return false
        }
        guard let assignmentMaxPoint = assignmentsMaxTextField.text?.trimmingCharacters(in: .whitespaces), !assignmentMaxPoint.isEmpty, let maxPointInt = Int(assignmentMaxPoint) else {
            showAlert(message: "Please enter valid assignments max point")
            return false
        }
        guard takenPointInt >= 0, takenPointInt <= maxPointInt else {
            showAlert(message: "Assignments taken point should be 0 or more and less than or equal assignments max point")
            return false
        }
        guard let assignmentWeight = assignmentsPercentageTextField.text?.trimmingCharacters(in: .whitespaces), !assignmentWeight.isEmpty, let _ = Double(assignmentWeight) else {
            showAlert(message: "Please enter valid assignments weight")
            return false
        }
        return true
    }
    
    private func isValidMidtermData() -> Bool {
        guard let midtermPoint = midtermPointTextField.text?.trimmingCharacters(in: .whitespaces), !midtermPoint.isEmpty, let takenPointInt = Int(midtermPoint) else {
            showAlert(message: "Please enter valid midterm taken point")
            return false
        }
        guard let midtermMaxPoint = midtermMaxTextField.text?.trimmingCharacters(in: .whitespaces), !midtermMaxPoint.isEmpty, let maxPointInt = Int(midtermMaxPoint) else {
            showAlert(message: "Please enter valid midterm max point")
            return false
        }
        guard takenPointInt >= 0, takenPointInt <= maxPointInt else {
            showAlert(message: "Midterm taken point should be 0 or more and less than or equal midterm max point")
            return false
        }
        guard let midtermWeight = midtermPercentageTextField.text?.trimmingCharacters(in: .whitespaces), !midtermWeight.isEmpty, let _ = Double(midtermWeight) else {
            showAlert(message: "Please enter valid midterm weight")
            return false
        }
        return true
    }
    
    private func isValidFinalData() -> Bool {
        guard let finalPoint = finalPointTextField.text?.trimmingCharacters(in: .whitespaces), !finalPoint.isEmpty, let takenPointInt = Int(finalPoint) else {
            showAlert(message: "Please enter valid final taken point")
            return false
        }
        guard let finalMaxPoint = finalMaxTextField.text?.trimmingCharacters(in: .whitespaces), !finalMaxPoint.isEmpty, let maxPointInt = Int(finalMaxPoint) else {
            showAlert(message: "Please enter valid final max point")
            return false
        }
        guard takenPointInt >= 0, takenPointInt <= maxPointInt else {
            showAlert(message: "Final taken point should be 0 or more and less than or equal final max point")
            return false
        }
        guard let finalWeight = finalPercentageTextField.text?.trimmingCharacters(in: .whitespaces), !finalWeight.isEmpty, let _ = Double(finalWeight) else {
            showAlert(message: "Please enter valid final weight")
            return false
        }
        return true
    }
    
    private func isValidTotalWeight() -> Bool {
        let assignmentsWeight = Double(assignmentsPercentageTextField.text!.trimmingCharacters(in: .whitespaces))
        let midtermWeight = Double(midtermPercentageTextField.text!.trimmingCharacters(in: .whitespaces))
        let finalWeight = Double(finalPercentageTextField.text!.trimmingCharacters(in: .whitespaces))
        if assignmentsWeight! + midtermWeight! + finalWeight! != 100 {
            showAlert(message: "Total weight should be 100")
            return false
        }
        return true
    }
    
    private func getCourseIdToDelete() -> Int? {
        guard let courseId = courseIdToDeleteTextField.text?.trimmingCharacters(in: .whitespaces), !courseId.isEmpty, let idInt = Int(courseId), idInt > 0, idInt <= 4, idInt <= courses.count else {
            showAlert(message: "Please enter valid course id to delete")
            return nil
        }
        return idInt
    }
    
    private func removeCourse(id: Int) {
        for (index, course) in courses.enumerated() {
            if course.id == id {
                courses.remove(at: index)
                resetIds()
                break
            }
        }
    }
    
    private func resetIds() {
        for (index, _) in courses.enumerated() {
            courses[index].id = index + 1
        }
        arrangeCourses()
    }
    
    private func arrangeCourses() {
        let labels = [firstCourseLabel, secondCourseLabel, thirdCourseLabel, fourthCourseLabel]
        let grades = [firstCourseGrade, secondCourseGrade, thirdCourseGrade, fourthCourseGrade]
        var firstIndexToHide = 0
        for (index, course) in courses.enumerated() {
            labels[index]?.text = "\(index + 1)) \(course.title!) | \(course.credit!)"
            grades[index]?.image = UIImage(named: course.grade!)
            firstIndexToHide = index + 1
            animateView(labels[index]!)
            animateView(grades[index]!)
        }
        if courses.count > 0 {
            deleteButton.isEnabled = true
            calculateGPA()
        } else {
            deleteButton.isEnabled = false
            gpaLabel.text = "GPA :"
            gpaLabel.textColor = .white
        }
        guard firstIndexToHide <= labels.count - 1 else { return }
        for i in firstIndexToHide...labels.count - 1 {
            labels[i]?.alpha = 0
            grades[i]?.alpha = 0
        }
    }
    
    private func startCalculations() {
        let assignments = Assessment(pointsTaken: Int(assignmentsPointTextField.text!.trimmingCharacters(in: .whitespaces))!, maxPoints: Int(assignmentsMaxTextField.text!.trimmingCharacters(in: .whitespaces))!, weight: Double(assignmentsPercentageTextField.text!.trimmingCharacters(in: .whitespaces))!)
        let midterm = Assessment(pointsTaken: Int(midtermPointTextField.text!.trimmingCharacters(in: .whitespaces))!, maxPoints: Int(midtermMaxTextField.text!.trimmingCharacters(in: .whitespaces))!, weight: Double(midtermPercentageTextField.text!.trimmingCharacters(in: .whitespaces))!)
        let final = Assessment(pointsTaken: Int(finalPointTextField.text!.trimmingCharacters(in: .whitespaces))!, maxPoints: Int(finalMaxTextField.text!.trimmingCharacters(in: .whitespaces))!, weight: Double(finalPercentageTextField.text!.trimmingCharacters(in: .whitespaces))!)
        let course = Course(id: courses.count + 1, title: courseTitleTextField.text!.trimmingCharacters(in: .whitespaces), assessments: [assignments, midterm, final], credit: Int(creditsTextField.text!.trimmingCharacters(in: .whitespaces))!)
        courses.append(course)
        arrangeCourses()
    }
    
    private func calculateGPA() {
        var totalGradeNumbers: Double = 0
        var totalCredit = 0
        for course in courses {
            totalGradeNumbers += course.getGradeInNumbers()
            totalCredit += course.credit
        }
        let gpa = totalGradeNumbers / Double(totalCredit)
        print(gpa)
        let roundedGPA = Double(round(100 * gpa) / 100)
        gpaLabel.text = "GPA : \(roundedGPA)"
        handleGPAColor(gpa: roundedGPA)
    }
    
    private func handleGPAColor(gpa: Double) {
        if gpa >= 3, gpa <= 4 {
            gpaLabel.textColor = .green
        } else if gpa >= 2, gpa < 3 {
            gpaLabel.textColor = .orange
        } else if gpa < 2 {
            gpaLabel.textColor = .red
        }
    }
    
    private func animateView(_ view: UIView) {
        UIView.animate(withDuration: 1) {
            view.alpha = 1
        }
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Sorry", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
