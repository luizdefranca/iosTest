import FluentSQLite
import Vapor
import Foundation
import Authentication

final class Manager: SQLiteModel {
  
  var id: Int?
  var firstName: String
  var lastName: String
  var budget: Int
  
  init(firstName: String,
       lastName: String,
       budget: Int) {
    self.firstName = firstName
    self.lastName = lastName
    self.budget = budget
  }
}

extension Manager: Migration {}

extension Manager: Content {}

extension Manager: Codable {}

extension Manager: Parameter {}

extension Manager {
  var employees: Children<Manager, Employee> {
    return children(\.managerID)
  }
}
