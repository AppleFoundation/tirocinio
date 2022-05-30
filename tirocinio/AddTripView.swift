//
//  AddTripView.swift
//  ValigieSmart
//
//  Created by Salvatore Apicella on 25/04/22.
//

import SwiftUI


struct AddTripView: View {
    
    //Qui si deve prendere al DB tutto quello che si ha riguardo agli oggetti
    
    var body: some View {
        
        NavigationView{
            
            ScrollView(.vertical){
                VStack{
                    
                    //Qui si devono passare una serie di array alle varie categorie in modo che possano prelevare e visualizzare gli elementi
                   
                    CategoriaScrollView(nome: "Categoria 1")
                    CategoriaScrollView(nome: "Categoria 2")
                    CategoriaScrollView(nome: "Categoria 3")
                    CategoriaScrollView(nome: "Categoria 4")
                    CategoriaScrollView(nome: "Categoria 5")
                    
                }
                
            }
            
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing){
                    NavigationLink(destination: AddBagView()){
                        Text("Prosegui")
                    }
                }

            }
            
        }
        .navigationBarHidden(true)
    }
}





struct AddTripView_Previews: PreviewProvider {
    static var previews: some View {
        AddTripView()
    }
}
