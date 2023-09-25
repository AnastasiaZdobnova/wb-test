import SwiftUI

struct ContentView: View {
    
    struct FlightDetail: View {
        let flight: Flight
        @Binding var likedFlights: [String: Bool]
        
        var body: some View {//второй экран
            VStack {
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Детали перелета")
                            .font(.title)
                        Text("Отправление:")
                            .font(.headline)
                            .foregroundColor(Color.gray)
                        Text("\(flight.startCity) \(flight.startDate.prefix(10).description) ")
                            .font(.title3)
                        Text("Прибытие: ")
                            .font(.headline)
                            .foregroundColor(Color.gray)
                        Text("\(flight.endCity) \(flight.endDate.prefix(10).description)")
                            .font(.title3)
                        Text("Стоимость: ")
                            .font(.headline)
                            .foregroundColor(Color.gray)
                        Text("\(flight.price) ₽")
                            .font(.title3)
                    }
                    Button(action: {
                        likedFlights[flight.searchToken]?.toggle()
                    }) {
                        Image(systemName: likedFlights[flight.searchToken] ?? false ? "heart.fill" : "heart")
                            .foregroundColor(likedFlights[flight.searchToken] ?? false ? .red : .gray)
                            .padding(.trailing, 8)
                            .padding(.leading, 6)
                    }
                }
            }
            Spacer()
        }
    }
    
    var body: some View { // первый экран
        NavigationView {
            if flights.isEmpty {
                ProgressView("Загрузка...")
                    .onAppear {
                        FlightDataFetcher.fetchData { flightData in // загрузка данных
                            self.flights = flightData.flights
                            self.likedFlights = flightData.likedFlights
                        }
                    }
            } else {
                List(flights, id: \.searchToken) { flight in
                    NavigationLink(destination: FlightDetail(flight: flight, likedFlights: $likedFlights)) {
                        HStack {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("\(flight.startCity) - \(flight.endCity)")
                                    .font(.headline)
                                Text("\(flight.startDate.prefix(10).description) - \(flight.endDate.prefix(10).description)")
                                    .font(.subheadline)
                                    .foregroundColor(Color.gray)
                                Text("\(flight.price) ₽")
                                    .font(.headline)
                            }
                            Spacer()
                            Image(systemName: likedFlights[flight.searchToken] ?? false ? "heart.fill" : "heart")
                                .foregroundColor(likedFlights[flight.searchToken] ?? false ? .red : .gray)
                                .padding(.trailing, 8)
                                .padding(.leading, 6)
                                .onTapGesture {
                                    likedFlights[flight.searchToken]?.toggle()//изменение состояния лайка
                                }
                        }
                    }
                }
                .navigationTitle("Пора в путешествие")
            }
        }
    }
    
    @State private var flights: [Flight] = []
    @State private var likedFlights: [String: Bool] = [:]
}

