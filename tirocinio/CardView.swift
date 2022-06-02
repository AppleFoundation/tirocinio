//
//  CardView.swift
//  ValigieSmart
//
//  Created by Salvatore Apicella on 25/04/22.
//

import SwiftUI
import SceneKit

struct CardView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    
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
                    .font(.headline)
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
            .background(coloreScelto())
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.4), radius: 1, x: 1, y: 1)
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
                
                Button(action: {
                    PersistenceManager.shared.deleteOggetto(nome: oggetto.nome!, categoria: oggetto.categoria!)
                    print("ciao")
                }, label:{
                    HStack{
                        Text("Elimina")
                        Image(systemName: "trash.fill")
                        
                    }
                })
                
                
                
                
                
                
                
            }))
            
            
        }else{
            Text("Loading...")
                .foregroundColor(Color.red)
                .background(NavigationLink("", destination: EditOggettoView(nomeAgg: oggetto.nome!, lunghezzaAgg: Double(oggetto.lunghezza), larghezzaAgg: Double(oggetto.larghezza), profonditaAgg: Double(oggetto.profondita), pesoAgg: Double(oggetto.peso), oggetto: oggetto), isActive: $editEnable))
                
        }
        
        
    
    }
    
    private func  coloreScelto() -> Color{
        
        
        

        
        var coloreDellaScheda: Color
        
        if(String("\(colorScheme)") == "light"){
            if(value > 0){
                coloreDellaScheda = Color.init(Color.RGBColorSpace.sRGB, red: 192/255, green: 237/255, blue: 166/255, opacity: 1.0)
            }else{
                coloreDellaScheda = Color.init(Color.RGBColorSpace.sRGB, red: 240/255, green: 240/255, blue: 240/255, opacity: 1.0)
            }
        }else if(colorScheme == ColorScheme.dark){
            if(value > 0){
                coloreDellaScheda = Color.init(Color.RGBColorSpace.sRGB, red: 30/255, green: 81/255, blue: 40/255, opacity: 1.0)
            }else{
                coloreDellaScheda = Color.init(Color.RGBColorSpace.sRGB, red: 45/255, green: 45/255, blue: 45/255, opacity: 1.0)
                
            }
        }else{
            coloreDellaScheda = Color.white
        }
        

        
        return coloreDellaScheda
        
    }
    
    
}



//struct CardView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddTripView(viaggio: Viaggio.init(entity: .init(), insertInto: .init(coder: .init())))
//            .previewDevice("iPhone 11")
//    }
//}

