//
//  IntroductionView.swift
//  ProjectWork
//
//  Created by Cristian Cerasuolo on 19/02/22.
//

import SwiftUI

struct IntroductionView: View {
    
    @Binding var showingWelcomeView: Bool
    @Binding var showingInsertDataView: Bool
    @Environment(\.presentationMode) private var presentationMode
    
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center) {

                Spacer()

                TitleView()

                InformationContainerView()

                Spacer(minLength: 30)

                Button(action: {
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.success)
                    presentationMode.wrappedValue.dismiss()
                    showingInsertDataView = true
                }) {
                    Text("Continue")
                        .customButton()
                }
                .padding(.horizontal)
            
            }
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

            Text("Welcome to")
                .customTitleText()

            Text("Off-Site")
                .customTitleText()
                .foregroundColor(.blue)
        }
    }
}

struct InformationContainerView: View {
    var body: some View {
        VStack(alignment: .leading) {
            InformationDetailView(title: "Move", subTitle: "Reach the campus easily", imageName: "figure.walk")

            InformationDetailView(title: "Find", subTitle: "To get what you need", imageName: "dot.viewfinder")

            InformationDetailView(title: "Survive", subTitle: "To live away from home", imageName: "waveform.path.ecg")
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

extension View {
    func customButton() -> ModifiedContent<Self, ButtonModifier> {
        return modifier(ButtonModifier())
    }
}

extension Text {
    func customTitleText() -> Text {
        self
            .fontWeight(.black)
            .font(.system(size: 36))
    }
}
