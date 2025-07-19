//
//  SharinGRDB_broken_preview_reproApp.swift
//  SharinGRDB_broken_preview_repro
//
//  Created by Daniel Lyons on 7/19/25.
//

import Dependencies
import SwiftUI

@main
struct SharinGRDB_broken_preview_reproApp: App {
  init() {
    prepareDependencies {
      $0.defaultDatabase = try! appDatabase()
    }
  }
  
  var body: some Scene {
    WindowGroup {
      CounterView(vm: CounterModel())
    }
  }
}
