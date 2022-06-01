//
//  AddNuovoOggetto.swift
//  tirocinio
//
//  Created by Salvatore Apicella on 31/05/22.
//

import SwiftUI

struct AddNuovoOggetto: View {
    @State var nome: String = ""
    @State var categoria: String = ""
    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.managedObjectContext) private var viewContext
    
    
    
//    @Binding var allViaggi: [Viaggio]
//
//    init(allViaggi: Binding<[Viaggio]>){
//        self._allViaggi = allViaggi
//    }
    var body: some View {
            Form{
                //nome, data
                Section(header: Text("Nome")){
                    
                    TextField("Nome Oggetto", text: $nome)
                    
                    //Inserire un limite di caratteri massimo 30
                        
        
                }
                Section(header: Text("Categoria")){
                    
                    TextField("Categoria Oggetto", text: $categoria)
                    
                    //Inserire un limite di caratteri massimo 30
                        
        
                }
                
            }
            .navigationBarBackButtonHidden(true)
            .navigationTitle("Nuovo oggetto")
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing){
                    Button(action: {
                        PersistenceManager.shared.addOggetto(categoria: categoria, larghezza: 1, lunghezza: 1, profondita: 1, peso: 1, nome: nome)
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

