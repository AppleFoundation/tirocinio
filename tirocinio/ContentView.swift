//
//  ContentView.swift
//  tirocinio
//
//  Created by Grazia Ferrara on 24/04/22.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.colorScheme) var systemColorScheme
    
    @State var showingWelcomeView: Bool = !UserDefaults.standard.bool(forKey: "firstAccess")
    @State var myColorScheme: ColorScheme?
    
    var body: some View{
        
        NavigationView{
            
            MainView()
            
            .navigationViewStyle(.stack)
            .navigationTitle("SmartSuitCase")
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: SettingsView(myColorScheme: $myColorScheme)) {
                        Image(systemName: "gearshape.fill")
                            
                  }
                }
            }
        }
        
        .sheet(isPresented: $showingWelcomeView, onDismiss: {
            UserDefaults.standard.set(true, forKey: "firstAccess")
        }){
            IntroductionView(showingWelcomeView: $showingWelcomeView)
        }
        .onAppear{
            self.myColorScheme = getPreferredColorScheme(system: self.systemColorScheme)
        }
        .colorScheme(myColorScheme ?? systemColorScheme)
    }
    
    func getPreferredColorScheme(system: ColorScheme) -> ColorScheme?{
        let preferred: String = UserDefaults.standard.string(forKey: "PreferredColorScheme") ?? "none"
        print("\(preferred)")
        switch preferred{
        case "none":
            print("NONE")
            return nil;
        case "dark":
            print("DARK")
            return ColorScheme.dark;
        case "light":
            print("LIGHT")
            return ColorScheme.light;
        default:
            print("NONE")
            return system;
        }
    }
    
}
