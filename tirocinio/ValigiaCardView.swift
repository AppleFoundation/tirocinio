//
//  ValigiaCardView.swift
//  tirocinio
//
//  Created by Salvatore Apicella on 31/05/22.
//

import SwiftUI
import SceneKit

struct ValigiaCardView: View {
    
    @State private var editEnable = false
    @Environment(\.colorScheme) var colorScheme
    
    @ObservedObject var valigia: Valigia
    @ObservedObject var viaggio: Viaggio
    @State var pesoMassimo: Double = 0
    @State var inserito = false
    
    @State var count: Int = 0
    @State var value: Int = 0
    
    
    var body: some View {
        VStack{
            VStack{
                HStack{
                    VStack(alignment: .leading){
                        Text(valigia.nome ?? "Nome")
                            .font(.title.bold())
                        Text(valigia.categoria ?? "Categoria")
                            .font(.headline)
                    }
                    Spacer()
                    VStack{
                        HStack{
                            Text("Quantità: \($value.wrappedValue)")
                                .font(.headline.bold())
                            
                            Button(action: {
                                if(value > 0){
                                    value -= 1
                                    count -= 1
                                    PersistenceManager.shared.deleteValigiaViaggiante(viaggio: viaggio, valigia: valigia)
                                }
                                
                            }, label: {
                                Image(systemName: "minus.circle.fill")
                                    .resizable()
                                    .frame(width: 25, height: 25, alignment: .center)
                            })
                            Button(action: {
                                value += 1
                                count += 1
                                PersistenceManager.shared.addValigiaViaggiante(valigia: valigia, viaggio: viaggio, pesoMassimo: Int(pesoMassimo)*1000)
                            }, label: {
                                Image(systemName: "plus.circle.fill")
                                    .resizable()
                                    .frame(width: 25, height: 25, alignment: .center)
                            })
                        }
                    }
                }
                HStack{
                    VStack(alignment: .leading){
                        Text("\(valigia.lunghezza)x\(valigia.larghezza)x\(valigia.profondita)")
                            .foregroundColor(.blue)
                        Text("Volume: \(String(format: "%.1f", Double(valigia.volume)/1000))l")
                            .foregroundColor(.purple)
                        Text("Tara: \(String(format: "%.1f", Double(valigia.tara)/1000))Kg")
                            .foregroundColor(.green)
                    }
                    Spacer()
                    VStack{
                        Image(systemName: "bag.fill")
                            .resizable()
                            .frame(width: 100, height: 100, alignment: .center)
                    }
                    Spacer()
                }
            }
            .padding()
            .background(colorScheme == .dark ? Color.init(white: 0.2) : Color.init(white: 0.9))
            
            .contextMenu(.init(menuItems: {
                
                //            Text("Lunghezza: \(valigia.lunghezza) cm")
                //            Text("Larghezza: \(oggetto.larghezza) cm")
                //            Text("Profondità: \(oggetto.profondita) cm")
                //            Text("Volume: \(String(format: "%.2f", Double(oggetto.volume)/1000)) l")
                //            Text("Peso: \(oggetto.peso) g")
                
                Button(action: {
                    editEnable = true
                }, label: {
                    HStack {
                        Text("Edit")
                        Image(systemName: "pencil")
                    }
                })
                
                Button(action: {
                    PersistenceManager.shared.deleteValigia(nome: valigia.nome!, categoria: valigia.categoria!)
                    
                }, label:{
                    HStack{
                        Text("Elimina")
                        Image(systemName: "trash.fill")
                        
                    }
                })
            }))
            
            HStack{
                VStack{
                    Text("Peso max: \(String(format: "%.1f", pesoMassimo))Kg")
                        .foregroundColor(.red)
                }
                VStack{
                    //                    Slider(value: $pesoMassimo, in: 0...30, step: 1.0)
                    Slider(value: $pesoMassimo, in: 0...30, step: 1.0, onEditingChanged: {_ in
                        PersistenceManager.shared.aggiornaPesoMassimoValigieViaggianti(valigia: valigia, viaggio: viaggio, pesoMassimo: Int(pesoMassimo)*1000)
                    })
                }
                
            }
            .padding(.init(top: 0, leading: 15, bottom: 15, trailing: 15))
            
            
        }
        .background(NavigationLink("", destination: EditValigiaView(nomeAgg: valigia.nome!, lunghezzaAgg: Double(valigia.lunghezza), larghezzaAgg: Double(valigia.larghezza), profonditaAgg: Double(valigia.profondita), pesoAgg: Double(valigia.tara), valigia: valigia), isActive: $editEnable))
        
        .onAppear(){
            inserito = valigia.utilizzato
            let valigiaViaggiante = PersistenceManager.shared.loadValigieViaggiantiFromViaggioValigia(viaggio: viaggio, valigia: valigia)
            if(!valigiaViaggiante.isEmpty){
                pesoMassimo = Double(valigiaViaggiante[0].pesoMassimo)/1000
            }
            value = PersistenceManager.shared.loadValigieViaggiantiFromViaggioValigia(viaggio: viaggio, valigia: valigia).count
        }
        
        //        .padding()
        .background(colorScheme == .dark ? Color.init(white: 0.1) : Color.init(white: 0.8))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.4), radius: 1, x: 1, y: 1)
        
    }
    
}

