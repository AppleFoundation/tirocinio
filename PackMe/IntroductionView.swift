//
//  IntroductionView.swift
//  ProjectWork
//
//  Created by Cristian Cerasuolo on 19/02/22.
//

import SwiftUI

struct IntroductionView: View {
    
    @Binding var showingWelcomeView: Bool
    
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center) {

                Spacer()

                TitleView()

                InformationContainerView()

                            
            }


        }
        Spacer()
        VStack{
            Button(action: {
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.success)
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Continua")
                    .customButton()
            }
            .padding(.horizontal)
        }
    }
}

struct TitleView: View {
    var body: some View {
        VStack {
            Image("person.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 180, alignment: .center)
                .accessibility(hidden: true)

            Text("Benvenuto in")
                .customTitleText()

            Text("PackMe")
                .customTitleText()
                .foregroundColor(.blue)
        }
    }
}

struct InformationContainerView: View {
    var body: some View {
        VStack(alignment: .leading) {
            InformationDetailView(title: "Imballaggio", subTitle: "Porta con te tutto il necessario senza perdere tempo a capire dove posizionare gli oggetti!", imageName: "suitcase.fill")
            InformationDetailView(title: "Risparmio", subTitle: "Evita di pagare per gli eccessi di peso, con quest'app saprai sempre quanto pesa la tua valigia!", imageName: "creditcard.fill")
            InformationDetailView(title: "Lista intelligente", subTitle: "Prepara la tua valigia in forma digitale in modo da non dimenticare nulla!", imageName: "checklist")
        }
        .padding(.horizontal)
    }
}

struct InformationDetailView: View {
    var title: String = "title"
    var subTitle: String = "subTitle"
    var imageName: String = "car"

    var body: some View {
        HStack(alignment: .center) {
            Image(systemName: imageName)
                .font(.largeTitle)
                .foregroundColor(.blue)
                .padding()
                .accessibility(hidden: true)

            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .accessibility(addTraits: .isHeader)

                Text(subTitle)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .onAppear{
            PersistenceManager.shared.inizializzaOggetti()
            PersistenceManager.shared.inizializzaValigie()
        }
        .padding(.top)
    }
}

struct ButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.white)
            .font(.headline)
            .padding()
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
            .background(RoundedRectangle(cornerRadius: 15, style: .continuous)
                .fill(Color.blue))
            .padding(.bottom)
    }
}


