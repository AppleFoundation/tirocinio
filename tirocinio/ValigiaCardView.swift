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
    
    @State var value = 0
        let step = 1
        let range = 0...50
    
    var body: some View {
        
        ZStack{
            
            if value != 0 {
                Rectangle()
                    .opacity(0.2)
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
                
                Spacer()
                
                Image("\(valigia.nome ?? "Base")")
                    .resizable()
                    .frame(width: 75, height: 75, alignment: .center)
                    
                
                

                Spacer()
                    
                HStack{
                   
                    Image(systemName: "info.circle.fill")
                    
                    HStack {
                                Spacer()
                                    Stepper("", value: $value, in: 0...50, step: 1)
                                    .frame(width: 100, height: 50)
                                Spacer()
                            }
                        
                    Spacer()
                    Text("\(value)")
                    
                }
                
            }
            .padding([.top, .leading, .trailing])
            .cornerRadius(10)
        }
        
        
    }
    
}
    

struct ValigiaCardView_Previews: PreviewProvider {
    static var previews: some View {
        AddBagView()
            .previewDevice("iPhone 11")
    }
}

