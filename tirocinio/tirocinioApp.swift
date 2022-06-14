//
//  tirocinioApp.swift
//  tirocinio
//
//  Created by Grazia Ferrara on 24/04/22.
//

import SwiftUI
import CoreData

@main
struct tirocinioApp: App {
    let persistence = PersistenceManager.shared
    var speech = SpeechToText()
    
    var body: some Scene {
        WindowGroup {
            //Iniettiamo la variabile d'ambiente rappresentante il contesto all'interno dell'applicazione
            ContentView().environment(\.managedObjectContext, persistence.persistentContainer.viewContext)
                         .environmentObject(speech)
//            ContentView().environmentObject(persistence)
        }
    }
}
