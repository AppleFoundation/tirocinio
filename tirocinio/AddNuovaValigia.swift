//
//  AddNuovaValigia.swift
//  tirocinio
//
//  Created by Salvatore Apicella on 31/05/22.
//

import SwiftUI

struct AddNuovaValigia: View {
    
    enum CategorieValigie: String, CaseIterable, Identifiable {
        case altro, trolley, bagaglioStiva, piccola, zaino
        var id: Self { self }
    }
    @State private var selectedCategoria: CategorieValigie = .altro
    
    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.managedObjectContext) private var viewContext
    @State var nome: String = ""
    
    @State var lunghezza: Double = 0.0
    @State var larghezza: Double = 0.0
    @State var profondita: Double = 0.0
    @State var tara: Double = 0.0
    
    
    
    
    //    @Binding var allViaggi: [Viaggio]
    //
    //    init(allViaggi: Binding<[Viaggio]>){
    //        self._allViaggi = allViaggi
    //    }
    var body: some View {
        Form{
            Section(header: Text("Nome")){
                TextField("Nuovo nome valigia", text: $nome)
                //Inserire un limite di caratteri massimo 30 (calcolato altrimenti è brutto da vedere)
            }
            
            
            Section(header: Text("Categoria")){
                Picker("Categoria", selection: $selectedCategoria) {
                    Text("Altro").tag(CategorieValigie.altro)
                    Text("Trolley").tag(CategorieValigie.trolley)
                    Text("Bagaglio da stiva").tag(CategorieValigie.bagaglioStiva)
                    Text("Piccola").tag(CategorieValigie.piccola)
                    Text("Zaino").tag(CategorieValigie.zaino)
                }
                .pickerStyle(.menu)
                
            }
            
            Section(header: Text("Lunghezza (centimetri): \(Int(lunghezza)) ")){
                Slider(value: $lunghezza, in: 0...60, step: 1.0)
            }
            
            Section(header: Text("Larghezza (centimetri): \(Int(larghezza))")){
                Slider(value: $larghezza, in: 0...60, step: 1.0)
            }
            
            Section(header: Text("Profondita (centimetri): \(Int(profondita))")){
                Slider(value: $profondita, in: 0...60, step: 1.0)
            }
            
            
            Section(header: Text("Tara (grammi): \(Int(tara))")){
                Slider(value: $tara, in: 0...3000, step: 50.0)
            }
            
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle("Nuova valigia")
        .toolbar{
            ToolbarItem(placement: .navigationBarTrailing){
                Button(action: {
                    PersistenceManager.shared.addValigia(categoria: {
                        switch selectedCategoria {
                        case .altro:
                            return "Altro"
                        case .trolley:
                            return "Trolley"
                        case .bagaglioStiva:
                            return "Bagaglio da stiva"
                        case .piccola:
                            return "Piccola"
                        case .zaino:
                            return "Zaino"
                        }
                    }(), lunghezza: Int(lunghezza), larghezza: Int(larghezza), profondita: Int(profondita), nome: nome, tara: Int(tara), utilizzato: true)
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
