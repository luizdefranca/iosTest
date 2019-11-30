import FluentSQLite
import Vapor
import Authentication

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
  // Register providers first
  try services.register(FluentSQLiteProvider())
  
  // Register routes to the router
  let router = EngineRouter.default()
  try routes(router)
  services.register(router, as: Router.self)
  
  // Register middleware
  var middlewares = MiddlewareConfig() // Create _empty_ middleware config
  // middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
  middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
  services.register(middlewares)
  
  // Configure a SQLite database
  let sqlite = try SQLiteDatabase(storage: .memory)
//  let sqlite = try SQLiteDatabase(storage: .file(path: "budget.sqlite"))
  
  // Register the configured SQLite database to the database config.
  var databases = DatabasesConfig()
  databases.add(database: sqlite, as: .sqlite)
  services.register(databases)
  
  // Configure migrations
  var migrations = MigrationConfig()
  migrations.add(model: Manager.self, database: .sqlite)
  migrations.add(model: Training.self, database: .sqlite)
  migrations.add(model: Employee.self, database: .sqlite)
  migrations.add(model: TrainingEmployeePivot.self, database: .sqlite)
  migrations.add(migration: AddManagers.self, database: .sqlite)
  migrations.add(migration: AddTrainings.self, database: .sqlite)
  
  services.register(migrations)
  
  try services.register(AuthenticationProvider())
}
