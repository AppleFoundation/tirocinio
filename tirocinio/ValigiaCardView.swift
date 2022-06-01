//
//  ValigiaCardView.swift
//  tirocinio
//
//  Created by Salvatore Apicella on 31/05/22.
//

import SwiftUI
import SceneKit

struct ValigiaCardView: View {
    
    
    var valigia: Valigia
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
                Text(valigia.nome ?? "Nome")
                Image("\(valigia.nome ?? "Base")")
                    .resizable()
                    .frame(width: 40, height: 40, alignment: .center)
                    .padding(-10)
                    
                HStack{
                   
                    Image(systemName: "info.circle.fill")
                    
                    HStack {
                                Spacer()
                        
                        Stepper(label: {
                            Text("")
                        }, onIncrement: {
                            value += 1
                            PersistenceManager.shared.addValigiaViaggiante(valigia: valigia, viaggio: viaggio)
                        }, onDecrement: {
                            if (value > 0){
                                value -= 1
                                PersistenceManager.shared.deleteValigiaViaggiante(viaggio: viaggio, valigia: valigia)
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
    

//struct ValigiaCardView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddBagView()
//            .previewDevice("iPhone 11")
//    }
//}

