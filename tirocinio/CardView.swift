//
//  CardView.swift
//  ValigieSmart
//
//  Created by Salvatore Apicella on 25/04/22.
//

import SwiftUI
import SceneKit

struct CardView: View {
    
    
    @State private var editEnable = false
    
    var oggetto: Oggetto
    var viaggio: Viaggio
    
    @State var value: Int
    let step = 1
    let range = 0...50
    
    
    
    var body: some View {
        
        if (editEnable == false){
            HStack{
                
                Text("\(value)")
                    .multilineTextAlignment(.trailing)
                
                Button(action: {
                    value += 1
                    PersistenceManager.shared.addOggettoViaggiante(oggetto: oggetto, viaggio: viaggio)
                }, label: {
                    Text(oggetto.nome ?? "Nome")
                        
                })
                .frame(minWidth: 130)
                
                Button(action: {
                    if(value > 0){
                        value -= 1
                        PersistenceManager.shared.deleteOggettoViaggiante(ogetto: oggetto, viaggio: viaggio)
                    }
                }, label: {
                    Image(systemName: "minus.circle.fill")
                        .resizable()
                        .frame(width: 18, height: 18)
                })
                
                
            }
            .padding()
            .background(coloreCard.init(value: value).coloreDellaScheda)
            .cornerRadius(10)
//            .background(NavigationLink("", destination: EditOggettoView(oggetto: oggetto), isActive: $editEnable))
            .contextMenu(.init(menuItems: {

                    Text("Lunghezza: \(oggetto.lunghezza)")
                    Text("Larghezza: \(oggetto.larghezza)")
                    Text("Profondità: \(oggetto.profondita)")
                    Text("Volume: \(oggetto.volume)")
                    Text("Peso: \(oggetto.peso)")
                    
                    Button(action: {
                        editEnable = true
                    }, label: {
                        HStack {
                            Text("Edit")
                            Image(systemName: "pencil")
                        }
                    })
                
            }))
            
            
        }else{
            Text("Loading...")
                .foregroundColor(Color.red)
                .background(NavigationLink("", destination: EditOggettoView(oggetto: oggetto), isActive: $editEnable))
                
        }
        
        
    
    }
        
    
}

struct coloreCard{
    var coloreDellaScheda:Color = Color.init(Color.RGBColorSpace.sRGB, red: 240/255, green: 240/255, blue: 240/255, opacity: 1.0)
    
    
    init(value: Int){
        if(value > 0){
            coloreDellaScheda = Color.init(Color.RGBColorSpace.sRGB, red: 232/255, green: 243/255, blue: 255/255, opacity: 1.0)
        }
    }
    
}


//struct CardView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddTripView(viaggio: Viaggio.init(entity: .init(), insertInto: .init(coder: .init())))
//            .previewDevice("iPhone 11")
//    }
//}

