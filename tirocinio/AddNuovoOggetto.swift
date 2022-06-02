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
                        PersistenceManager.shared.addOggetto(categoria: categoria, larghezza: 1, lunghezza: 1, profondita: 1, peso: 1, nome: nomeAgg)
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

