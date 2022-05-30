//
//  AddTripView.swift
//  ValigieSmart
//
//  Created by Salvatore Apicella on 25/04/22.
//

import SwiftUI


struct AddBagView: View {
    
    //Qui ci deve essere una variabile che prende tutto il DB di valigie e metta una struttura tutte le valigie possibili
    
    var body: some View {
        ScrollView(.vertical){
            VStack{
               
                //Qui si deve passare a categoria un array di valigie di quella categoria in modo dale che le possa visualizzare
                
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
            .previewDevice("iPhone 11")
    }
}
