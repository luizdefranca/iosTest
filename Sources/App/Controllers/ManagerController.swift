import Vapor
import Crypto

struct ManagerController: RouteCollection {
  
  func boot(router: Router) throws {
    let managerRouter = router.grouped("v1", "managers")
    
    managerRouter.get(use: managers)
    managerRouter.post(use: createManager)
    managerRouter.get(Manager.parameter, "employees", use: employees)
  }
  
  func managers(_ req: Request) throws -> Future<[Manager]> {
    return Manager.query(on: req).all()
  }
  
  func createManager(_ req: Request) throws -> Future<Manager> {
    return try req.content.decode(Manager.self)
      .flatMap(to: Manager.self) { manager in
        return manager.save(on: req)
    }
  }
  
  func employees(_ req: Request) throws -> Future<[Employee]> {
    return try req.parameters.next(Manager.self)
      .flatMap(to: [Employee].self) { manager in
        return try manager.employees.query(on: req).all()
    }
  }
}
