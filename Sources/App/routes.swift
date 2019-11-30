import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
  // Basic "It works" example
  router.get { req in
    return "It works!"
  }
  
  // Basic "Hello, world!" example
  router.get("hello") { req in
    return "Hello, world!"
  }
  
  let trainingController = TrainingController()
  try router.register(collection: trainingController)
  
  let employeeController = EmployeeController()
  try router.register(collection: employeeController)
  
  let managerController = ManagerController()
  try router.register(collection: managerController)
}
