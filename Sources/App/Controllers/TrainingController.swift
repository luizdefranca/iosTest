import Vapor

struct TrainingController: RouteCollection {

  func boot(router: Router) throws {
    let trainingRouter = router.grouped("v1", "trainings")

    trainingRouter.get(use: trainings)
    trainingRouter.post(use: createTraining)
    trainingRouter.put(Training.parameter, use: updateTraining)
    trainingRouter.delete(Training.parameter, use: deleteTraining)
    trainingRouter.post(Training.parameter, "employees", Employee.parameter, use: trainingToEmployee)
//    trainingRouter.get(Training.parameter, "employees", use: employeesFromTraining)
    trainingRouter.get(Employee.parameter, "employees", use: trainingsForEmployee)
    trainingRouter.put(Employee.parameter, "employees", use: updateTrainingToEmployee)
    trainingRouter.delete(Training.parameter, "employees", Employee.parameter, use: removeTrainingForEmployee)
  }

  /// POST v1/trainings
  func createTraining(_ req: Request) throws -> Future<Training> {
    return try req.content.decode(Training.self)
      .flatMap(to: Training.self) { training in
        return training.save(on: req)
    }
  }

  /// PUT v1/trainings/:trainingID
  func updateTraining(_ req: Request) throws -> Future<Training> {
    return try flatMap(to: Training.self,
      req.parameters.next(Training.self),
      req.content.decode(Training.self)) { training, updatedTraining in
      training.name = updatedTraining.name
      training.price = updatedTraining.price

      return training.save(on: req)
    }
  }

  /// DELETE v1/trainings
  func deleteTraining(_ req: Request) throws -> Future<HTTPStatus> {
    return try req.parameters.next(Training.self)
      .delete(on: req)
      .transform(to: HTTPStatus.noContent)
  }

  /// GET v1/trainings
  func trainings(_ req: Request) throws -> Future<[Training]> {
    return Training.query(on: req).all()
  }

  /// POST v1/trainings/:trainingID/employees/:employeeID
  func trainingToEmployee(_ req: Request) throws -> Future<HTTPStatus> {
    return try flatMap(to: HTTPStatus.self,
      req.parameters.next(Training.self),
      req.parameters.next(Employee.self)) { training, employee in
        return employee.trainings.isAttached(training, on: req).flatMap { (isAttached: Bool) in
          if isAttached {
            throw Abort(.conflict, reason: "Already attached")
          }
          return training.employees.attach(employee, on: req).transform(to: .created)
        }
    }
  }
  
  /// PUT v1/trainings/:employeeID/employees
  func updateTrainingToEmployee(_ req: Request) throws -> Future<HTTPStatus> {
    return try flatMap(to: HTTPStatus.self,
                       req.parameters.next(Employee.self),
                       req.content.decode(Training.self)) { employee, training in
                        return employee.trainings.attach(training, on: req).transform(to: .created)
//                        return training.employees.attach(employee, on: req).transform(to: .created)
    }
  }
  
  /// GET v1/trainings/:employeeID/employees
  func trainingsForEmployee(_ req: Request) throws -> Future<[Training]> {
    return try req.parameters.next(Employee.self).flatMap(to: [Training].self) { employee in
      try employee.trainings.query(on: req).all()
    }
  }

  /// GET v1/trainings/:trainingID/employees
//  func employeesFromTraining(_ req: Request) throws -> Future<[Employee]> {
//    return try req.parameters.next(Training.self)
//      .flatMap(to: [Employee].self) { training in
//        try training.employees.query(on: req).all()
//    }
//  }

  /// DELETE v1/trainings/:trainingID/employees/:employeeID
  func removeTrainingForEmployee(_ req: Request) throws -> Future<HTTPStatus> {
    return try flatMap(to: HTTPStatus.self,
      req.parameters.next(Training.self),
      req.parameters.next(Employee.self)) { training, employee in
      return training.employees
        .detach(employee, on: req)
        .transform(to: .noContent)
    }
  }

}

