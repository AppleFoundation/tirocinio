//
//  AddTripView.swift
//  ValigieSmart
//
//  Created by Salvatore Apicella on 25/04/22.
//

import SwiftUI


struct AddBagView: View {
    
    //Qui ci deve essere una variabile che prende tutto il DB di valigie e metta una struttura tutte le valigie possibili
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
            
            ScrollView(.vertical){
                VStack{
                    
                    //Qui si devono passare una serie di array alle varie categorie in modo che possano prelevare e visualizzare gli elementi
                   
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
        .navigationTitle("Aggiungi Valigie")
    }
}






struct AddBagView_Previews: PreviewProvider {
    static var previews: some View {
        AddBagView()
            .previewDevice("iPhone 11")
    }
}
