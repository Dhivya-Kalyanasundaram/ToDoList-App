//
//  ToDoList_AppApp.swift
//  ToDoList App
//
//  Created by Kalyanasundaram, Dhivya (Cognizant) on 06/03/25.
//

import SwiftUI

@main
struct ToDoList_AppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            TaskEditView( initialDate: Date.now)
//            ContentView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
