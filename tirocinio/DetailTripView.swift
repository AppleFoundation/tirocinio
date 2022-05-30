//
//  DetailTripView.swift
//  ValigieSmart
//
//  Created by Salvatore Apicella on 25/04/22.
//

import SwiftUI

struct DetailTripView: View {
    var body: some View {
        
        VStack{
            Text("Non sembrano esserci oggetti per il tuo viaggio")
            
            NavigationLink(destination: AddTripView()){
                Text("Aggiungi Oggetti")
            }
        }
        
        
       
        .navigationTitle("Dettagli Viaggio")
    }
}

struct DetailTripView_Previews: PreviewProvider {
    static var previews: some View {
        DetailTripView()
            .previewDevice("iPhone 11")
    }
}
