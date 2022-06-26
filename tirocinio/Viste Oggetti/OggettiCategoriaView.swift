//
//  CategoriaScrollView.swift
//  tirocinio
//
//  Created by Salvatore Apicella on 11/05/22.
//

import SwiftUI

struct OggettiCategoriaView: View{
    
    var nome: String
    var viaggio: Viaggio
    var oggettiCategoria: [Oggetto]
    
    var body: some View{
        VStack{
            HStack{
                Text(nome)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                Spacer()
            }
            
            let rows: [GridItem] = Array(repeating: GridItem.init(.flexible(minimum: 60, maximum: .infinity), spacing: 5, alignment: .center), count: oggettiCategoria.count < 3 ? oggettiCategoria.count : 3)
            
            ScrollView(.horizontal, showsIndicators: true) {
                HStack{
                    Spacer(minLength: 15) //Utile per far iniziare la scroll più a destra e farlo combaciare col padding superiore
                    LazyHGrid(rows: rows, alignment: .top, spacing: 15) {
                        
                        ForEach(oggettiCategoria.sorted(by: { lhs, rhs in
                            return (lhs.nome! < rhs.nome!)
                        })){
                            oggetto in

                            let oggettiInValigia = PersistenceManager.shared.loadOggettiInValigiaFromViaggioOggetto(viaggio: viaggio, oggetto: oggetto)
                            if (oggettiInValigia.isEmpty == false){
                                OggettoCardView(oggetto: oggetto, value: Int(oggettiInValigia[0].oggettoViaggianteRef!.quantitaInViaggio), viaggio: viaggio)
                            }else{
                                OggettoCardView(oggetto: oggetto, value: 0, viaggio: viaggio)
                            }
  
                        }
                    }
                    Spacer(minLength: 15) //Utile per avere più simmetria
                }
                .padding(.bottom)
            }
            
        }
        
    }
}



