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
//            HStack{
//                Button(action: {
//                    PersistenceManager.shared.addValigia(categoria: "bagaglio a mano", lunghezza: 50, larghezza: 23, profondita: 15, nome: "myValigia", tara: 3, utilizzato: false)
//                    PersistenceManager.shared.addValigia(categoria: "bagaglio da stiva", lunghezza: 50, larghezza: 23, profondita: 15, nome: "myValigia2", tara: 3, utilizzato: false)
//                }, label: {
//                    Text("Add Valigia")
//                })
//                Button(action: {
//                    PersistenceManager.shared.addViaggio(data: Date(), nome: "Fisciano")
//                }, label: {
//                    Text("Add Viaggio")
//                })
//                Button(action: {
//                    PersistenceManager.shared.addOggetto(categoria: "Maglia", larghezza: 30, lunghezza: 30, profondita: 30, peso: 200, nome: "Maglia con cagnolino")
//                }, label: {
//                    Text("Add Oggetto")
//                })
//            }
//            HStack{
//                Button(action: {
//                    let valigie = PersistenceManager.shared.loadAllValigie()
//                    print(valigie)
//                }, label: {
//                    Text("Print Valigie")
//                })
//                Button(action: {
//                    let viaggi = PersistenceManager.shared.loadAllViaggi()
//                    print(viaggi)
//                }, label: {
//                    Text("Print Viaggi")
//                })
//                Button(action: {
//                    let oggetto = PersistenceManager.shared.loadAllOggetti()
//                    print(oggetto)
//                }, label: {
//                    Text("Print Oggetti")
//                })
//            }
//            HStack{
//                Button(action: {
//                    PersistenceManager.shared.deleteValigia(nome: "myValigia", categoria: "bagaglio a mano")
//                }, label: {
//                    Text("Delete Valigie")
//                })
//                Button(action: {
//                    PersistenceManager.shared.deleteViaggio(nome: "Fisciano")
//                }, label: {
//                    Text("Delete Viaggio")
//                })
//                Button(action: {
//                    PersistenceManager.shared.deleteOggetto(nome: "Maglia con cagnolino", categoria: "Maglia")
//                }, label: {
//                    Text("Delete Oggetto")
//                })
//            }
            HStack{
                Button(action:{
                    PersistenceManager.shared.addValigia(categoria: "bagaglio a mano", lunghezza: 10, larghezza: 10, profondita: 10, nome: "myValigia", tara: 199, utilizzato: false)
                }, label:{
                    Text("Aggiungi valigia")
                })
                Button(action:{
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy/MM/dd"
                    let someDateTime = formatter.date(from: "2016/10/08")
                    PersistenceManager.shared.addViaggio(data: someDateTime!, nome: "Fisciano")
                }, label:{
                    Text("Aggiungi viaggio")
                })
                Button(action: {
                    let valigia = PersistenceManager.shared.loadAllValigie()[0] // prima valigia inserita
                    let viaggio = PersistenceManager.shared.loadAllViaggi()[0] // primo viaggio inserito

                    PersistenceManager.shared.addValigiaViaggiante(oggettiInViaggio: [], valigia: valigia, viaggio: viaggio)
                }, label: {
                    Text("Aggiungi Valigia Viaggiante")
                })
                Button(action: {
                    let vv = PersistenceManager.shared.loadAllValigieViaggianti()
                    print(vv)
                }, label: {
                    Text("Stampa valigie viaggianti")
                })
                Button(action: {
                    PersistenceManager.shared.deleteValigiaViaggiante(viaggio: PersistenceManager.shared.loadViaggiFromNome(nome: "Caraibi")[0], valigia: PersistenceManager.shared.loadValigieFromNomeCategoria(nome: "myValigia", categoria: "bagaglio a mano")[0])
                }, label: {
                    Text("Elimina valigie viaggianti")
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

