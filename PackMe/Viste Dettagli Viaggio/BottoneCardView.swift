//
//  BottoneCardView.swift
//  tirocinio
//
//  Created by Salvatore Apicella on 26/06/22.
//

import SwiftUI

struct BottoneCardView: View{
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
  
    @ObservedObject var vStore: ValigieStore
    @ObservedObject var oStore: OggettiStore
    
    @State private var showingAlertOggetti = false
    @State private var showingAlertValigie = false
    @State var volumePeso: Bool = false
    
    var viaggio: Viaggio
    
    init(vStore: ValigieStore, oStore: OggettiStore, viaggio: Viaggio){
        self.vStore = vStore
        self.oStore = oStore
        self.viaggio = viaggio
    }
    
    var body: some View{
        
        HStack{
            Spacer()
            
            VStack{
                Text("Aggiungi Oggetti")
                    .multilineTextAlignment(.center)
                
                Text("Oggetti presenti: \(calculateNumberOggetti(oggettiviaggianti: oStore.oggettiDB))")
                    .font(.caption)
                    .multilineTextAlignment(.center)
                
                Image(systemName: "archivebox.fill")
                    .padding(.top, 1.0)
            }
            .padding()
            .frame(minWidth: 150, maxWidth: 150, minHeight: 80)
            .background(colorScheme == .dark ? Color.init(white: 0.2) : Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(color: Color.black.opacity(0.2), radius: 10, y: 5)
            .overlay(){
                NavigationLink(destination:  AggiungiOggettiView(viaggio: viaggio)){
                    Rectangle()
                        .background(Color.white)
                        .opacity(0.1)
                        .cornerRadius(10)
                }
            }
            .contextMenu(.init(menuItems: {
                Button(action: {
                    showingAlertOggetti = true
                }, label: {
                    HStack {
                        Text("Togli oggetti")
                        Image(systemName: "trash")
                    }
                })
            }))
            .confirmationDialog("Vuoi davvero togliere tutti gli oggetti?", isPresented: $showingAlertOggetti, titleVisibility: .visible){
                Button("Rimuovi", role: .destructive){
                    PersistenceManager.shared.deleteAllOggettoViaggiante(viaggio: viaggio)
                }
            }
            Spacer()
            VStack{
                let numValigieDiSistema: Int = PersistenceManager.shared.loadValigieFromCategoria(categoria: "0SYSTEM").count
                Text("Aggiungi Valigie")
                    .multilineTextAlignment(.center)
                Text("Valigie presenti: \(vStore.valigieDB.count - numValigieDiSistema)")
                    .font(.caption)
                    .multilineTextAlignment(.center)
                Image(systemName: "suitcase.fill")
                    .padding(.top, 1.0)
                
            }
            .padding()
            .frame(minWidth: 150, maxWidth: 150, minHeight: 80)
            .background(colorScheme == .dark ? Color.init(white: 0.2) : Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(color: Color.black.opacity(0.2), radius: 10, y: 5)
            .overlay(){
                NavigationLink(destination:  AggiungiValigieView(viaggio: viaggio)){
                    Rectangle()
                        .background(Color.white)
                        .opacity(0.1)
                        .cornerRadius(10)
                }
            }
            .contextMenu(.init(menuItems: {
                
                Button(action: {
                    showingAlertValigie = true
                }, label: {
                    HStack {
                        Text("Togli valigie")
                        Image(systemName: "trash")
                    }
                })
                
            }))
            .confirmationDialog("Vuoi davvero togliere tutte le valigie?", isPresented: $showingAlertValigie, titleVisibility: .visible){
                Button("Rimuovi", role: .destructive){
                    PersistenceManager.shared.deleteAllValigiaViaggiante(viaggio: viaggio)
                    //                    presentationMode.wrappedValue.dismiss()
                    vStore.valigieDB.removeAll()
                    vStore.valigieDB.append(PersistenceManager.shared.loadValigieViaggiantiFromViaggio(viaggio: viaggio)[0]) //per ipotesi l'unica valigia rimasta è quella dei non
                    PersistenceManager.shared.allocaOggetti(viaggio: viaggio, ordinamento: viaggio.allocaPer)
                    
                }
            }
            Spacer()
        }
        HStack{
            Toggle(isOn: $volumePeso){
                Text("Usa i limiti di peso")
                    .font(.title2.bold())
            }
            .onChange(of: volumePeso){ value in
                viaggio.allocaPer = value
                PersistenceManager.shared.allocaOggetti(viaggio: viaggio, ordinamento: value)
            }
            .toggleStyle(.switch)
            .padding(.horizontal)
            .padding(.vertical, 10)
            .background(colorScheme == .dark ? Color.init(white: 0.1) : Color.init(white: 1.0))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(color: Color.black.opacity(0.2), radius: 10, y: 5)
            .padding(.horizontal, 20)
            .padding(.vertical)
        }
        .onAppear{
            self.volumePeso = self.viaggio.allocaPer
        }
    }
    
    func calculateNumberOggetti(oggettiviaggianti: [OggettoViaggiante]) -> Int{
        var sum: Int = 0
        for i in oggettiviaggianti.map({$0.quantitaInViaggio}){
            sum += Int(i)
        }
        
        return sum
    }
    
}
