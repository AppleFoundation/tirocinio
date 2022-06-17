//
//  AddViaggioView.swift
//  tirocinio
//
//  Created by Salvatore Apicella on 02/06/2022.
//

import SwiftUI

struct EditOggettoView: View {
    
    @State var nomeAgg: String
    @State var lunghezzaAgg: Double
    @State var larghezzaAgg: Double
    @State var profonditaAgg: Double
    @State var pesoAgg: Double
    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.managedObjectContext) private var viewContext
    
    var oggetto: Oggetto
    
    
    var body: some View {

        
            Form{
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
            .navigationTitle("Modifica viaggio")
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing){
                    Button(action: {
                        
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
                        
//                        let volume = lunghezzaAgg * larghezzaAgg * profonditaAgg
                        
                        nomeAgg = "" + nomeAgg
                        
                        PersistenceManager.shared.addOggetto(categoria: oggetto.categoria!, larghezza: Int(larghezzaAgg), lunghezza: Int(lunghezzaAgg), profondita: Int(profonditaAgg), peso: Int(pesoAgg), nome: nomeAgg)
                        
//
//                        oggetto.nome = nomeAgg
//                        oggetto.lunghezza = Int32(lunghezzaAgg)
//                        oggetto.larghezza = Int32(larghezzaAgg)
//                        oggetto.profondita = Int32(profonditaAgg)
//                        oggetto.volume = Int32(volume)
//                        oggetto.peso = Int32(pesoAgg)
//                        PersistenceManager.shared.saveContext()
                        presentationMode.wrappedValue.dismiss()
                    }, label: {Text("Save")})
                }
                ToolbarItem(placement: .navigationBarLeading){
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {Text("Cancel")})
                }
            }

    }
    
}
