//
//  TripListScroll.swift
//  ValigieSmart
//
//  Created by Salvatore Apicella on 25/04/22.
//

import SwiftUI

struct TripListScroll: View {
    var body: some View {
        
        VStack{
            Text("I miei viaggi")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color.blue)
            
            
            
            Image(systemName: "airplane")
                .resizable()
                .frame(width: 45, height: 45)
            Image(systemName: "airplane")
                .resizable()
                .frame(width: 45, height: 45)
            Image(systemName: "airplane")
                .resizable()
                .frame(width: 45, height: 45)
            
            Spacer()
            
            HStack{
                
                Spacer()
                
                NavigationLink(destination: EmptyView(), label: {
                    VStack{
                        Image(systemName: "plus.circle")
                            .resizable()
                            .frame(width: 45, height: 45)
                        Text("Nuovo viaggio")
                    }
                })
            }
            
            
            
            
            
            
        }
        
    }
}

struct TripListScroll_Previews: PreviewProvider {
    static var previews: some View {
        TripListScroll()
    }
}
