//
//  AddTripView.swift
//  ValigieSmart
//
//  Created by Salvatore Apicella on 25/04/22.
//

import SwiftUI


struct AddBagView: View {
    
    var body: some View {
        ScrollView(.vertical){
            VStack{
               
                CategoriaScrollView(nome: "Categoria 1")
                CategoriaScrollView(nome: "Categoria 2")
                CategoriaScrollView(nome: "Categoria 3")
                CategoriaScrollView(nome: "Categoria 4")
                CategoriaScrollView(nome: "Categoria 5")
                
            }
            
        }
    }
}






struct AddBagView_Previews: PreviewProvider {
    static var previews: some View {
        AddBagView()
    }
}
