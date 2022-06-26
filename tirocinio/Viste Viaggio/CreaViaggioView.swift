//
//  AddViaggioView.swift
//  tirocinio
//
//  Created by Cristian Cerasuolo on 22/05/22.
//

import SwiftUI

struct CreaViaggioView: View {
    
    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var nomeViaggio: String = ""
    @State var dataViaggio: Date = Date.now
    @State var tipoViaggio: String = ""
    @State private var selectedTipo: TipiViaggio = .aereo
    
    enum TipiViaggio: String, CaseIterable, Identifiable, Equatable {
        case aereo, nave, auto, bus, treno, estate, primavera, autunno, inverno, america, europa, asia
        var id: Self { self }
    }
    
    var body: some View {
        Form{
            //nome, data
            Section(header: Text("Nome")){
                TextField("Nome Viaggio", text: $nomeViaggio)
            }
            .onTapGesture {
                self.hideKeyboard()
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
                    
                    
                    let nonallocati: Valigia = PersistenceManager.shared.loadValigieFromCategoria(categoria: "0SYSTEM")[0]
                    PersistenceManager.shared.addValigiaViaggiante(valigia: nonallocati, viaggio: PersistenceManager.shared.loadViaggiFromNome(nome: nomeViaggio.trimmingCharacters(in: .whitespaces))[0], pesoMassimo: 0)
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
        .onChange(of: dataViaggio, perform: {value in hideKeyboard()})
        .onChange(of: selectedTipo, perform: {value in hideKeyboard()})

        
        
    }
}

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
