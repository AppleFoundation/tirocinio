//
//  SettingsView.swift
//  tirocinio
//
//  Created by Cristian Cerasuolo on 22/06/22.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.colorScheme) var colorScheme
    @State var showAlertOggettiPersonalizzati: Bool = false
    @State var showAlertReset: Bool = false
    @State var showAlertViaggi: Bool = false
    @State var selected: String = "none"
    @Binding var myColorScheme: ColorScheme?
    

    
    var body: some View {
        Form{
            Section("Panic buttons"){
                Button(action: {
                    showAlertOggettiPersonalizzati.toggle()
                }, label: {
                    Text("Rimuovi elementi personalizzati").foregroundColor(.red)
                })
                Button(action: {
                    showAlertReset.toggle()
                }, label: {
                    Text("Reset database oggetti").foregroundColor(.red)
                })
                Button(action: {
                    showAlertViaggi.toggle()
                }, label: {
                    Text("Cancella tutti i viaggi").foregroundColor(.red)
                })
            }
            
            Section("Modalità preferenziale: \(selected)"){
                Picker(selection: $selected, label: Text("Mode")) {
                    Image(systemName: "lightbulb").tag("light")
                    Image(systemName: "lightbulb.fill").tag("dark")
                    Image(systemName: "gearshape").tag("none")
                }
                .onAppear{
                    switch myColorScheme {
                        case .none:
                            selected = "none"
                            break
                        case .light:
                            selected = "light"
                            break
                        case .dark:
                            selected = "dark"
                            break
//                        case nil:
//                            selected = "none"
                        default:
                            break
                        }
                }
                .onChange(of: selected){ value in
                    switch selected {
                        case "none":
                            //print("System Default")
                        myColorScheme = nil
                        UserDefaults.standard.set(value, forKey: "PreferredColorScheme")
                        case "light":
                            //print("Light")
                        myColorScheme = .light
                        UserDefaults.standard.set(value, forKey: "PreferredColorScheme")
                        case "dark":
                            //print("Dark")
                        myColorScheme = .dark
                        UserDefaults.standard.set(value, forKey: "PreferredColorScheme")
                        default:
                            break
                    }
                }
                .pickerStyle(.segmented)
                
            }
        }
        .navigationTitle("Impostazioni")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Attenzione, confermando cancellerai tutti gli oggetti da te creati (★)!", isPresented: $showAlertOggettiPersonalizzati){
            Button("Cancella", role: .cancel){
                showAlertOggettiPersonalizzati.toggle()
            }
            Button("Conferma", role: .destructive){
                PersistenceManager.shared.deleteAllOggettiPersonalizzati()
            }
        }
        .alert("Attenzione, confermando ritornai al database iniziale. Equivale alla cancellazione di tutti gli oggetti e le valigie da te create!", isPresented: $showAlertReset){
            Button("Cancella", role: .cancel){
                showAlertReset.toggle()
            }
            Button("Conferma", role: .destructive){
                PersistenceManager.shared.resetDatabase()
            }
        }
        .alert("Attenzione, confermando perderei tutti i viaggio e le informazioni ad esso associate!", isPresented: $showAlertViaggi){
            Button("Cancella", role: .cancel){
                showAlertViaggi.toggle()
            }
            Button("Conferma", role: .destructive){
                PersistenceManager.shared.deleteAllViaggi()
            }
        }
    }
}
//
//struct SettingsView_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingsView()
//    }
//}
