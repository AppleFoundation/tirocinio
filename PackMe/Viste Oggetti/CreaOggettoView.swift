//
//  AddNuovoOggetto.swift
//  tirocinio
//
//  Created by Salvatore Apicella on 31/05/22.
//

import SwiftUI

struct CreaOggettoView: View {

    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.managedObjectContext) private var viewContext
    
    
    @State private var selectedCategoria: CategorieOggetto = .altro
    @State var nomeAgg: String = ""
    @State var lunghezzaAgg: Double = 1.0
    @State var larghezzaAgg: Double = 1.0
    @State var profonditaAgg: Double = 1.0
    @State var pesoAgg: Double = 0.0
  
    enum CategorieOggetto: String, CaseIterable, Identifiable {
        case articoliDaBagno, abbigliamento, essenziali, campeggio, spiaggia, sport, informaticaElettronica, altro
        var id: Self { self }
    }
    
    var body: some View {
        
        Form{
            
            
            
            Section(header: Text("Nome")){
                TextField("Nuovo nome oggetto", text: $nomeAgg)
            }
            
            Section(header: Text("Categoria")){
                Picker("Categoria", selection: $selectedCategoria) {
                    Text("Abbigliamento").tag(CategorieOggetto.abbigliamento)
                    Text("Altro").tag(CategorieOggetto.altro)
                    Text("Articoli da bagno").tag(CategorieOggetto.articoliDaBagno)
                    Text("Campeggio").tag(CategorieOggetto.campeggio)
                    Text("Essenziali").tag(CategorieOggetto.essenziali)
                    Text("Informatica ed Elettronica").tag(CategorieOggetto.informaticaElettronica)
                    Text("Spiaggia").tag(CategorieOggetto.spiaggia)
                    Text("Sport").tag(CategorieOggetto.sport) 
                }
                .pickerStyle(.menu)
                }
            
            Section(header: Text("Dimensioni")){
                Text("Volume (litri): \(String(format: "%.3f", lunghezzaAgg*larghezzaAgg*profonditaAgg/1000))")
                Text("Lunghezza (centimetri): \(Int(lunghezzaAgg)) ")
                Slider(value: $lunghezzaAgg, in: 1...60, step: 1.0)
                Text("Larghezza (centimetri): \(Int(larghezzaAgg))")
                Slider(value: $larghezzaAgg, in: 1...60, step: 1.0)
                Text("Profondita (centimetri): \(Int(profonditaAgg))")
                Slider(value: $profonditaAgg, in: 1...60, step: 1.0)
                
            }
            
            Section(header: Text("Peso (grammi): \(Int(pesoAgg))")){
                Slider(value: $pesoAgg, in: 0...3000, step: 50.0)
            }
            
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle("Nuovo oggetto")
        .navigationBarTitleDisplayMode(.inline)
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
                    
                    
                    
                    PersistenceManager.shared.addOggetto(categoria: {
                        switch selectedCategoria {
                        case .articoliDaBagno:
                            return "Articoli da bagno"
                        case .abbigliamento:
                            return "Abbigliamento"
                        case .essenziali:
                            return "Essenziali"
                        case .campeggio:
                            return "Campeggio"
                        case .spiaggia:
                            return "Spiaggia"
                        case .sport:
                            return "Sport"
                        case .informaticaElettronica:
                            return "Informatica ed elettronica"
                        case .altro:
                            return "Altro"
                        }
                        
                    }(), larghezza: Int(larghezzaAgg), lunghezza: Int(lunghezzaAgg), profondita: Int(profonditaAgg), peso: Int(pesoAgg), nome: {
                        if(!nomeAgg.isEmpty){
                            return nomeAgg
                        }else{
                            var i = 1
                            while (!PersistenceManager.shared.loadOggettiFromNomeCategoria(nome: "Oggetto " + "\(i)", categoria: {
                                switch selectedCategoria {
                                case .articoliDaBagno:
                                    return "Articoli da bagno"
                                case .abbigliamento:
                                    return "Abbigliamento"
                                case .essenziali:
                                    return "Essenziali"
                                case .campeggio:
                                    return "Campeggio"
                                case .spiaggia:
                                    return "Spiaggia"
                                case .sport:
                                    return "Sport"
                                case .informaticaElettronica:
                                    return "Informatica ed elettronica"
                                case .altro:
                                    return "Altro"
                                }
                                
                            }()).isEmpty){
                                i += 1
                            }
                            nomeAgg = "Oggetto " + "\(i)"
                            return "Oggetto " + "\(i)"
                        }
                    }())
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
        .onChange(of: larghezzaAgg, perform: {value in hideKeyboard()})
        .onChange(of: lunghezzaAgg, perform: {value in hideKeyboard()})
        .onChange(of: profonditaAgg, perform: {value in hideKeyboard()})
        .onChange(of: pesoAgg, perform: {value in hideKeyboard()})
    }
}

