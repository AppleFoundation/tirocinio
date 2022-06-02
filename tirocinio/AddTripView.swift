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
    
    
    let categories = ["Articoli da bagno",
                      "Abbigliamento",
                      "Essenziali",
                      "Campeggio",
                      "Spiaggia",
                      "Sport",
                      "Informatica ed Elettronica"
    ]
    
    var viaggio: Viaggio

    
    var body: some View {
        
        
        
            
        ScrollView(.vertical, showsIndicators: false){
                VStack{
                    
                    //Qui si devono passare una serie di array alle varie categorie in modo che possano prelevare e visualizzare gli elementi
                   
                    ForEach(categories){ currentCat in
                        let cat = PersistenceManager.shared.loadOggettiFromCategoria(categoria: currentCat)
                        
                        if (!cat.isEmpty){
                            CategoriaScrollView(nome: currentCat, viaggio: viaggio, oggettiCategia: cat)
                        }
                    }
                    
                    Spacer(minLength: 50)
                  
                }
                
                
            }
        
        
        
            
            .toolbar{
                

                
                ToolbarItem(placement: .navigationBarTrailing){
                    
                    NavigationLink(destination: AddNuovoOggetto(), label: {
                        Image(systemName: "plus")
                    })
                   
                }
                
                ToolbarItem(placement: .navigationBarTrailing){
                    Button(action: {

                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Salva")
                    })

                }
                
                ToolbarItem(placement: .navigationBarLeading){
                    
                    Button(action: {
                        PersistenceManager.shared.deleteAllOggettoViaggiante(viaggio: viaggio)
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Reset")
                    })
                   
                }
            
                
                

            }
        
            .navigationBarBackButtonHidden(true)
            .background{
                Image("bg1")
                    .resizable()
                    .ignoresSafeArea()
                    .scaledToFill()
            }
            
            .navigationTitle("Aggiungi Oggetti")
    }
}




//
//struct AddTripView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddTripView()
//    }
//}
