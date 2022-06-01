//
//  AddBagView.swift
//  ValigieSmart
//
//  Created by Salvatore Apicella on 25/04/22.
//


import SwiftUI

//extension String: Identifiable {
//    public var id: String {
//        self
//    }
//}

struct AddBagView: View {
    
    //Qui si deve prendere al DB tutto quello che si ha riguardo agli oggetti
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    
    @FetchRequest<Valigia>(entity: Valigia.entity(), sortDescriptors: []) var allValigie: FetchedResults<Valigia>
    
    
    
    
    let categories = ["Trolley",
                      "Da stiva",
                      "Piccola",
                      "Prova"
    ]
    
    
    var viaggio: Viaggio
    
    var body: some View {
        
        
        
            
            ScrollView(.vertical){
                VStack{
                    
                    //Qui si devono passare una serie di array alle varie categorie in modo che possano prelevare e visualizzare gli elementi
                   
                    ForEach(categories){ currentCat in
                        let cat = PersistenceManager.shared.loadValigieFromCategoria(categoria: currentCat)
                        
                        if (!cat.isEmpty){
                            BagCategoriaScrollView(nome: currentCat, viaggio: viaggio, valigiaCategoria: cat)
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
        .navigationTitle("Aggiungi Valigie")
    }
}





//struct AddBagView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddTripView()
//    }
//}


