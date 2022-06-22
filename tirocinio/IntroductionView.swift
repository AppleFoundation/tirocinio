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
                Text("Continue")
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

            Text("Welcome to")
                .customTitleText()

            Text("SuitCases")
                .customTitleText()
                .foregroundColor(.blue)
        }
    }
}

struct InformationContainerView: View {
    var body: some View {
        VStack(alignment: .leading) {
            InformationDetailView(title: "Packing", subTitle: "Porta con te tutto il necessario senza perdetere tempo a capire dove posizionare gli oggetti!", imageName: "suitcase.fill")

//            InformationDetailView(title: "Find", subTitle: "To get what you need", imageName: "dot.viewfinder")

//            InformationDetailView(title: "Survive", subTitle: "To live away from home", imageName: "waveform.path.ecg")
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
            inizializzaOggetti()
            inizializzaValigie()
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

func inizializzaOggetti(){
    
    //Categoria 1
    PersistenceManager.shared.addOggetto(categoria: "Articoli da bagno", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Profumo")
    PersistenceManager.shared.addOggetto(categoria: "Articoli da bagno", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Deodorante")
    PersistenceManager.shared.addOggetto(categoria: "Articoli da bagno", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Bagnoschiuma")
    PersistenceManager.shared.addOggetto(categoria: "Articoli da bagno", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Cotton fioc")
    PersistenceManager.shared.addOggetto(categoria: "Articoli da bagno", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Dentifricio")
    PersistenceManager.shared.addOggetto(categoria: "Articoli da bagno", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Gel da barba")
    PersistenceManager.shared.addOggetto(categoria: "Articoli da bagno", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Lenti a contatto")
    PersistenceManager.shared.addOggetto(categoria: "Articoli da bagno", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Pinzetta")
    PersistenceManager.shared.addOggetto(categoria: "Articoli da bagno", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Rasoio")
    PersistenceManager.shared.addOggetto(categoria: "Articoli da bagno", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Spazzolino da denti")
    PersistenceManager.shared.addOggetto(categoria: "Articoli da bagno", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Spazzola")
    PersistenceManager.shared.addOggetto(categoria: "Articoli da bagno", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Tagliaunghie")
    PersistenceManager.shared.addOggetto(categoria: "Articoli da bagno", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Trucchi")
    PersistenceManager.shared.addOggetto(categoria: "Articoli da bagno", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Gel per capelli")
    PersistenceManager.shared.addOggetto(categoria: "Articoli da bagno", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Lacca")
    PersistenceManager.shared.addOggetto(categoria: "Articoli da bagno", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Colluttorio")
    PersistenceManager.shared.addOggetto(categoria: "Articoli da bagno", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Pantofole")
    PersistenceManager.shared.addOggetto(categoria: "Articoli da bagno", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Accappatoio")
    //Categoria 2
    PersistenceManager.shared.addOggetto(categoria: "Abbigliamento", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Biancheria Intima")
    PersistenceManager.shared.addOggetto(categoria: "Abbigliamento", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Calzini")
    PersistenceManager.shared.addOggetto(categoria: "Abbigliamento", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "T-Shirt")
    PersistenceManager.shared.addOggetto(categoria: "Abbigliamento", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Maglioncino")
    PersistenceManager.shared.addOggetto(categoria: "Abbigliamento", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Maglione")
    PersistenceManager.shared.addOggetto(categoria: "Abbigliamento", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Giacca")
    PersistenceManager.shared.addOggetto(categoria: "Abbigliamento", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Cappotto")
    PersistenceManager.shared.addOggetto(categoria: "Abbigliamento", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Giubbino")
    PersistenceManager.shared.addOggetto(categoria: "Abbigliamento", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Pantaloncino")
    PersistenceManager.shared.addOggetto(categoria: "Abbigliamento", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Pantalone")
    PersistenceManager.shared.addOggetto(categoria: "Abbigliamento", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Camicia")
    PersistenceManager.shared.addOggetto(categoria: "Abbigliamento", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Pigiama")
    PersistenceManager.shared.addOggetto(categoria: "Abbigliamento", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Scarpe")
    PersistenceManager.shared.addOggetto(categoria: "Abbigliamento", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Calze")
    PersistenceManager.shared.addOggetto(categoria: "Abbigliamento", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Leggins")
    //Categoria 3
    PersistenceManager.shared.addOggetto(categoria: "Essenziali", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Farmaci")
    PersistenceManager.shared.addOggetto(categoria: "Essenziali", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Chiavi di casa")
    PersistenceManager.shared.addOggetto(categoria: "Essenziali", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Mascherine")
    PersistenceManager.shared.addOggetto(categoria: "Essenziali", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Occhiali")
    PersistenceManager.shared.addOggetto(categoria: "Essenziali", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Orologio")
    PersistenceManager.shared.addOggetto(categoria: "Essenziali", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Portafoglio")
    PersistenceManager.shared.addOggetto(categoria: "Essenziali", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Passaporto")
    PersistenceManager.shared.addOggetto(categoria: "Essenziali", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Penna")
    PersistenceManager.shared.addOggetto(categoria: "Essenziali", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Documenti di identità")
    PersistenceManager.shared.addOggetto(categoria: "Essenziali", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Lucchetto")
    PersistenceManager.shared.addOggetto(categoria: "Essenziali", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Occhiali da sole")
    PersistenceManager.shared.addOggetto(categoria: "Essenziali", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Bottiglia d’acqua")
    PersistenceManager.shared.addOggetto(categoria: "Essenziali", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Apribottiglie")
    PersistenceManager.shared.addOggetto(categoria: "Essenziali", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Accendino")
    PersistenceManager.shared.addOggetto(categoria: "Essenziali", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Borraccia")
    PersistenceManager.shared.addOggetto(categoria: "Essenziali", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Ombrello")
    PersistenceManager.shared.addOggetto(categoria: "Essenziali", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Libro")
    //Categoria 4
    PersistenceManager.shared.addOggetto(categoria: "Campeggio", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Buste di plastica")
    PersistenceManager.shared.addOggetto(categoria: "Campeggio", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Carta Igienica")
    PersistenceManager.shared.addOggetto(categoria: "Campeggio", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Coltello mutliuso")
    PersistenceManager.shared.addOggetto(categoria: "Campeggio", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Cuscino")
    PersistenceManager.shared.addOggetto(categoria: "Campeggio", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Torcia")
    PersistenceManager.shared.addOggetto(categoria: "Campeggio", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Utensili da cucina")
    //Categoria 5
    PersistenceManager.shared.addOggetto(categoria: "Spiaggia", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Borsa da spiaggia")
    PersistenceManager.shared.addOggetto(categoria: "Spiaggia", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Cappello")
    PersistenceManager.shared.addOggetto(categoria: "Spiaggia", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Costume da bagno")
    PersistenceManager.shared.addOggetto(categoria: "Spiaggia", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Protezione Solare")
    PersistenceManager.shared.addOggetto(categoria: "Spiaggia", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Doposole")
    PersistenceManager.shared.addOggetto(categoria: "Spiaggia", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Ombrellone da spiaggia")
    PersistenceManager.shared.addOggetto(categoria: "Spiaggia", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Telo mare")
    PersistenceManager.shared.addOggetto(categoria: "Spiaggia", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Occhialini")
    //Categoria 6
    PersistenceManager.shared.addOggetto(categoria: "Sport", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "T-shirt da palestra")
    PersistenceManager.shared.addOggetto(categoria: "Sport", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Felpa tuta")
    PersistenceManager.shared.addOggetto(categoria: "Sport", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Pantaloni tuta")
    PersistenceManager.shared.addOggetto(categoria: "Sport", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Pantaloncini tuta")
    PersistenceManager.shared.addOggetto(categoria: "Sport", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Scarpe da ginnastica")
    PersistenceManager.shared.addOggetto(categoria: "Sport", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Scarpe da trekking")
    //Categoria 7
    PersistenceManager.shared.addOggetto(categoria: "Informatica ed Elettronica", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Caricabatterie smartphone")
    PersistenceManager.shared.addOggetto(categoria: "Informatica ed Elettronica", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Macchina Fotografica")
    PersistenceManager.shared.addOggetto(categoria: "Informatica ed Elettronica", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Cuffie")
    PersistenceManager.shared.addOggetto(categoria: "Informatica ed Elettronica", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Computer portatile")
    PersistenceManager.shared.addOggetto(categoria: "Informatica ed Elettronica", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Caricatore laptop")
    PersistenceManager.shared.addOggetto(categoria: "Informatica ed Elettronica", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Smartwatch")
    PersistenceManager.shared.addOggetto(categoria: "Informatica ed Elettronica", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Caricatore Smartwatch")
    PersistenceManager.shared.addOggetto(categoria: "Informatica ed Elettronica", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Powerbank")
    PersistenceManager.shared.addOggetto(categoria: "Informatica ed Elettronica", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Cacciaviti")
}

func inizializzaValigie(){
    PersistenceManager.shared.addValigia(categoria: "Trolley", lunghezza: 35, larghezza: 40, profondita: 20, nome: "Bagaglio", tara: 1000, utilizzato: false)
    
    PersistenceManager.shared.addValigia(categoria: "0SYSTEM", lunghezza: 0, larghezza: 0, profondita: 0, nome: "Non Allocati", tara: 0, utilizzato: false)
}
