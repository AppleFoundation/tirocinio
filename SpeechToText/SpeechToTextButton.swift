//
//  SpeechToTextButton.swift
//  tirocinio
//
//  Created by Grazia Ferrara on 12/06/22.
//

import SwiftUI

struct SpeechToTextButton: View {
    
    @EnvironmentObject var speech : SpeechToText
    @Environment(\.colorScheme) var colorScheme
    @State private var message = ""
    
    var input = DecodeInput()
    
    var body: some View {
        Button(action: {
            if(self.speech.getSpeechStatus() == "Denied - Close the App"){
                
                // show popup error
                
            }else{
                withAnimation(.spring(response: 0.4, dampingFraction: 0.3, blendDuration: 0.3)){
                    self.speech.isRecording.toggle()
                }
                if(self.speech.isRecording){
                    self.speech.startRecording()
                }else{
                    self.speech.stopRecording()
                    
                    if(input.decode(text: speech.text, viaggioNome: speech.viaggioNome)){
                        print("ok")
                    }else{
                        print("decodifica input non riuscita")
                    }
                    
                    
//                    let queueSpeech = DispatchQueue.init(label: "it.unisa.diem.tirocinio.queueSpeech", qos: .userInitiated)
//                    queueSpeech.async {
//
//                        // testo acquisito
//
//                        if(input.decode(text: speech.text, viaggioNome: speech.viaggioNome)){
//                            print("ok")
//                        }else{
//                            print("decodifica input non riuscita")
//                        }
//
//                        DispatchQueue.main.async {
//
//                            // ritorno sul main dalla queue per aggiornare l'interfaccia
//                            print("sono sull'interfaccia principale")
//
//                        }
//                    }
                    
                }
            }
        }, label: {
            Image(systemName: "mic.fill")
                .resizable()
                .frame(width: 30, height: 40)
                .foregroundColor(speech.isRecording ? .white : .blue)
                .background(speech.isRecording ?
                            Circle()
                    .foregroundColor(.red)
                    .frame(width: 90, height: 90)
                    .shadow(color: Color.black.opacity(0.5), radius: 5, y: 5)
                            : Circle()
                    .foregroundColor(colorScheme == .dark ? Color.init(white: 0.1764705882) : Color.white)
                    .frame(width: 80, height: 80)
                    .shadow(color: Color.black.opacity(0.5), radius: 5, y: 5)
                )
            
//                .background(colorScheme == .dark ? Color.init(white: 0.1) : Color.init(white: 1.0))
                
        })
    }
    
}

//struct SpeechToTextButton_Previews: PreviewProvider {
//
//    static var previews: some View {
//        SpeechToTextButton()
//    }
//}
