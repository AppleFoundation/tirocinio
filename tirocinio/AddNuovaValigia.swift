//
//  AddNuovaValigia.swift
//  tirocinio
//
//  Created by Salvatore Apicella on 31/05/22.
//

import SwiftUI

struct AddNuovaValigia: View {
    
    
    
    enum CategorieValigie: String, CaseIterable, Identifiable {
        case altro, bagaglioAMano, bagaglioDaStiva, borsone, valigiaGrande, valigiaMedia, valigiaPiccola, trolley, zaino
        var id: Self { self }
    }
    @State private var selectedCategoria: CategorieValigie = .altro
    
    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.managedObjectContext) private var viewContext
    @State var nome: String = ""
    
    @State var lunghezza: Double = 1.0
    @State var larghezza: Double = 1.0
    @State var profondita: Double = 1.0
    @State var tara: Double = 0.0
    
    
    
    
    //    @Binding var allViaggi: [Viaggio]
    //
    //    init(allViaggi: Binding<[Viaggio]>){
    //        self._allViaggi = allViaggi
    //    }
    var body: some View {
        Form{
            Section(header: Text("Nome")){
                TextField("Nome nuova valigia", text: $nome)
                //Inserire un limite di caratteri massimo 30 (calcolato altrimenti è brutto da vedere)
            }
            
            
            Section(header: Text("Categoria")){
                Picker("Categoria", selection: $selectedCategoria) {
                    Text("Altro").tag(CategorieValigie.altro)
                    Text("Bagaglio a mano").tag(CategorieValigie.bagaglioAMano)
                    Text("Bagaglio da stiva").tag(CategorieValigie.bagaglioDaStiva)
                    Text("Borsone").tag(CategorieValigie.borsone)
                    Text("Valigia grande").tag(CategorieValigie.valigiaGrande)
                    Text("Valigia media").tag(CategorieValigie.valigiaMedia)
                    Text("Valigia piccola").tag(CategorieValigie.valigiaPiccola)
                    Text("Trolley").tag(CategorieValigie.trolley)
                    Text("Zaino").tag(CategorieValigie.zaino)
                    
                }
                .pickerStyle(.menu)
                .onChange(of: selectedCategoria){ value in
                    
                        switch value{
                        case .altro:
                            lunghezza = 1
                            larghezza = 1
                            profondita = 1
                            tara = 0
                        case .bagaglioAMano:
                            lunghezza = 40
                            larghezza = 25
                            profondita = 20
                            tara = 3500
                        case .bagaglioDaStiva:
                            lunghezza = 119
                            larghezza = 119
                            profondita = 81
                            tara = 3500
                        case .borsone:
                            lunghezza = 48
                            larghezza = 52
                            profondita = 35
                            tara = 3500
                        case .valigiaGrande:
                            lunghezza = 119
                            larghezza = 119
                            profondita = 81
                            tara = 3500
                        case .valigiaMedia:
                            lunghezza = 40
                            larghezza = 25
                            profondita = 20
                            tara = 3500
                        case .valigiaPiccola:
                            lunghezza = 2
                            larghezza = 2
                            profondita = 2
                            tara = 3500
                        case .trolley:
                            lunghezza = 56
                            larghezza = 45
                            profondita = 25
                            tara = 3500
                        case .zaino:
                            lunghezza = 40
                            larghezza = 30
                            profondita = 13
                            tara = 3500
                        }
                    
                }
                
            }
            
            Section(header: Text("Dimensioni")){
                Text("Volume (litri): \(String(format: "%.3f", lunghezza*larghezza*profondita/1000))")
                Text("Lunghezza (centimetri): \(Int(lunghezza)) ")
                Slider(value: $lunghezza, in: 1...120, step: 1.0)
                Text("Larghezza (centimetri): \(Int(larghezza))")
                Slider(value: $larghezza, in: 1...120, step: 1.0)
                Text("Profondita (centimetri): \(Int(profondita))")
                Slider(value: $profondita, in: 1...120, step: 1.0)

            }
            
            
            
            Section(header: Text("Tara (grammi): \(Int(tara))")){
                Slider(value: $tara, in: 0...6000, step: 50.0)
            }
            
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle("Nuova valigia")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar{
            ToolbarItem(placement: .navigationBarTrailing){
                Button(action: {
                    PersistenceManager.shared.addValigia(categoria: {
                        switch selectedCategoria {
                        case .altro:
                            return "Altro"
                        case .bagaglioAMano:
                            return "Bagaglio a mano"
                        case .bagaglioDaStiva:
                            return "Bagaglio da stiva"
                        case .borsone:
                            return "Borsone"
                        case .valigiaGrande:
                            return "Valigia grande"
                        case .valigiaMedia:
                            return "Valigia media"
                        case .valigiaPiccola:
                            return "Valigia piccola"
                        case .trolley:
                            return "Trolley"
                        case .zaino:
                            return "Zaino"
                        }
                    }(), lunghezza: Int(lunghezza), larghezza: Int(larghezza), profondita: Int(profondita), nome: {
                        if(!nome.isEmpty){
                            return nome
                        }else{
                            var i = 1
                            while (!PersistenceManager.shared.loadValigieFromNomeCategoria(nome: "Valigia " + " \(i)", categoria: {
                                switch selectedCategoria {
                                case .altro:
                                    return "Altro"
                                case .bagaglioAMano:
                                    return "Bagaglio a mano"
                                case .bagaglioDaStiva:
                                    return "Bagaglio da stiva"
                                case .borsone:
                                    return "Borsone"
                                case .valigiaGrande:
                                    return "Valigia grande"
                                case .valigiaMedia:
                                    return "Valigia media"
                                case .valigiaPiccola:
                                    return "Valigia piccola"
                                case .trolley:
                                    return "Trolley"
                                case .zaino:
                                    return "Zaino"
                                }
                            }()).isEmpty){
                                i += 1
                            }
                            nome = "Valigia " + "\(i)"
                            return "Valigia " + "\(i)"
                        }
                    }(), tara: Int(tara), utilizzato: true)
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
