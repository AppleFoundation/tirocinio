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
                    .foregroundColor(Color.orange)
                Spacer()
            }
            
            
            
            let rows: [GridItem] = Array(repeating: .init(.fixed(60)), count: 3)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: rows, alignment: .top) {
                    
                    
                    ForEach(oggettiCategia){
                        oggetto in
                        CardView(oggetto: oggetto, viaggio: viaggio, value: PersistenceManager.shared.loadOggettiViaggiantiFromOggettoViaggio(oggettoRef: oggetto, viaggioRef: viaggio).count)
                            
                            
                            
                    }
                    
                    
                    
                }
            }
            
        
            
            
            
            
        }
    }
}

struct CategoriaScrollView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriaScrollView(nome: "Test", viaggio: PersistenceManager.shared.loadAllViaggi()[0], oggettiCategia: PersistenceManager.shared.loadAllOggetti())
    }
}
