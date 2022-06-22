//
//  AddViaggioView.swift
//  tirocinio
//
//  Created by Cristian Cerasuolo on 22/05/22.
//

import SwiftUI

struct EditViaggioView: View {
    @State var nomeViaggio: String
    @State var dataViaggio: Date
    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.managedObjectContext) private var viewContext
    
    enum TipiViaggio: String, CaseIterable, Identifiable {
        case aereo, nave, auto, bus, treno, estate, primavera, autunno, inverno, america, europa, asia
        var id: Self { self }
    }
    @State var oldIcon: String
    @State var selectedTipo: TipiViaggio = .aereo
    
    var viaggio: Viaggio
    
    var body: some View {
        
        Form{
            //nome, data
            Section(header: Text("Nome")){
                TextField("Nuovo nome viaggio", text: $nomeViaggio)
                //Inserire un limite di caratteri massimo 30 (calcolato altrimenti è brutto da vedere)
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
            
            //                Section(header: Text("Vecchia data: \(viaggio.data?.formatted() ?? Date.init().formatted())")){
            Section(header: Text("Data partenza")){
                DatePicker("", selection: $dataViaggio, displayedComponents: .date)
                    .datePickerStyle(.graphical)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle("Modifica viaggio")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar{
            ToolbarItem(placement: .navigationBarTrailing){
                Button(action: {
                    viaggio.nome = nomeViaggio
                    viaggio.data = dataViaggio
                    
                    switch selectedTipo {
                    case .aereo:
                        viaggio.tipo =  "airplane"
                    case .nave:
                        viaggio.tipo =  "ferry.fill"
                    case .estate:
                        viaggio.tipo =  "sun.max.fill"
                    case .primavera:
                        viaggio.tipo =  "leaf.fill"
                    case .autunno:
                        viaggio.tipo =  "drop.fill"
                    case .inverno:
                        viaggio.tipo =  "snowflake"
                    case .auto:
                        viaggio.tipo =  "car.fill"
                    case .bus:
                        viaggio.tipo =  "bus.fill"
                    case .treno:
                        viaggio.tipo =  "tram.fill"
                    case .america:
                        viaggio.tipo =  "globe.americas"
                    case .europa:
                        viaggio.tipo =  "globe.europe.africa.fill"
                    case .asia:
                        viaggio.tipo =  "globe.asia.australia.fill"
                    }
                    
                    
                    PersistenceManager.shared.saveContext()
                    
                    presentationMode.wrappedValue.dismiss()
                }, label: {Text("Save")})
            }
            ToolbarItem(placement: .navigationBarLeading){
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {Text("Cancel")})
            }
        }
        .onAppear(){
            switch oldIcon{
                
            case "airplane":
                selectedTipo = .aereo
            case "ferry.fill":
                selectedTipo = .nave
            case "sun.max.fill":
                selectedTipo = .estate
            case "leaf.fill":
                selectedTipo = .primavera
            case "drop.fill":
                selectedTipo = .autunno
            case "snowflake":
                selectedTipo = .inverno
            case "car.fill":
                selectedTipo = .auto
            case "bus.fill":
                selectedTipo = .bus
            case "tram.fill":
                selectedTipo = .treno
            case "globe.americas":
                selectedTipo = .america
            case "globe.europe.africa.fill":
                selectedTipo = .europa
            case "globe.asia.australia.fill":
                selectedTipo = .asia
                
                
                
        
            default:
                selectedTipo = .europa
            }
        }
    }
}
