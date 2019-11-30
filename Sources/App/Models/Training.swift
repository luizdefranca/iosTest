import FluentSQLite
import Vapor

final class Training: SQLiteModel {
  
  var id: Int?
  var name: String
  var price: Int
  
  init(name: String,
       price: Int) {
    self.name = name
    self.price = price
  }
}

extension Training: Migration {}

extension Training: Content {}

extension Training: Codable {}

extension Training: Parameter {}

extension Training {
  var employees: Siblings<Training, Employee, TrainingEmployeePivot> {
    return siblings()
  }
}
