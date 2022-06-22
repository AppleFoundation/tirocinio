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
    
    var oggettiCategoria: [Oggetto]
    
    //Qui bisogna creare un array di oggetti da visualizzare che deve essere passato dalla add bag view
    
    var body: some View{
        VStack{
            HStack{
                Text(nome)
                    .font(.title)
                    .fontWeight(.bold)
                //                    .foregroundColor(Color.gray)
                    .padding()
                Spacer()
            }
            
            let rows: [GridItem] = Array(repeating: GridItem.init(.fixed(60), spacing: 5, alignment: .center), count: oggettiCategoria.count < 3 ? oggettiCategoria.count : 3)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack{
                    Spacer(minLength: 15) //Utile per far iniziare la scroll più a destra e farlo combaciare col padding superiore
                    LazyHGrid(rows: rows, alignment: .top, spacing: 15) {
                        
                        ForEach(oggettiCategoria.sorted(by: { lhs, rhs in
                            return (lhs.nome! < rhs.nome!)
                        })){
                            oggetto in
                            
                            CardView(oggetto: oggetto, viaggio: viaggio)
                            
                            
                        }
                        
                    }
                    Spacer(minLength: 15) //Utile per avere più simmetria
                }
                
                
                
            }
            
        }
    }
}

struct CategoriaScrollView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriaScrollView(nome: "Test", viaggio: PersistenceManager.shared.loadAllViaggi()[0], oggettiCategoria: PersistenceManager.shared.loadAllOggetti())
    }
}
