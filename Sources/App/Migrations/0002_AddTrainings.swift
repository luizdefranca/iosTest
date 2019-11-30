import FluentSQLite

struct AddTrainings: Migration {
  typealias Database = SQLiteDatabase
  
  static func prepare(on connection: SQLiteConnection) -> Future<Void> {
    let training1 = Training(name: "WWDC", price: 1699)
    let training2 = Training(name: "360 iDev", price: 1099)
    let training3 = Training(name: "Cocoaconf", price: 1299)
    let training4 = Training(name: "AWS", price: 1500)
    let training5 = Training(name: "Swift by San Diego", price: 800)
    let training6 = Training(name: "Swift Bootcamp", price: 600)
    let training7 = Training(name: "iOS for Beginners", price: 400)
    let training8 = Training(name: "Advanced Swift", price: 1499)
    let training9 = Training(name: "Raise Your Swift", price: 999)
    let training10 = Training(name: "Swifty API Design", price: 999)
    
    _ = training1.save(on: connection).transform(to: ())
    _ = training2.save(on: connection).transform(to: ())
    _ = training3.save(on: connection).transform(to: ())
    _ = training4.save(on: connection).transform(to: ())
    _ = training5.save(on: connection).transform(to: ())
    _ = training6.save(on: connection).transform(to: ())
    _ = training7.save(on: connection).transform(to: ())
    _ = training8.save(on: connection).transform(to: ())
    _ = training9.save(on: connection).transform(to: ())
    _ = training10.save(on: connection).transform(to: ())
    
    return training3.save(on: connection).transform(to: ())
  }
  
  static func revert(on conn: SQLiteConnection) -> EventLoopFuture<Void> {
    return .done(on: conn)
  }
}
