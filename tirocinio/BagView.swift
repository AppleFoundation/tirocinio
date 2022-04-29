//
//  BagView.swift
//  tirocinio
//
//  Created by Salvatore Apicella on 25/04/22.
//

import Foundation
import SwiftUI

struct BagView: View{
    var body: some View{
        
        
        NavigationView{
            GeometryReader { geo in
                let screenHeight = geo.frame(in: .global).height
                let screenWidth = geo.frame(in: .global).width
                if screenHeight < screenWidth {
                    //INIZIO LAYOUT ORIZZONTALE
                    
                    HStack{
                        VStack{
                            Text("Ciao In Orizzontale")
                                .font(.title)
                                .foregroundColor(Color.blue)
                        }
                    }
                    .frame(width: screenWidth, height: screenHeight)
                    
                    //FINE LAYOUT ORIZZONTALE
                } else {
                    //INIZIO LAYOUT VERTICALE
                    
                    VStack{
                        HStack{
                            Text("Ciao In Verticale")
                                .font(.title)
                                .foregroundColor(Color.blue)
                        }
                    }
                    .frame(width: screenWidth, height: screenHeight)
                    
                    //FINE LAYOUT VERTICALE
                }
            }
            .navigationTitle("Valigie")
            //.navigationBarHidden(true)
        }
        .navigationViewStyle(.stack)
        
        
    }
    
    
}

struct BagView_Previews: PreviewProvider {
    static var previews: some View {
        BagView()
    }
}
