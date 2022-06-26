//
//  ValigiaRiempitaCardView.swift
//  tirocinio
//
//  Created by Salvatore Apicella on 26/06/22.
//

import SwiftUI

struct ValigiaRiempitaCardView: View{
    
    @Environment(\.colorScheme) var colorScheme
    
    @ObservedObject var singolaIstanza: ValigiaViaggiante
    
    @State var visualizzaOggetti: Bool = false
    
    var viaggio: Viaggio
    
    var body: some View{
        
        if(singolaIstanza.contenuto.array(of: OggettoInValigia.self).isEmpty == false){
            
            Spacer()
            
            VStack{
                Button(action: {
                    visualizzaOggetti.toggle()
                }){
                    HStack{
                        HStack{
                            if (visualizzaOggetti){
                                Image(systemName: "arrowtriangle.down.fill")
                            }else{
                                Image(systemName: "arrowtriangle.forward.fill")
                            }
                            Text("\((singolaIstanza.valigiaRef?.nome)!)")
                                .font(.title)
                                .fontWeight(.bold)
                        }
                        
                        Spacer()
                        VStack(alignment: .trailing){
                            //la card ha una visualizzazione distinta nel caso di valigia di sistema. non mostra i valori massimo poiché è solo una valigia logica
                            if singolaIstanza.valigiaRef?.categoria == "0SYSTEM"{
                                Text("Ingombro: \(singolaIstanza.volumeAttuale)ml")
                                    .font(.caption)
                                Text("Peso: \(singolaIstanza.pesoAttuale)g")
                                    .font(.caption)
                            }else{
                                Text("Ingombro: \(singolaIstanza.volumeAttuale)ml di \(singolaIstanza.valigiaRef!.volume)ml")
                                    .font(.caption)
                                if(singolaIstanza.pesoMassimo < Int32.max){
                                    Text("Peso: \(singolaIstanza.pesoAttuale)g di \(singolaIstanza.pesoMassimo)g")
                                        .font(.caption)
                                }else{
                                    Text("Peso: \(singolaIstanza.pesoAttuale)g di ∞")
                                        .font(.caption)
                                }
                            }
                        }
                    }
                    .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                    
                }
                .padding(.bottom)
                
                if (visualizzaOggetti){
                    ForEach(singolaIstanza.contenuto.array(of: OggettoInValigia.self).sorted(by: { rhs, lhs in
                        return rhs.oggettoViaggianteRef!.oggettoRef!.nome! < lhs.oggettoViaggianteRef!.oggettoRef!.nome!
                    })){
                        oggetto in
                        
                        HStack{
                            
                            Text("\(oggetto.quantitaInValigia)")
                            Text(oggetto.oggettoViaggianteRef?.oggettoRef?.nome ?? "Nome non trovato")
                            Spacer()
                            Text("\(oggetto.oggettoViaggianteRef?.oggettoRef?.volume.description ?? "0")ml • \(oggetto.quantitaInValigia) = \(oggetto.quantitaInValigia * (oggetto.oggettoViaggianteRef?.oggettoRef?.volume ?? 0))ml\n\(oggetto.oggettoViaggianteRef?.oggettoRef?.peso.description ?? "0")g • \(oggetto.quantitaInValigia) = \(oggetto.quantitaInValigia * (oggetto.oggettoViaggianteRef?.oggettoRef?.peso ?? 0))g")
                                .font(.caption2)
                                .multilineTextAlignment(.trailing)
                            
                        }
                        .padding(8)
                        .background(colorScheme == .dark ? Color.init(white: 0.1,opacity: 0.4) : Color.init(white: 0.9,opacity: 0.4))
                        .cornerRadius(10)
                        
                        
                    }
                }
                Spacer()
            }
            .padding()
            .background(coloreScelto(valigia: singolaIstanza, volumeOPeso: viaggio.allocaPer))
            .cornerRadius(10)
            
        }
        
    }
    
    private func  coloreScelto(valigia: ValigiaViaggiante, volumeOPeso: Bool) -> LinearGradient{
        
        var gradienteScheda: LinearGradient = LinearGradient(colors: [Color.white], startPoint: .topLeading, endPoint: .bottomTrailing)
        
        let inizio = UnitPoint.bottom
        let fine = UnitPoint.top
        
        if (volumeOPeso == false){ //Caso di ordinare per volume
            if(String("\(colorScheme)") == "light"){
                if(valigia.volumeAttuale > valigia.valigiaRef!.volume){
                    //Rossa light
                    var coloreArray = Array<Color>.init()
                    coloreArray.append(Color.init(Color.RGBColorSpace.sRGB, red: 208/255, green: 24/255, blue: 24/255, opacity: 1.0))
                    coloreArray.append(Color.init(Color.RGBColorSpace.sRGB, red: 212/255, green: 105/255, blue: 105/255, opacity: 1.0))
                    gradienteScheda = LinearGradient(colors: coloreArray, startPoint: inizio, endPoint: fine)
                }else if(Double(valigia.volumeAttuale) > Double(valigia.valigiaRef!.volume) * 0.9){
                    //Gialla light
                    var coloreArray = Array<Color>.init()
                    coloreArray.append(Color.init(Color.RGBColorSpace.sRGB, red: 255/255, green: 204/255, blue: 24/255, opacity: 1.0))
                    coloreArray.append(Color.init(Color.RGBColorSpace.sRGB, red: 255/255, green: 229/255, blue: 138/255, opacity: 1.0))
                    gradienteScheda = LinearGradient(colors: coloreArray, startPoint: inizio, endPoint: fine)
                }else{
                    //Verde light
                    var coloreArray = Array<Color>.init()
                    coloreArray.append(Color.init(Color.RGBColorSpace.sRGB, red: 67/255, green: 198/255, blue: 33/255, opacity: 1.0))
                    coloreArray.append(Color.init(Color.RGBColorSpace.sRGB, red: 120/255, green: 195/255, blue: 120/255, opacity: 1.0))
                    gradienteScheda = LinearGradient(colors: coloreArray, startPoint: inizio, endPoint: fine)
                }
            }else{
                if(valigia.volumeAttuale > valigia.valigiaRef!.volume){
                    //Rossa dark
                    var coloreArray = Array<Color>.init()
                    coloreArray.append(Color.init(Color.RGBColorSpace.sRGB, red: 119/255, green: 17/255, blue: 17/255, opacity: 1.0))
                    coloreArray.append(Color.init(Color.RGBColorSpace.sRGB, red: 161/255, green: 22/255, blue: 22/255, opacity: 1.0))
                    gradienteScheda = LinearGradient(colors: coloreArray, startPoint: inizio, endPoint: fine)
                }else if(Double(valigia.volumeAttuale) > Double(valigia.valigiaRef!.volume) * 0.9){
                    //Gialla dark
                    var coloreArray = Array<Color>.init()
                    //                coloreArray.append(Color.init(Color.RGBColorSpace.sRGB, red: 237/255, green: 185/255, blue: 51/255, opacity: 1.0))
                    //                coloreArray.append(Color.init(Color.RGBColorSpace.sRGB, red: 207/255, green: 174/255, blue: 105/255, opacity: 1.0))
                    
                    coloreArray.append(Color.init(Color.RGBColorSpace.sRGB, red: 154/255, green: 93/255, blue: 0/255, opacity: 1.0))
                    coloreArray.append(Color.init(Color.RGBColorSpace.sRGB, red: 245/255, green: 197/255, blue: 0/255, opacity: 1.0))
                    gradienteScheda = LinearGradient(colors: coloreArray, startPoint: inizio, endPoint: fine)
                }else{
                    //Verde dark
                    var coloreArray = Array<Color>.init()
                    coloreArray.append(Color.init(Color.RGBColorSpace.sRGB, red: 27/255, green: 91/255, blue: 15/255, opacity: 1.0))
                    coloreArray.append(Color.init(Color.RGBColorSpace.sRGB, red: 93/255, green: 143/255, blue: 77/255, opacity: 1.0))
                    gradienteScheda = LinearGradient(colors: coloreArray, startPoint: inizio, endPoint: fine)
                }
            }
        }else{ //Caso di ordinare per peso
            if(String("\(colorScheme)") == "light"){
                if(valigia.pesoAttuale > valigia.pesoMassimo || valigia.volumeAttuale > valigia.valigiaRef!.volume){
                    //Rossa light
                    var coloreArray = Array<Color>.init()
                    coloreArray.append(Color.init(Color.RGBColorSpace.sRGB, red: 208/255, green: 24/255, blue: 24/255, opacity: 1.0))
                    coloreArray.append(Color.init(Color.RGBColorSpace.sRGB, red: 212/255, green: 105/255, blue: 105/255, opacity: 1.0))
                    gradienteScheda = LinearGradient(colors: coloreArray, startPoint: inizio, endPoint: fine)
                }else if(Double(valigia.pesoAttuale) > Double(valigia.pesoMassimo) * 0.9 || Double(valigia.volumeAttuale) > Double(valigia.valigiaRef!.volume) * 0.9){
                    //Gialla light
                    var coloreArray = Array<Color>.init()
                    coloreArray.append(Color.init(Color.RGBColorSpace.sRGB, red: 255/255, green: 204/255, blue: 24/255, opacity: 1.0))
                    coloreArray.append(Color.init(Color.RGBColorSpace.sRGB, red: 255/255, green: 229/255, blue: 138/255, opacity: 1.0))
                    gradienteScheda = LinearGradient(colors: coloreArray, startPoint: inizio, endPoint: fine)
                }else{
                    //Verde light
                    var coloreArray = Array<Color>.init()
                    coloreArray.append(Color.init(Color.RGBColorSpace.sRGB, red: 67/255, green: 198/255, blue: 33/255, opacity: 1.0))
                    coloreArray.append(Color.init(Color.RGBColorSpace.sRGB, red: 120/255, green: 195/255, blue: 120/255, opacity: 1.0))
                    gradienteScheda = LinearGradient(colors: coloreArray, startPoint: inizio, endPoint: fine)
                }
            }else{
                if(valigia.pesoAttuale > valigia.pesoMassimo || valigia.volumeAttuale > valigia.valigiaRef!.volume){
                    //Rossa dark
                    var coloreArray = Array<Color>.init()
                    coloreArray.append(Color.init(Color.RGBColorSpace.sRGB, red: 119/255, green: 17/255, blue: 17/255, opacity: 1.0))
                    coloreArray.append(Color.init(Color.RGBColorSpace.sRGB, red: 161/255, green: 22/255, blue: 22/255, opacity: 1.0))
                    gradienteScheda = LinearGradient(colors: coloreArray, startPoint: inizio, endPoint: fine)
                }else if(Double(valigia.pesoAttuale) > Double(valigia.pesoMassimo) * 0.9 || Double(valigia.volumeAttuale) > Double(valigia.valigiaRef!.volume) * 0.9){
                    //Gialla dark
                    var coloreArray = Array<Color>.init()
                    //                coloreArray.append(Color.init(Color.RGBColorSpace.sRGB, red: 237/255, green: 185/255, blue: 51/255, opacity: 1.0))
                    //                coloreArray.append(Color.init(Color.RGBColorSpace.sRGB, red: 207/255, green: 174/255, blue: 105/255, opacity: 1.0))
                    
                    coloreArray.append(Color.init(Color.RGBColorSpace.sRGB, red: 154/255, green: 93/255, blue: 0/255, opacity: 1.0))
                    coloreArray.append(Color.init(Color.RGBColorSpace.sRGB, red: 245/255, green: 197/255, blue: 0/255, opacity: 1.0))
                    gradienteScheda = LinearGradient(colors: coloreArray, startPoint: inizio, endPoint: fine)
                }else{
                    //Verde dark
                    var coloreArray = Array<Color>.init()
                    coloreArray.append(Color.init(Color.RGBColorSpace.sRGB, red: 27/255, green: 91/255, blue: 15/255, opacity: 1.0))
                    coloreArray.append(Color.init(Color.RGBColorSpace.sRGB, red: 93/255, green: 143/255, blue: 77/255, opacity: 1.0))
                    gradienteScheda = LinearGradient(colors: coloreArray, startPoint: inizio, endPoint: fine)
                }
            }
        }
        
        
        
        
        return gradienteScheda
        
    }
}

