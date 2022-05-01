//
//  ContentView.swift
//  tirocinio
//
//  Created by Grazia Ferrara on 24/04/22.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        Text("Hello, Grazia!")
        Button(action: {
            PersistenceManager.shared.addValigia(categoria: "bagaglio a mano", lunghezza: 50, larghezza: 23, profondita: 15, nome: "myValigia", tara: 3, utilizzato: false)
        }, label: {
            Text("Add")
        })
//        NavigationView{
//            GeometryReader { geo in
//                let screenHeight = geo.frame(in: .global).height
//                let screenWidth = geo.frame(in: .global).width
//                if screenHeight < screenWidth { //layout orizzontale
//
//                } else { //layout verticale
//
//                }
//            }
//            .navigationTitle("")
//            .navigationBarHidden(true)
//        }
//        .navigationViewStyle(.stack)
        
//        TabView {
//            ObjectView()
//                .tabItem{
//                    Label("Oggetti", systemImage: "archivebox.fill")
//                    Text("Oggetti")
//                }
//            BagView()
//                .tabItem{
//                    Label("Valigie", systemImage: "suitcase.fill")
//                    Text("Valigie")
//                }
//            TripView()
//                .tabItem{
//                    Label("Viaggi", systemImage: "globe.europe.africa.fill")
//                    Text("Viaggi")
//                }
//        }
    }
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

