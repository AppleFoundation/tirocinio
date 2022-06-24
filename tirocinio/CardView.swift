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
    
    @ObservedObject var oggetto: Oggetto
    var viaggio: Viaggio
    

    @State var count: Int = 0
    @State var value: Int
    let step = 1
    let range = 0...50
    
    
    
    var body: some View {
        

            HStack{
                
                if (value <= 0){
                    Spacer(minLength: 12)
                }
                
                Text("\(value)")
                    .font(.headline)
                    .multilineTextAlignment(.trailing)
                
                Button(action: {
                    count += 1
                    value += 1
                    PersistenceManager.shared.addOggettoViaggiante(oggetto: oggetto, viaggio: viaggio)
                }, label: {
                    Text(oggetto.nome ?? "Nome")
                    
                })
                .frame(minWidth: 130)
                
                Button(action: {
                    if(value > 0){
                        count -= 1
                        value -= 1
                        let ov: OggettoViaggiante  = PersistenceManager.shared.loadOggettiViaggiantiFromOggettoViaggio(oggettoRef: oggetto, viaggioRef: viaggio)[0]
                        ov.quantitaInViaggio -= 1
                        ov.quantitaAllocata -= 1
                        if ov.quantitaInViaggio == 0{
                            PersistenceManager.shared.deleteOggettoViaggiante(ogetto: oggetto, viaggio: viaggio)
                        }
                    }
                }, label: {
                    if (value > 0){
                        Image(systemName: "minus.circle.fill")
                        .resizable()
                        .frame(width: 18, height: 18)
                        
                    }else{
                        Spacer(minLength: 11)
                    }
                    
                    
                })
                
                
            }
            
            
            //            .onDisappear(){
            //
            //                if (count != 0){
            //                    if (count > 0){
            //                        for _ in 1...count{
            //                            PersistenceManager.shared.addOggettoViaggiante(oggetto: oggetto, viaggio: viaggio)
            //                        }
            //                    }else{
            //                        count = count - count - count
            //                        for _ in 1...count{
            //                            PersistenceManager.shared.deleteOggettoViaggiante(ogetto: oggetto, viaggio: viaggio)
            //                        }
            //                    }
            //                }
            //
            //
            //
            //            }

            .padding()
            .background(coloreScelto())
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.4), radius: 1, x: 1, y: 1)
            //            .background(NavigationLink("", destination: EditOggettoView(oggetto: oggetto), isActive: $editEnable))
            .contextMenu(.init(menuItems: {
                
                Text("Lunghezza: \(oggetto.lunghezza) cm")
                Text("Larghezza: \(oggetto.larghezza) cm")
                Text("Profondità: \(oggetto.profondita) cm")
                Text("Volume: \(String(format: "%.2f", Double(oggetto.volume)/1000)) l")
                Text("Peso: \(oggetto.peso) g")
                
                Button(action: {
                    editEnable = true
                }, label: {
                    HStack {
                        if (oggetto.nome!.contains(Character.init("★"))){
                            Text("Modifica")
                        }else{
                            Text("Clona e personalizza")
                        }
                        Image(systemName: "pencil")
                    }
                })
                
                Button(action: {
                    PersistenceManager.shared.deleteOggetto(nome: oggetto.nome!, categoria: oggetto.categoria!)
                    //                    print("ciao")
                }, label:{
                    HStack{
                        Text("Elimina")
                        Image(systemName: "trash.fill")
                        
                    }
                })
            }))
            .background(NavigationLink("", destination: EditOggettoView(nomeAgg: oggetto.nome ?? "Nome", lunghezzaAgg: Double(oggetto.lunghezza), larghezzaAgg: Double(oggetto.larghezza), profonditaAgg: Double(oggetto.profondita), pesoAgg: Double(oggetto.peso), oggetto: oggetto), isActive: $editEnable))
            
        
        
        
        
    }
    
    
    private func  coloreScelto() -> LinearGradient{
        
        
        var gradienteScheda: LinearGradient = LinearGradient(colors: [Color.white], startPoint: .topLeading, endPoint: .bottomTrailing)
        
        let inizio = UnitPoint.bottom
        let fine = UnitPoint.top
        
        if(String("\(colorScheme)") == "light"){
            if(value > 0){
                //Viola Light
                var coloreArray = Array<Color>.init()
                coloreArray.append(Color.init(Color.RGBColorSpace.sRGB, red: 116/255, green: 116/255, blue: 234/255, opacity: 1.0))
                coloreArray.append(Color.init(Color.RGBColorSpace.sRGB, red: 157/255, green: 156/255, blue: 240/255, opacity: 1.0))
                gradienteScheda = LinearGradient(colors: coloreArray, startPoint: inizio, endPoint: fine)
                
                //Gialla light
//                var coloreArray = Array<Color>.init()
//                coloreArray.append(Color.init(Color.RGBColorSpace.sRGB, red: 255/255, green: 204/255, blue: 24/255, opacity: 1.0))
//                coloreArray.append(Color.init(Color.RGBColorSpace.sRGB, red: 255/255, green: 229/255, blue: 138/255, opacity: 1.0))
//                gradienteScheda = LinearGradient(colors: coloreArray, startPoint: inizio, endPoint: fine)
            }else{
                var coloreArray = Array<Color>.init()
                coloreArray.append(Color.init(Color.RGBColorSpace.sRGB, red: 255/255, green: 255/255, blue: 255/255, opacity: 1.0))
                gradienteScheda = LinearGradient(colors: coloreArray, startPoint: inizio, endPoint: fine)
            }
        }else{
            if(value > 0){
                //Viola Dark
                var coloreArray = Array<Color>.init()
                coloreArray.append(Color.init(Color.RGBColorSpace.sRGB, red: 22/255, green: 0/255, blue: 55/255, opacity: 1.0))
                coloreArray.append(Color.init(Color.RGBColorSpace.sRGB, red: 52/255, green: 0/255, blue: 94/255, opacity: 1.0))
                gradienteScheda = LinearGradient(colors: coloreArray, startPoint: inizio, endPoint: fine)
                
                //Gialla Dark
//                var coloreArray = Array<Color>.init()
//                coloreArray.append(Color.init(Color.RGBColorSpace.sRGB, red: 64/255, green: 3/255, blue: 0/255, opacity: 1.0))
//                coloreArray.append(Color.init(Color.RGBColorSpace.sRGB, red: 105/255, green: 57/255, blue: 0/255, opacity: 1.0))
//                gradienteScheda = LinearGradient(colors: coloreArray, startPoint: inizio, endPoint: fine)
            }else{
                var coloreArray = Array<Color>.init()
                coloreArray.append(Color.init(Color.RGBColorSpace.sRGB, red: 45/255, green: 45/255, blue: 45/255, opacity: 1.0))
                gradienteScheda = LinearGradient(colors: coloreArray, startPoint: inizio, endPoint: fine)
            }
        }
        
        
        return gradienteScheda
        
    }
    
    
}



//struct CardView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddTripView(viaggio: Viaggio.init(entity: .init(), insertInto: .init(coder: .init())))
//            .previewDevice("iPhone 11")
//    }
//}

