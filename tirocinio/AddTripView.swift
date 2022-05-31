//
//  AddTripView.swift
//  ValigieSmart
//
//  Created by Salvatore Apicella on 25/04/22.
//

import SwiftUI


struct AddTripView: View {
    
    //Qui si deve prendere al DB tutto quello che si ha riguardo agli oggetti
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    
    @FetchRequest<Oggetto>(entity: Oggetto.entity(), sortDescriptors: []) var allOggetti: FetchedResults<Oggetto>
    
    let categories = ["Maglie","Felpe"]
   
    
    var body: some View {
        
        
        
            
            ScrollView(.vertical){
                VStack{
                    
                    //Qui si devono passare una serie di array alle varie categorie in modo che possano prelevare e visualizzare gli elementi
                   
                    
                    CategoriaScrollView(nome: categories[0], oggettiCategia: PersistenceManager.shared.loadOggettiFromCategoria(categoria: categories[0]))
                    
                    CategoriaScrollView(nome: categories[1], oggettiCategia: PersistenceManager.shared.loadOggettiFromCategoria(categoria: categories[1]))
                    
//                    CategoriaScrollView(nome: "Categoria 1")
//                    CategoriaScrollView(nome: "Categoria 2")
//                    CategoriaScrollView(nome: "Categoria 3")
//                    CategoriaScrollView(nome: "Categoria 4")
//                    CategoriaScrollView(nome: "Categoria 5")
                    
                }
                .padding()
                
            }
            
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading){
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Cancel")
                    })
                    
                }
                
                ToolbarItem(placement: .navigationBarTrailing){
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Salva")
                    })
                    
                }

            }
        
        .navigationBarBackButtonHidden(true)
        .navigationTitle("Aggiungi Oggetti")
    }
}





struct AddTripView_Previews: PreviewProvider {
    static var previews: some View {
        AddTripView()
    }
}
