//
//  BagListScroll.swift
//  ValigieSmart
//
//  Created by Salvatore Apicella on 25/04/22.
//

import SwiftUI

struct BagListScroll: View {
    var body: some View {
        
        VStack{
            Text("Le mie valigie")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color.blue)
            
            HStack{
                
                
                Image(systemName: "bag")
                    .resizable()
                    .frame(width: 45, height: 45)
                Image(systemName: "bag")
                    .resizable()
                    .frame(width: 45, height: 45)
                Image(systemName: "bag")
                    .resizable()
                    .frame(width: 45, height: 45)
                
                
                
                NavigationLink(destination: EmptyView(), label: {
                    VStack{
                        Image(systemName: "plus.circle")
                            .resizable()
                            .frame(width: 45, height: 45)
                        Text("Nuova Valigia")
                    }
                })
                .padding(.horizontal)
            }
            
            
        }
        
        
        
    }
}

struct BagListScroll_Previews: PreviewProvider {
    static var previews: some View {
        BagListScroll()
    }
}

