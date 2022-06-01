//
//  AddNuovaValigia.swift
//  tirocinio
//
//  Created by Salvatore Apicella on 31/05/22.
//

import SwiftUI

struct AddNuovaValigia: View {
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
                    
                    TextField("Nome Valigia", text: $nome)
                    
                    //Inserire un limite di caratteri massimo 30
                        
        
                }
                Section(header: Text("Categoria")){
                    
                    TextField("Categoria Valigia", text: $categoria)
                    
                    //Inserire un limite di caratteri massimo 30
                        
        
                }
                
            }
            .navigationBarBackButtonHidden(true)
            .navigationTitle("Nuova valigia")
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing){
                    Button(action: {
                        PersistenceManager.shared.addValigia(categoria: categoria, lunghezza: 1, larghezza: 1, profondita: 1, nome: nome, tara: 1000, utilizzato: true)
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
