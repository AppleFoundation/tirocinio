//
//  AddNuovoOggetto.swift
//  tirocinio
//
//  Created by Salvatore Apicella on 31/05/22.
//

import SwiftUI

struct AddNuovoOggetto: View {
    
    @State var categoria: String = ""
    @State var nomeAgg: String = ""
    @State var lunghezzaAgg: Double = 0.0
    @State var larghezzaAgg: Double = 0.0
    @State var profonditaAgg: Double = 0.0
    @State var pesoAgg: Double = 0.0
    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.managedObjectContext) private var viewContext
    
    
//
    var body: some View {
        
        Form{
            Section(header: Text("Categoria")){
                Picker("Categoria", selection: $categoria) {
                    Text("Articoli da bagno")
                    Text("Abbigliamento")
                    Text("Essenziali")
                    Text("Campeggio")
                    Text("Spiaggia")
                    Text("Sport")
                    Text("Informatica ed Elettronica")
                }
                .pickerStyle(.wheel)
                
            }
            
            Text("\(categoria)")
            
            Section(header: Text("Categoria")){
                
                TextField("Nuovo nome viaggio", text: $categoria)
            }
            
            Section(header: Text("Nome")){
                TextField("Nuovo nome viaggio", text: $nomeAgg)
                //Inserire un limite di caratteri massimo 30 (calcolato altrimenti è brutto da vedere)
            }
            
            Section(header: Text("Lunghezza (centimetri): \(Int(lunghezzaAgg)) ")){
                Slider(value: $lunghezzaAgg, in: 0...60, step: 1.0)
            }
            
            Section(header: Text("Larghezza (centimetri): \(Int(larghezzaAgg))")){
                Slider(value: $larghezzaAgg, in: 0...60, step: 1.0)
            }
            
            Section(header: Text("Profondita (centimetri): \(Int(profonditaAgg))")){
                Slider(value: $profonditaAgg, in: 0...60, step: 1.0)
            }
            Section(header: Text("Peso (grammi): \(Int(pesoAgg))")){
                Slider(value: $pesoAgg, in: 0...3000, step: 50.0)
            }
            
        }
            .navigationBarBackButtonHidden(true)
            .navigationTitle("Nuovo oggetto")
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing){
                    Button(action: {
                        
                        if(nomeAgg.isEmpty){
                            nomeAgg = "Oggetto"
                        }
                        
                        if(categoria.isEmpty){
                            categoria = "Altro"
                        }
                        
                        if(lunghezzaAgg == 0){
                            lunghezzaAgg = 1
                        }
                        
                        if(larghezzaAgg == 0){
                            larghezzaAgg = 1
                        }
                        
                        if(profonditaAgg == 0){
                            profonditaAgg = 1
                        }
                        
                        if(pesoAgg == 0){
                            pesoAgg = 1
                        }
                        
                        PersistenceManager.shared.addOggetto(categoria: categoria, larghezza: Int(larghezzaAgg), lunghezza: Int(lunghezzaAgg), profondita: Int(profonditaAgg), peso: Int(pesoAgg), nome: nomeAgg)
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
            
        
    }
}

