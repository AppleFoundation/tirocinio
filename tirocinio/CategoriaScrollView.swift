//
//  CategoriaScrollView.swift
//  tirocinio
//
//  Created by Salvatore Apicella on 11/05/22.
//

import SwiftUI

struct CategoriaScrollView: View{
    
    var nome: String
    
    var viaggio: Viaggio
    
    var oggettiCategia: [Oggetto]
    
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
                    
                    ForEach(oggettiCategia){
                        oggetto in
                        CardView(oggetto: oggetto, viaggio: viaggio, value: PersistenceManager.shared.loadOggettiViaggiantiFromOggettoValigia(oggettoRef: oggetto, viaggioRef: viaggio).count)
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

//struct CategoriaScrollView_Previews: PreviewProvider {
//    static var previews: some View {
//        CategoriaScrollView(nome: "Test", viaggio: <#Viaggio#>, oggettiCategia: PersistenceManager.shared.loadAllOggetti())
//    }
//}
