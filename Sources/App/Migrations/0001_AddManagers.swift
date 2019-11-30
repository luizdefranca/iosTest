import FluentSQLite
import Crypto

struct AddManagers: Migration {
  typealias Database = SQLiteDatabase
  
  static func prepare(on connection: SQLiteConnection) -> Future<Void> {
    _ = Manager(firstName: "Jonathan",
                lastName: "Wong",
                budget: 4000)
      .save(on: connection).map { manager in
      _ = Employee(firstName: "John", lastName: "Appleseed", managerID: manager.id!)
        .save(on: connection).transform(to: ())
      _ = Employee(firstName: "Owen", lastName: "Fisher", managerID: manager.id!)
        .save(on: connection).transform(to: ())
      _ = Employee(firstName: "Jane", lastName: "Smith", managerID: manager.id!)
        .save(on: connection).transform(to: ())
      _ = Employee(firstName: "Zach", lastName: "Powell", managerID: manager.id!)
        .save(on: connection).transform(to: ())
    }
    
    _ = Manager(firstName: "William",
                lastName: "Ying",
                budget: 8000)
      .save(on: connection).map { manager in
      _ = Employee(firstName: "Samantha", lastName: "James", managerID: manager.id!)
        .save(on: connection).transform(to: ())
      _ = Employee(firstName: "Chris", lastName: "Wu", managerID: manager.id!)
        .save(on: connection).transform(to: ())
      _ = Employee(firstName: "Jessica", lastName: "Smith", managerID: manager.id!)
        .save(on: connection).transform(to: ())
    }

    _ = Manager(firstName: "Phoebe",
                lastName: "Katz",
                budget: 6000)
      .save(on: connection).map { manager in
      _ = Employee(firstName: "Bradley", lastName: "Nerm", managerID: manager.id!)
        .save(on: connection).transform(to: ())
      _ = Employee(firstName: "Katie", lastName: "Beck", managerID: manager.id!)
        .save(on: connection).transform(to: ())
      _ = Employee(firstName: "Karen", lastName: "Sowen", managerID: manager.id!)
        .save(on: connection).transform(to: ())
      _ = Employee(firstName: "Kevin", lastName: "Sun", managerID: manager.id!)
        .save(on: connection).transform(to: ())
      _ = Employee(firstName: "Alice", lastName: "Cleary", managerID: manager.id!)
        .save(on: connection).transform(to: ())
    }

    return Manager(firstName: "Karen",
                   lastName: "Thompson",
                   budget: 10000)
      .save(on: connection).map { manager in
      _ = Employee(firstName: "Ned", lastName: "Martin", managerID: manager.id!)
        .save(on: connection).transform(to: ())
      _ = Employee(firstName: "Liz", lastName: "Ivy", managerID: manager.id!)
        .save(on: connection).transform(to: ())
    }
  }
  
  static func revert(on conn: SQLiteConnection) -> EventLoopFuture<Void> {
    return .done(on: conn)
  }
}
