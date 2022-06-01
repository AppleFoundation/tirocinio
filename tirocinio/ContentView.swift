//
//  ContentView.swift
//  tirocinio
//
//  Created by Grazia Ferrara on 24/04/22.
//

import SwiftUI

struct ContentView: View {
    
    //    @State var allViaggi: [Viaggio] = PersistenceManager.shared.loadAllViaggi()
    @FetchRequest<Viaggio>(entity: Viaggio.entity(), sortDescriptors: []) var allViaggi: FetchedResults<Viaggio>
    let columns = [GridItem(.fixed(170),spacing: 10),
                   GridItem(.fixed(170),spacing: 10)]
    
    @State var showAddViaggioView: Bool = false
    @State var showEditViaggioView: Bool = false
    @State private var showEditView = false
    // @State var viaggioScelto: Viaggio = PersistenceManager.shared.loadAllViaggi()[0]
    
    var body: some View{
        NavigationView{
            
            //###INIZIO - SEZIONE DI TEST COSE
            
            
            //###FINE - SEZIONE DI TEST COSE
            
            ScrollView{
                
                Button(action: {
                    PersistenceManager.shared.addOggetto(categoria: "Maglie", larghezza: 10, lunghezza: 20, profondita: 5, peso: 500, nome: "Cane")
                    PersistenceManager.shared.addOggetto(categoria: "Maglie", larghezza: 10, lunghezza: 25, profondita: 1, peso: 400, nome: "Gatto")
                    PersistenceManager.shared.addOggetto(categoria: "Maglie", larghezza: 10, lunghezza: 10, profondita: 3, peso: 120, nome: "Stella")
                    PersistenceManager.shared.addOggetto(categoria: "Maglie", larghezza: 10, lunghezza: 15, profondita: 3, peso: 100, nome: "Albero")
                    PersistenceManager.shared.addOggetto(categoria: "Maglie", larghezza: 10, lunghezza: 12, profondita: 4, peso: 80, nome: "Pianta")
                    PersistenceManager.shared.addOggetto(categoria: "Maglie", larghezza: 10, lunghezza: 19, profondita: 3, peso: 300, nome: "Matita")
                    PersistenceManager.shared.addOggetto(categoria: "Maglie", larghezza: 10, lunghezza: 26, profondita: 6, peso: 300, nome: "Topolino")
                    PersistenceManager.shared.addOggetto(categoria: "Felpe", larghezza: 10, lunghezza: 4, profondita: 3, peso: 200, nome: "Matita")
                    
                    
                    PersistenceManager.shared.addValigia(categoria: "Trolley", lunghezza: 35, larghezza: 40, profondita: 20, nome: "Blu", tara: 1000, utilizzato: true)
                    PersistenceManager.shared.addValigia(categoria: "Trolley", lunghezza: 20, larghezza: 30, profondita: 20, nome: "Rossa", tara: 1000, utilizzato: true)
                    PersistenceManager.shared.addValigia(categoria: "Trolley", lunghezza: 20, larghezza: 30, profondita: 20, nome: "Verde", tara: 1000, utilizzato: true)
                    PersistenceManager.shared.addValigia(categoria: "Trolley", lunghezza: 20, larghezza: 30, profondita: 20, nome: "Viola", tara: 1000, utilizzato: true)
                    
                    
//                    PersistenceManager.shared.addValigiaViaggiante(oggettiInViaggio: PersistenceManager.shared.loadAllOggetti(), valigia: PersistenceManager.shared.loadAllValigie()[0], viaggio: PersistenceManager.shared.loadAllViaggi()[0])
//
                    
                    
                }, label: {Text("Inizializza")})
                
                NavigationLink(destination: AddNuovoOggetto(), label: {
                    Text("Aggiungi nuovo oggetto")
                })
                
                NavigationLink(destination: AddNuovaValigia(), label: {
                    Text("Aggiungi nuova valigia")
                })
                
                
                LazyVGrid(columns: columns) {
                    
                    ForEach(allViaggi){
                        viaggio in
                        NavigationLink(destination: DetailTripView(viaggio: viaggio)){
                            ActionButtonView(systemImage: "airplane", nameButton: viaggio.nome ?? "NoWhere", colorImage: .blue, dataViaggio: viaggio.data ?? Date()).padding(.bottom, 20).padding(.top, 10)
                        }
                        
                        
                        .contextMenu
                        {
                            Button(action: { PersistenceManager.shared.deleteViaggio(nome: viaggio.nome ?? "NoWhere")}, label:
                                    {
                                HStack{
                                    Text("Elimina")
                                    Image(systemName: "trash.fill")
                                    
                                }
                                
                            })
                            
                            Button(action: {
                                self.showEditView = true
                                //viaggioScelto = viaggio
                            }, label: {
                                HStack {
                                    Text("Edit")
                                    Image(systemName: "pencil")
                                }
                            })
                            
                        }
                        
                        
                    }
                    
                    //                    NavigationLink(destination: EditViaggioView(viaggio: viaggioScelto), isActive: $showEditView) {
                    //                        EmptyView()
                    //                    }
                    
                }
            }
            
            .navigationTitle("SmartSuitCase").multilineTextAlignment(.center)
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing){
                    NavigationLink(destination: AddViaggioView()){
                        Image(systemName: "plus")
                    }
                    
                }
            }
        }.sheet(isPresented: $showEditViaggioView, onDismiss:{
            showAddViaggioView = false
        }){
            //EditViaggioView( viaggio: PersistenceManager.shared.loadAllViaggi()[0])
        }
    }
    
}


struct ActionButtonView: View{
    
    @Environment(\.colorScheme) var colorScheme
    
    var systemImage: String
    var nameButton: String
    var colorImage: Color
    var dataViaggio: Date
    
    var body: some View{
        GeometryReader { reader in
            
            let fontSize = min(reader.size.width * 0.2, 28)
            let imageWidth: CGFloat = min(50, reader.size.width * 0.6)
            
            VStack(spacing: 5) {
                Image(systemName: systemImage)
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(colorImage)
                    .frame(width: imageWidth)
                    .padding(.top, -15)
                Text(nameButton)
                    .font(.system(size: fontSize, weight: .semibold, design: .rounded))
                    .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                Text(dataViaggio, style: .date)
                    .font(.title3)
                    .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                
            }
            .frame(width: reader.size.width, height: reader.size.height)
            .background(colorScheme == .dark ? Color.init(white: 0.2) : Color.white)
            
            
            
        }
        .frame(height: 150)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: Color.black.opacity(0.2), radius: 10, y: 5)
    }
}


//struct testCoreData: View{
//    @Environment(\.managedObjectContext) private var viewContext
//    var body: some View{
//        VStack{
//            Text("Hello, Grazia!")
//            HStack{
//                Button(action: {
//                    PersistenceManager.shared.addValigia(categoria: "bagaglio a mano", lunghezza: 50, larghezza: 23, profondita: 15, nome: "myValigia", tara: 3, utilizzato: false)
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
//                    for i in valigie{
//                        print("Nome valigia: \(i.nome)")
//                        print("Categoria valigia: \(i.categoria)")
//                        print("Volume valigia: \(i.volume)")
//                        print("\n\n")
//                    }
//                }, label: {
//                    Text("Print Valigie")
//                })
//                Button(action: {
//                    let viaggi = PersistenceManager.shared.loadAllViaggi()
//                    for i in viaggi{
//                        print("Nome Viaggio: \(i.nome)")
//                        print("Data Viaggio: \(i.data)")
//                        print("\n\n")
//                    }
//                }, label: {
//                    Text("Print Viaggi")
//                })
//                Button(action: {
//                    let oggetto = PersistenceManager.shared.loadAllOggetti()
//                    for i in oggetto{
//                        print("Nome oggetto: \(i.nome)")
//                        print("Categoria oggetto: \(i.categoria)")
//                        print("Volume oggetto: \(i.volume)")
//                        print("\n\n")
//                    }
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
//            
//        }
//    }
//}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPhone 11")
    }
}

