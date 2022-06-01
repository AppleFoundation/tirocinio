//
//  CardView.swift
//  ValigieSmart
//
//  Created by Salvatore Apicella on 25/04/22.
//

import SwiftUI
import SceneKit

struct CardView: View {
    
    
    var oggetto: Oggetto
    var viaggio: Viaggio
    
    @State var value: Int
        let step = 1
        let range = 0...50
    
    
    var body: some View {
        
        ZStack{
            
            if value != 0 {
                Rectangle()
                    .opacity(0.15)
                    .cornerRadius(10)
                    .shadow(radius: 10)
            }else{
                Rectangle()
                    .opacity(0.05)
                    .cornerRadius(10)
                    .shadow(radius: 10)
            }
            VStack {
                Text(oggetto.nome ?? "Nome")
                Image("\(oggetto.nome ?? "Base")")
                    .resizable()
                    .frame(width: 40, height: 40, alignment: .center)
                    .padding(-10)
                    
                HStack{
                   
                    Image(systemName: "info.circle.fill")
                    
//                    HStack {
//                                Spacer()
//                                    Stepper("", value: $value, in: 0...50, step: 1)
//                                    .frame(width: 100, height: 50)
//
//                                Spacer()
//                            }
                    HStack {
                                Spacer()
                        
                        Stepper(label: {
                            Text("")
                        }, onIncrement: {
                            value += 1
                            PersistenceManager.shared.addOggettoViaggiante(oggetto: oggetto, viaggio: viaggio)
                        }, onDecrement: {
                            if (value > 0){
                                value -= 1
                                PersistenceManager.shared.deleteOggettoViaggiante(ogetto: oggetto, viaggio: viaggio)
                            }
                        })
                                    .frame(width: 100, height: 50)
                                    
                                Spacer()
                            }
                        
                    Spacer()
                    Text("\(value)")
                    
                }
                
            }
            .padding([.top, .leading, .trailing])
            .frame(width: 180)
            .cornerRadius(10)
            
        }
    }
}
    
    

//struct CardView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddTripView()
//            .previewDevice("iPhone 11")
//    }
//}

