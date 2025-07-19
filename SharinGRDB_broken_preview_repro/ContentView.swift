//
//  ContentView.swift
//  SharinGRDB_broken_preview_repro
//
//  Created by Daniel Lyons on 7/19/25.
//

import Dependencies
import Observation
import SharingGRDB
import SwiftUI

struct CounterView: View {
    @Bindable var vm: CounterModel

    var body: some View {
      List {
        Button("Add Counter") {
          vm.addCounter()
        }
        ForEach(vm.counters) { counter in
          HStack {
            Text("Count: \(counter.count)")
            Spacer()
            Button("Increment") {
              vm.incrementCounter(id: counter.id)
            }
            Button("Decrement") {
              vm.decrementCounter(id: counter.id)
            }
          }
        }
      }
    }
}

@Observable
class CounterModel {
  @ObservationIgnored @FetchAll var counters: [Counter]
  
  @ObservationIgnored
  @Dependency(\.defaultDatabase) var defaultDatabase
  
  func addCounter() {
    withErrorReporting {
      try defaultDatabase.write { db in
        try Counter.insert { Counter.Draft() }
          .execute(db)
      }
    }
  }
  
  func incrementCounter(id: Int) {
    withErrorReporting {
      try defaultDatabase.write { db in
        try Counter.find(id).update { $0.count += 1 }
          .execute(db)
      }
    }
  }
  
  func decrementCounter(id: Int) {
    withErrorReporting {
      try defaultDatabase.write { db in
        try Counter.find(id).update { $0.count -= 1 }
          .execute(db)
      }
    }
  }
}

//#Preview {
//  let _ = prepareDependencies {
//    $0.defaultDatabase = try! appDatabase()
//  }
//  
//  CounterView(vm: CounterModel())
//    
//}

struct Counter_Previews: PreviewProvider {
    static var previews: some View {
      let _ = prepareDependencies {
        $0.defaultDatabase = try! appDatabase()
      }
      
      CounterView(vm: CounterModel())
    }
}
