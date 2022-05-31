//
//  AddTripView.swift
//  ValigieSmart
//
//  Created by Salvatore Apicella on 25/04/22.
//

import SwiftUI

extension String: Identifiable {
    public var id: String {
        self
    }
}

struct AddTripView: View {
    
    //Qui si deve prendere al DB tutto quello che si ha riguardo agli oggetti
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    
    @FetchRequest<Oggetto>(entity: Oggetto.entity(), sortDescriptors: []) var allOggetti: FetchedResults<Oggetto>
    
    
    let categories = ["Maglie",
                      "Felpe",
                      "Oggetti per la casa",
                      "Beauty",
                      "Prova"
    ]
    
    
   
    
    var body: some View {
        
        
        
            
            ScrollView(.vertical){
                VStack{
                    
                    //Qui si devono passare una serie di array alle varie categorie in modo che possano prelevare e visualizzare gli elementi
                   
                    ForEach(categories){ currentCat in
                        let cat = PersistenceManager.shared.loadOggettiFromCategoria(categoria: currentCat)
                        
                        if (!cat.isEmpty){
                            CategoriaScrollView(nome: currentCat, oggettiCategia: cat)
                        }
                    }
                  
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
