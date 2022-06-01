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
                    inizializzaOggetti()
                    inizializzaValigie()
                    
                    
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
    
    func inizializzaOggetti(){
        
        //Categoria 1
        PersistenceManager.shared.addOggetto(categoria: "Articoli da bagno", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Profumo")
        PersistenceManager.shared.addOggetto(categoria: "Articoli da bagno", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Deodorante")
        PersistenceManager.shared.addOggetto(categoria: "Articoli da bagno", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Bagnoschiuma")
        PersistenceManager.shared.addOggetto(categoria: "Articoli da bagno", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Cotton fioc")
        PersistenceManager.shared.addOggetto(categoria: "Articoli da bagno", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Dentifricio")
        PersistenceManager.shared.addOggetto(categoria: "Articoli da bagno", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Gel da barba")
        PersistenceManager.shared.addOggetto(categoria: "Articoli da bagno", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Lenti a contatto")
        PersistenceManager.shared.addOggetto(categoria: "Articoli da bagno", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Pinzetta")
        PersistenceManager.shared.addOggetto(categoria: "Articoli da bagno", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Rasoio")
        PersistenceManager.shared.addOggetto(categoria: "Articoli da bagno", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Spazzolino da denti")
        PersistenceManager.shared.addOggetto(categoria: "Articoli da bagno", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Spazzola")
        PersistenceManager.shared.addOggetto(categoria: "Articoli da bagno", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Tagliaunghie")
        PersistenceManager.shared.addOggetto(categoria: "Articoli da bagno", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Trucchi")
        PersistenceManager.shared.addOggetto(categoria: "Articoli da bagno", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Gel per capelli")
        PersistenceManager.shared.addOggetto(categoria: "Articoli da bagno", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Lacca")
        PersistenceManager.shared.addOggetto(categoria: "Articoli da bagno", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Colluttorio")
        PersistenceManager.shared.addOggetto(categoria: "Articoli da bagno", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Pantofole")
        PersistenceManager.shared.addOggetto(categoria: "Articoli da bagno", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Accappatoio")
        //Categoria 2
        PersistenceManager.shared.addOggetto(categoria: "Abbigliamento", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Biancheria Intima")
        PersistenceManager.shared.addOggetto(categoria: "Abbigliamento", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Calzini")
        PersistenceManager.shared.addOggetto(categoria: "Abbigliamento", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "T-Shirt")
        PersistenceManager.shared.addOggetto(categoria: "Abbigliamento", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Maglioncino")
        PersistenceManager.shared.addOggetto(categoria: "Abbigliamento", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Maglione")
        PersistenceManager.shared.addOggetto(categoria: "Abbigliamento", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Giacca")
        PersistenceManager.shared.addOggetto(categoria: "Abbigliamento", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Cappotto")
        PersistenceManager.shared.addOggetto(categoria: "Abbigliamento", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Giubbino")
        PersistenceManager.shared.addOggetto(categoria: "Abbigliamento", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Pantaloncino")
        PersistenceManager.shared.addOggetto(categoria: "Abbigliamento", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Pantalone")
        PersistenceManager.shared.addOggetto(categoria: "Abbigliamento", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Camicia")
        PersistenceManager.shared.addOggetto(categoria: "Abbigliamento", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Pigiama")
        PersistenceManager.shared.addOggetto(categoria: "Abbigliamento", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Scarpe")
        PersistenceManager.shared.addOggetto(categoria: "Abbigliamento", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Calze")
        PersistenceManager.shared.addOggetto(categoria: "Abbigliamento", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Leggins")
        //Categoria 3
        PersistenceManager.shared.addOggetto(categoria: "Essenziali", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Farmaci")
        PersistenceManager.shared.addOggetto(categoria: "Essenziali", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Chiavi di casa")
        PersistenceManager.shared.addOggetto(categoria: "Essenziali", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Mascherine")
        PersistenceManager.shared.addOggetto(categoria: "Essenziali", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Occhiali")
        PersistenceManager.shared.addOggetto(categoria: "Essenziali", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Orologio")
        PersistenceManager.shared.addOggetto(categoria: "Essenziali", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Portafoglio")
        PersistenceManager.shared.addOggetto(categoria: "Essenziali", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Passaporto")
        PersistenceManager.shared.addOggetto(categoria: "Essenziali", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Penna")
        PersistenceManager.shared.addOggetto(categoria: "Essenziali", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Documenti di identità")
        PersistenceManager.shared.addOggetto(categoria: "Essenziali", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Lucchetto")
        PersistenceManager.shared.addOggetto(categoria: "Essenziali", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Occhiali da sole")
        PersistenceManager.shared.addOggetto(categoria: "Essenziali", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Bottiglia d’acqua")
        PersistenceManager.shared.addOggetto(categoria: "Essenziali", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Apribottiglie")
        PersistenceManager.shared.addOggetto(categoria: "Essenziali", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Accendino")
        PersistenceManager.shared.addOggetto(categoria: "Essenziali", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Borraccia")
        PersistenceManager.shared.addOggetto(categoria: "Essenziali", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Ombrello")
        PersistenceManager.shared.addOggetto(categoria: "Essenziali", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Libro")
        //Categoria 4
        PersistenceManager.shared.addOggetto(categoria: "Campeggio", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Buste di plastica")
        PersistenceManager.shared.addOggetto(categoria: "Campeggio", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Carta Igienica")
        PersistenceManager.shared.addOggetto(categoria: "Campeggio", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Coltello mutliuso")
        PersistenceManager.shared.addOggetto(categoria: "Campeggio", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Cuscino")
        PersistenceManager.shared.addOggetto(categoria: "Campeggio", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Torcia")
        PersistenceManager.shared.addOggetto(categoria: "Campeggio", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Utensili da cucina")
        //Categoria 5
        PersistenceManager.shared.addOggetto(categoria: "Spiaggia", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Borsa da spiaggia")
        PersistenceManager.shared.addOggetto(categoria: "Spiaggia", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Cappello")
        PersistenceManager.shared.addOggetto(categoria: "Spiaggia", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Costume da bagno")
        PersistenceManager.shared.addOggetto(categoria: "Spiaggia", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Protezione Solare")
        PersistenceManager.shared.addOggetto(categoria: "Spiaggia", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Doposole")
        PersistenceManager.shared.addOggetto(categoria: "Spiaggia", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Ombrellone da spiaggia")
        PersistenceManager.shared.addOggetto(categoria: "Spiaggia", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Telo mare")
        PersistenceManager.shared.addOggetto(categoria: "Spiaggia", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Occhialini")
        //Categoria 6
        PersistenceManager.shared.addOggetto(categoria: "Sport", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "T-shirt da palestra")
        PersistenceManager.shared.addOggetto(categoria: "Sport", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Felpa tuta")
        PersistenceManager.shared.addOggetto(categoria: "Sport", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Pantaloni tuta")
        PersistenceManager.shared.addOggetto(categoria: "Sport", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Pantaloncini tuta")
        PersistenceManager.shared.addOggetto(categoria: "Sport", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Scarpe da ginnastica")
        PersistenceManager.shared.addOggetto(categoria: "Sport", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Scarpe da trekking")
        //Categoria 7
        PersistenceManager.shared.addOggetto(categoria: "Informatica ed Elettronica", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Caricabatterie smartphone")
        PersistenceManager.shared.addOggetto(categoria: "Informatica ed Elettronica", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Macchina Fotografica")
        PersistenceManager.shared.addOggetto(categoria: "Informatica ed Elettronica", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Cuffie")
        PersistenceManager.shared.addOggetto(categoria: "Informatica ed Elettronica", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Computer portatile")
        PersistenceManager.shared.addOggetto(categoria: "Informatica ed Elettronica", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Caricatore laptop")
        PersistenceManager.shared.addOggetto(categoria: "Informatica ed Elettronica", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Smartwatch")
        PersistenceManager.shared.addOggetto(categoria: "Informatica ed Elettronica", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Caricatore Smartwatch")
        PersistenceManager.shared.addOggetto(categoria: "Informatica ed Elettronica", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Powerbank")
        PersistenceManager.shared.addOggetto(categoria: "Informatica ed Elettronica", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Cacciaviti")
    }
    
    func inizializzaValigie(){
        
        PersistenceManager.shared.addValigia(categoria: "Trolley", lunghezza: 35, larghezza: 40, profondita: 20, nome: "Blu", tara: 1000, utilizzato: true)
        PersistenceManager.shared.addValigia(categoria: "Trolley", lunghezza: 20, larghezza: 30, profondita: 20, nome: "Rossa", tara: 1000, utilizzato: true)
        PersistenceManager.shared.addValigia(categoria: "Trolley", lunghezza: 20, larghezza: 30, profondita: 20, nome: "Verde", tara: 1000, utilizzato: true)
        PersistenceManager.shared.addValigia(categoria: "Trolley", lunghezza: 20, larghezza: 30, profondita: 20, nome: "Viola", tara: 1000, utilizzato: true)
        
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

