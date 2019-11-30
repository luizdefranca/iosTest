import FluentSQLite
import Vapor
import Foundation

final class Employee: SQLiteModel, Codable {
  
  var id: Int?
  var firstName: String
  var lastName: String
  var managerID: Manager.ID
  
  init(firstName: String,
       lastName: String,
       managerID: Manager.ID) {
    self.firstName = firstName
    self.lastName = lastName
    self.managerID = managerID
  }
  
  final class WithTraining: Codable {
    var employee: Employee
    var trainings: [Training]
    
    init(employee: Employee, trainings: [Training]) {
      self.employee = employee
      self.trainings = trainings
    }
  }
  
}

extension Employee: Migration {}

extension Employee: Content {}

extension Employee: Parameter {}

extension Employee {
  var trainings: Siblings<Employee, Training, TrainingEmployeePivot> {
    return siblings()
  }
}

extension Employee {
  var manager: Parent<Employee, Manager> {
    return parent(\.managerID)
  }
}

extension Employee.WithTraining: Content {}


struct ExtendedEmployee: Content {
  let employee: Employee
  let trainings: [Training]
  
  init(employee: Employee, trainings: [Training]) {
    self.employee = employee
    self.trainings = trainings
  }
}
