//
//  CardView.swift
//  ValigieSmart
//
//  Created by Salvatore Apicella on 25/04/22.
//

import SwiftUI
import SceneKit

struct CardView: View {
    
    var nome: String
    
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
               Text(nome)
                
                Spacer()
                
                Image("t-shirt")
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

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        AddTripView()
    }
}
