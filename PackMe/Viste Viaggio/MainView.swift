//
//  MainView.swift
//  tirocinio
//
//  Created by Salvatore Apicella on 26/06/22.
//

import SwiftUI

struct MainView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @FetchRequest<Viaggio>(entity: Viaggio.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Viaggio.data, ascending: true)]) var allViaggi: FetchedResults<Viaggio>
    
    let columns = Array(repeating: GridItem.init(.fixed(175), spacing: 20, alignment: .center), count: 2)
    
    var body: some View {
        ScrollView{
            VStack{
                
                HStack{
                    
                    NavigationLink(destination: CreaViaggioView()){
                        
                        Text("Crea viaggio")
                            .font(.headline.bold())
                        Image(systemName: "plus")
                    }
                    .padding()
                    .background({ () -> Color in
                        if (colorScheme == .dark){
                            return Color.init(white: 0.2)
                        }else{
                            return Color.white
                        }
                    }())
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(color: Color.black.opacity(0.2), radius: 10, y: 5)
                    
                    
                }
                .padding()
                
                VStack{
                    LazyVGrid(columns: columns, alignment: .center) {
                        
                        ForEach(allViaggi){
                            viaggio in
                            
                            ViaggioCardView(viaggio: viaggio)
                            
                        }
                        
                    }
                    
                }
                
                
            }
            
        }
        .background{
            if(colorScheme == .light){
                Image("Sfondo App 1Light")
                    .resizable()
                    .ignoresSafeArea()
            }else{
                Image("Sfondo App 1Dark")
                    .resizable()
                    .ignoresSafeArea()
            }
            
        }
    }
}
