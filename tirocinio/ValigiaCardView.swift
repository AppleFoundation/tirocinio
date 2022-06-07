////
////  ValigiaCardView.swift
////  tirocinio
////
////  Created by Salvatore Apicella on 31/05/22.
////
//
//import SwiftUI
//import SceneKit
//
//struct ValigiaCardView: View {
//
//
//    var valigia: Valigia
//    var viaggio: Viaggio
//
//    @State var value: Int = 0
//    let step = 1
//    let range = 0...50
//
//    var body: some View {
//
//        ZStack{
//
//            if value != 0 {
//                Rectangle()
//                    .opacity(0.15)
//                    .cornerRadius(10)
//                    .shadow(radius: 10)
//            }else{
//                Rectangle()
//                    .opacity(0.05)
//                    .cornerRadius(10)
//                    .shadow(radius: 10)
//            }
//            VStack {
//                Text(valigia.nome ?? "Nome")
//                Image("\(valigia.nome ?? "Base")")
//                    .resizable()
//                    .frame(width: 40, height: 40, alignment: .center)
//                    .padding(-10)
//
//                HStack{
//
//                    Image(systemName: "info.circle.fill")
//
//                    HStack {
//                        Spacer()
//
//                        Stepper(label: {
//                            Text("")
//                        }, onIncrement: {
//                            value += 1
//                            PersistenceManager.shared.addValigiaViaggiante(valigia: valigia, viaggio: viaggio)
//                        }, onDecrement: {
//                            if (value > 0){
//                                value -= 1
//                                PersistenceManager.shared.deleteValigiaViaggiante(viaggio: viaggio, valigia: valigia)
//                            }
//                        })
//                        .frame(width: 100, height: 50)
//
//                        Spacer()
//                    }
//
//                    Spacer()
//                    Text("\(value)")
//
//                }
//
//            }
//            .padding([.top, .leading, .trailing])
//            .frame(width: 180)
//            .cornerRadius(10)
//        }
//
//
//    }
//
//}



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
                        }, onDecrement: {
                            if (value > 0){
                                count -= 1
                                value -= 1
                            }
                        })
                    Text("\(value)")
                }
            }
            .onDisappear(){
                if (count != 0){
                    if (count > 0){
                        for _ in 1...count{
                            PersistenceManager.shared.addValigiaViaggiante(valigia: valigia, viaggio: viaggio)
                        }
                    }else{
                        count = count - count - count
                        for _ in 1...count{
                            PersistenceManager.shared.deleteValigiaViaggiante(viaggio: viaggio, valigia: valigia)
                        }
                    }
                }
               
            }
            .onAppear(){
                value = PersistenceManager.shared.loadValigieViaggiantiFromViaggioValigia(viaggio: viaggio, valigia: valigia).count
            }
    }
        
}
