import FluentSQLite

final class TrainingEmployeePivot: SQLitePivot {
  
  var id: Int?
  
  var trainingID: Training.ID
  var employeeID: Employee.ID
  
  typealias Left = Training
  typealias Right = Employee
  
  static let leftIDKey: LeftIDKey = \.trainingID
  static let rightIDKey: RightIDKey = \.employeeID
  
  init(_ training: Training, _ employee: Employee) throws {
    self.trainingID = try training.requireID()
    self.employeeID = try employee.requireID()
  }
}

extension TrainingEmployeePivot: Migration {
  
  static func prepare(on connection: SQLiteConnection) -> Future<Void> {
    return Database.create(self, on: connection) { builder in
      try addProperties(to: builder)
      builder.reference(from: \.trainingID, to: \Training.id, onDelete: .cascade)
      builder.reference(from: \.employeeID, to: \Employee.id, onDelete: .cascade)
    }
  }
}
extension TrainingEmployeePivot: ModifiablePivot {}

