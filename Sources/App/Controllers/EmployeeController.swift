import Vapor
import Crypto

struct EmployeeController: RouteCollection {
  
  func boot(router: Router) throws {
    let employeeRouter = router.grouped("v1", "employees")
    
    employeeRouter.get(use: employees)
    employeeRouter.post(use: createEmployee)
    employeeRouter.put(Employee.parameter, use: updateEmployee)
    employeeRouter.delete(Employee.parameter, use: deleteEmployee)
    employeeRouter.get(Employee.parameter, "trainings", use: employeesAndTrainings)
//    employeeRouter.get(Employee.parameter, "trainings", use: trainingsFromEmployee)

  }
  
  /// POST v1/employees
  func createEmployee(_ req: Request) throws -> Future<Employee> {
    return try req.content.decode(Employee.self)
      .flatMap(to: Employee.self) { employee in
        return employee.save(on: req)
    }
  }
  
  /// PUT v1/employees/:employeeID
  func updateEmployee(_ req: Request) throws -> Future<Employee> {
    return try flatMap(to: Employee.self,
                       req.parameters.next(Employee.self),
                       req.content.decode(Employee.self)) { employee, updatedEmployee in
                        employee.firstName = updatedEmployee.firstName
                        employee.lastName = updatedEmployee.lastName
                        
                        return employee.save(on: req)
    }
  }
  
  /// DELETE v1/employees/:employeeID
  func deleteEmployee(_ req: Request) throws -> Future<HTTPStatus> {
    return try req.parameters.next(Employee.self)
      .delete(on: req)
      .transform(to: HTTPStatus.noContent)
  }
  
  /// GET v1/employees
  func employees(_ req: Request) throws -> Future<[Employee]> {
    return Employee.query(on: req).all()
  }
  
  /// GET v1/employees/:employeeID/trainings
  func trainingsFromEmployee(_ req: Request) throws -> Future<[Training]> {
    return try req.parameters.next(Employee.self)
      .flatMap(to: [Training].self) { employee in
        try employee.trainings.query(on: req).all()
    }
  }
  
  /// GET v1/employees/:employeeID/trainings
  func employeesAndTrainings(_ req: Request) throws -> Future<Employee.WithTraining> {
    Employee.query(on: req).all()
    return try req.parameters.next(Employee.self)
      .flatMap(to: Employee.WithTraining.self) { employee in
        try employee.trainings.query(on: req).all().map { trainings in
          return Employee.WithTraining(employee: employee, trainings: trainings)
        }
    }
  }
}
