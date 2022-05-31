//
//  BagCategoriaScrollView.swift
//  tirocinio
//
//  Created by Salvatore Apicella on 31/05/22.
//

import SwiftUI

struct BagCategoriaScrollView: View{
    
    var nome: String
    
    var valigiaCategoria: [Valigia]
    
    //Qui bisogna creare un array di oggetti da visualizzare che deve essere passato dalla add bag view
    
    var body: some View{
        VStack{
            HStack{
                Text(nome)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color.blue)
                Spacer()
            }
            
            ScrollView(.horizontal){
                HStack{
                    
                    ForEach(valigiaCategoria){
                        valigia in
                        ValigiaCardView(valigia: valigia)
                    }
                    
//                    CardView(nome: "Maglia")
//                    CardView(nome: "Maglione")
//                    CardView(nome: "Jeans")
//                    CardView(nome: "Canottiera")
//                    CardView(nome: "Camicia")
//                    CardView(nome: "Guanti")
                }
                
            }
        }
    }
}

struct BagCategoriaScrollView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriaScrollView(nome: "Test", oggettiCategia: PersistenceManager.shared.loadAllOggetti())
    }
}

