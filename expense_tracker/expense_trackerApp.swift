//
//  expense_trackerApp.swift
//  expense_tracker
//
//  Created by Experimental Station on 2/15/23.
//

import SwiftUI

@main
struct expense_trackerApp: App {
    @StateObject var transactionListVM = TransactionListViewModel()
    // will follow the lifecycle of the app
    // swiftui will reserve memory for it in the environment
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(transactionListVM)
        }
    }
}
