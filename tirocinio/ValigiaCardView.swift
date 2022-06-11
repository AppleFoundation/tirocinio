//
//  ValigiaCardView.swift
//  tirocinio
//
//  Created by Salvatore Apicella on 31/05/22.
//

import SwiftUI
import SceneKit

struct ValigiaCardView: View {
    
    var valigia: Valigia
    var viaggio: Viaggio
    
    @State var count: Int = 0
    
    @State var value: Int = 0
    
    var body: some View {
        
            VStack {
                Text(valigia.nome ?? "Nome")
                HStack{
                        Stepper(label: {
                            Text("")
                        }, onIncrement: {
                            count += 1
                            value += 1
                            PersistenceManager.shared.addValigiaViaggiante(valigia: valigia, viaggio: viaggio)
                        }, onDecrement: {
                            if (value > 0){
                                count -= 1
                                value -= 1
                                PersistenceManager.shared.deleteValigiaViaggiante(viaggio: viaggio, valigia: valigia)
                            }
                        })
                    Text("\(value)")
                }
            }
//            .onDisappear(){
//                if (count != 0){
//                    if (count > 0){
//                        for _ in 1...count{
//                            PersistenceManager.shared.addValigiaViaggiante(valigia: valigia, viaggio: viaggio)
//                        }
//                    }else{
//                        count = count - count - count
//                        for _ in 1...count{
//                            PersistenceManager.shared.deleteValigiaViaggiante(viaggio: viaggio, valigia: valigia)
//                        }
//                    }
//                }
//               
//            }
            .onAppear(){
                value = PersistenceManager.shared.loadValigieViaggiantiFromViaggioValigia(viaggio: viaggio, valigia: valigia).count
            }
    }
        
}
