# Broken SharingGRDB Previews

This repo demonstrates SwiftUI previews breaking inside of Xcode when using SharingGRDB. 

OS used: macOS 26 (beta 2 and 3)
Xcode 16.4

## Steps to Reproduce
### `#Preview`
Uncomment the `#Preview` in `ContentView.swift`. The database will fail to read and write. 

You should see an error like this in the console: 
```
🟣 Dependencies/DependencyValues.swift:286: Ignoring dependencies prepared in preview app entry point
🟣 StructuredQueriesGRDBCore/DefaultDatabase.swift:42: A blank, in-memory database is being used. To set the database that is used by 'SharingGRDB' in a preview, use a tool like 'prepareDependencies':

    #Preview {
      let _ = prepareDependencies {
        $0.defaultDatabase = try! DatabaseQueue(/* ... */)
      }
      // ...
    }
🟣 StructuredQueriesGRDBCore/DefaultDatabase.swift:43: @Dependency(\.defaultDatabase) has already been accessed or prepared.

  Key:
    DependencyValues.DefaultDatabaseKey
  Value:
    DatabaseWriter

A global dependency can only be prepared a single time and cannot be accessed beforehand. Prepare dependencies as early as possible in the lifecycle of your application.
```

### `PreviewProvider`
Uncomment the `PreviewProvider` in `ContentView.swift`. Now the database should be able to read and write but the prior error still appears in the console. (Also, in my larger project, db data from `db.seed` at times fails to load. This happens non-deterministically. In practice, if it does happen, the seeded data tends to load when I reload the preview a second time.)
