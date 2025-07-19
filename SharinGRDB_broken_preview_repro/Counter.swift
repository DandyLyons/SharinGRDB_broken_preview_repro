//
//  Counter.swift
//  SharinGRDB_broken_preview_repro
//
//  Created by Daniel Lyons on 7/19/25.
//

import Foundation
import SharingGRDB

@Table
struct Counter: Identifiable {
  let id: Int
  var count: Int = 0
}
