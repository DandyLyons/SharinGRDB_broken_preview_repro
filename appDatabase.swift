import Foundation
import OSLog
import GRDB
import SharingGRDB
import IssueReporting


func appDatabase() throws -> any DatabaseWriter {
  @Dependency(\.context) var context
  let database: any DatabaseWriter
  
  var configuration = Configuration()
  configuration.foreignKeysEnabled = true
#if DEBUG
  configuration.publicStatementArguments = true
  configuration.prepareDatabase { db in
      db.trace(options: .profile) {
        switch context {
          case .preview: logger.debug("SQL: \($0.expandedDescription)")
          case .live, .test: print("SQL: \($0.expandedDescription)")
        }
      }
  }
#endif // DEBUG
  
  switch context {
    case .live:
      let path = URL.documentsDirectory.appending(component: "db.sqlite").path()
      logger.info("open \(path)")
      database = try DatabasePool(path: path, configuration: configuration)
      
    case .preview, .test:
      database = try DatabaseQueue(configuration: configuration)
  }
  
  var migrator = DatabaseMigrator()
  migrator.registerMigration("create counter table") { db in
    try #sql(
"""
CREATE TABLE "counters" (
"id" INTEGER PRIMARY KEY AUTOINCREMENT,
"count" INTEGER NOT NULL DEFAULT 0
) STRICT;
""").execute(db)
  }
  
#if DEBUG
  migrator.eraseDatabaseOnSchemaChange = true
#endif // DEBUG
  try migrator.migrate(database)
  logger.info("Database migrated successfully.")
  
  return database
}

private let logger = Logger(subsystem: "repro", category: "Database")
