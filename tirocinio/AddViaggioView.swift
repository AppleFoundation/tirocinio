//
//  AddViaggioView.swift
//  tirocinio
//
//  Created by Cristian Cerasuolo on 22/05/22.
//

import SwiftUI

struct AddViaggioView: View {
    @State var nomeViaggio: String = ""
    @State var dataViaggio: Date = Date.now
    @State var tipoViaggio: String = ""
    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.managedObjectContext) private var viewContext
    
    enum TipiViaggio: String, CaseIterable, Identifiable {
        case aereo, nave, auto, bus, treno, estate, primavera, autunno, inverno, america, europa, asia
        var id: Self { self }
    }
    @State private var selectedTipo: TipiViaggio = .aereo
    
    var body: some View {
        Form{
            //nome, data
            Section(header: Text("Nome")){
                
                TextField("Nome Viaggio", text: $nomeViaggio)
                
                //Inserire un limite di caratteri massimo 30
                
                
            }
            
            Section(header: Text("Icona")){
                Picker("Tipo", selection: $selectedTipo) {
                    Image(systemName: "car.fill").tag(TipiViaggio.auto)
                    Image(systemName: "bus.fill").tag(TipiViaggio.bus)
                    Image(systemName: "tram.fill").tag(TipiViaggio.treno)
                    Image(systemName: "ferry.fill").tag(TipiViaggio.nave)
                    Image(systemName: "airplane").tag(TipiViaggio.aereo)
                }
                .pickerStyle(.segmented)
                
                Picker("Tipo", selection: $selectedTipo) {
                    Image(systemName: "snowflake").tag(TipiViaggio.inverno)
                    Image(systemName: "leaf.fill").tag(TipiViaggio.primavera)
                    Image(systemName: "sun.max.fill").tag(TipiViaggio.estate)
                    Image(systemName: "drop.fill").tag(TipiViaggio.autunno)
                }
                .pickerStyle(.segmented)
                
                Picker("Tipo", selection: $selectedTipo) {
                    Image(systemName: "globe.americas").tag(TipiViaggio.america)
                    Image(systemName: "globe.europe.africa.fill").tag(TipiViaggio.europa)
                    Image(systemName: "globe.asia.australia.fill").tag(TipiViaggio.asia)
                }
                .pickerStyle(.segmented)
                
            }
            
            Section(header: Text("Data partenza")){
                DatePicker("", selection: $dataViaggio, displayedComponents: .date)
                    .datePickerStyle(.graphical)
            }
            
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle("Nuovo viaggio")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar{
            ToolbarItem(placement: .navigationBarTrailing){
                Button(action: {
                    PersistenceManager.shared.addViaggio(data: dataViaggio, nome: {
                        if(!nomeViaggio.isEmpty){
                            return nomeViaggio
                        }else{
                            var i = 1
                            while (!PersistenceManager.shared.loadViaggiFromNome(nome: "Viaggio " + "\(i)").isEmpty){
                                i += 1
                            }
                            nomeViaggio = "Viaggio " + "\(i)"
                            return "Viaggio " + "\(i)"
                        }
                    }(), tipo: {
                        switch selectedTipo {
                        case .aereo:
                            return "airplane"
                        case .nave:
                            return "ferry.fill"
                        case .estate:
                            return "sun.max.fill"
                        case .primavera:
                            return "leaf.fill"
                        case .autunno:
                            return "drop.fill"
                        case .inverno:
                            return "snowflake"
                        case .auto:
                            return "car.fill"
                        case .bus:
                            return "bus.fill"
                        case .treno:
                            return "tram.fill"
                        case .america:
                            return "globe.americas"
                        case .europa:
                            return "globe.europe.africa.fill"
                        case .asia:
                            return "globe.asia.australia.fill"
                        }
                    }())
                    
                    //non allocati è una valigia di sistema creata per ogni viaggio in grado di contenere gli oggetti non ancora allocati
                    PersistenceManager.shared.addValigia(categoria: "0SYSTEM", lunghezza: 0, larghezza: 0, profondita: 0, nome: "Non Allocati", tara: 0, utilizzato: false) //Da togliere quando inizializziamo bene l'applicazione
                    
                    let nonallocati: Valigia = PersistenceManager.shared.loadValigieFromCategoria(categoria: "0SYSTEM")[0]
                    PersistenceManager.shared.addValigiaViaggiante(valigia: nonallocati, viaggio: PersistenceManager.shared.loadViaggiFromNome(nome: nomeViaggio)[0], pesoMassimo: 0)
                    presentationMode.wrappedValue.dismiss()
                    
                }, label: {Text("Save")})
            }
            ToolbarItem(placement: .navigationBarLeading){
                Button(action: {
                    //                        allViaggi = PersistenceManager.shared.loadAllViaggi()
                    presentationMode.wrappedValue.dismiss()
                }, label: {Text("Cancel")})
            }
        }
        .onTapGesture {
            self.hideKeyboard()
        }
        
        
    }
}

//struct AddViaggioView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddViaggioView()
//    }
//}

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
