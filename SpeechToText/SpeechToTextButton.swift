//
//  SpeechToTextButton.swift
//  tirocinio
//
//  Created by Grazia Ferrara on 12/06/22.
//

import SwiftUI

struct SpeechToTextButton: View {
    
    @EnvironmentObject var speech : SpeechToText
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
                    
                    let queueSpeech = DispatchQueue.init(label: "it.unisa.diem.tirocinio.queueSpeech", qos: .userInitiated)
                    queueSpeech.async {
                        
                        // testo acquisito
                        
                        if(input.decode(text: speech.text, viaggioNome: speech.viaggioNome)){
                            print("ok")
                        }else{
                            print("decodifica input non riuscita")
                        }
                        
                        DispatchQueue.main.async {
                            
                            // ritorno sul main dalla queue per aggiornare l'interfaccia
                            print("sono sull'interfaccia principale")
                            
                        }
                    }
                    
                }
            }
        }, label: {
            Image(systemName: "mic.fill")
                .resizable()
                .frame(width: 30, height: 40)
                .foregroundColor(.white)
                .background(speech.isRecording ? Circle().foregroundColor(.red).frame(width: 85, height: 85) : Circle().foregroundColor(.blue).frame(width: 70, height: 70))
        })
    }
    
}

//struct SpeechToTextButton_Previews: PreviewProvider {
//
//    static var previews: some View {
//        SpeechToTextButton()
//    }
//}
