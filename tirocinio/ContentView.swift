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
        VStack{
            Text("Hello, Grazia!")
            HStack{
                Button(action: {
                    PersistenceManager.shared.addValigia(categoria: "bagaglio a mano", lunghezza: 50, larghezza: 23, profondita: 15, nome: "myValigia", tara: 3, utilizzato: false)
                }, label: {
                    Text("Add Valigia")
                })
                Button(action: {
                    PersistenceManager.shared.addViaggio(data: Date(), nome: "Fisciano")
                }, label: {
                    Text("Add Viaggio")
                })
                Button(action: {
                    PersistenceManager.shared.addOggetto(categoria: "Maglia", larghezza: 30, lunghezza: 30, profondita: 30, peso: 200, nome: "Maglia con cagnolino")
                }, label: {
                    Text("Add Oggetto")
                })
            }
            HStack{
                Button(action: {
                    let valigie = PersistenceManager.shared.loadAllValigie()
                    for i in valigie{
                        print("Nome valigia: \(i.nome)")
                        print("Categoria valigia: \(i.categoria)")
                        print("Volume valigia: \(i.volume)")
                        print("\n\n")
                    }
                }, label: {
                    Text("Print Valigie")
                })
                Button(action: {
                    let viaggi = PersistenceManager.shared.loadAllViaggi()
                    for i in viaggi{
                        print("Nome Viaggio: \(i.nome)")
                        print("Data Viaggio: \(i.data)")
                        print("\n\n")
                    }
                }, label: {
                    Text("Print Viaggi")
                })
                Button(action: {
                    let oggetto = PersistenceManager.shared.loadAllOggetti()
                    for i in oggetto{
                        print("Nome oggetto: \(i.nome)")
                        print("Categoria oggetto: \(i.categoria)")
                        print("Volume oggetto: \(i.volume)")
                        print("\n\n")
                    }
                }, label: {
                    Text("Print Oggetti")
                })
            }
            HStack{
                Button(action: {
                    PersistenceManager.shared.deleteValigia(nome: "myValigia", categoria: "bagaglio a mano")
                }, label: {
                    Text("Delete Valigie")
                })
                Button(action: {
                    PersistenceManager.shared.deleteViaggio(nome: "Fisciano")
                }, label: {
                    Text("Delete Viaggio")
                })
                Button(action: {
                    PersistenceManager.shared.deleteOggetto(nome: "Maglia con cagnolino", categoria: "Maglia")
                }, label: {
                    Text("Delete Oggetto")
                })
            }
            
        }

    }
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

