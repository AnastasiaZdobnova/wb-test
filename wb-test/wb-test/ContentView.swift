//
//import SwiftUI
//
//struct ContentView: View {
//    
//    struct FlightDetail: View {
//        let flight: Flight
//        @Binding var likedFlights: [String: Bool] // Добавляем привязку к словарю лайков
//        
//        var body: some View {
//            VStack {
//                HStack {
//                    VStack(alignment: .leading, spacing: 8) {
//                        Text("Детали перелета")
//                            .font(.title)
//                        Text("Отправление:")
//                            .font(.headline)
//                            .foregroundColor(Color.gray)
//                        Text("\(flight.startCity) \(flight.startDate.prefix(10).description) ")
//                            .font(.title3)
//                        Text("Прибытие: ")
//                            .font(.headline)
//                            .foregroundColor(Color.gray)
//                        Text("\(flight.endCity) \(flight.endDate.prefix(10).description)")
//                            .font(.title3)
//                        Text("Стоимость: ")
//                            .font(.headline)
//                            .foregroundColor(Color.gray)
//                        Text("\(flight.price) ₽")
//                            .font(.title3)
//                    }
//                    Button(action: {
//                        // Обработчик нажатия на кнопку (вы можете добавить свою логику здесь)
//                        likedFlights[flight.searchToken]?.toggle() // Изменяем статус "лайка"
//                    }) {
//                        Image(systemName: likedFlights[flight.searchToken] ?? false ? "heart.fill" : "heart")
//                            .foregroundColor(likedFlights[flight.searchToken] ?? false ? .red : .gray) // Устанавливаем цвет кнопки
//                            .padding(.trailing, 8)
//                            .padding(.leading, 6)
//                    }
//                }
//            }
//            Spacer()
//        }
//    }
//    
//    var body: some View {
//        NavigationView {
//            List(flights, id: \.searchToken) { flight in
//                NavigationLink(destination: FlightDetail(flight: flight, likedFlights: $likedFlights)) {
//                    HStack {
//                        VStack(alignment: .leading, spacing: 8) {
//                            Text("\(flight.startCity) - \(flight.endCity)")
//                                .font(.headline)
//                            Text("\(flight.startDate.prefix(10).description) - \(flight.endDate.prefix(10).description)")
//                                .font(.subheadline)
//                                .foregroundColor(Color.gray)
//                            Text("\(flight.price) ₽")
//                                .font(.headline)
//                        }
//                        Spacer()
//                        Image(systemName: likedFlights[flight.searchToken] ?? false ? "heart.fill" : "heart")
//                            .foregroundColor(likedFlights[flight.searchToken] ?? false ? .red : .gray) // Устанавливаем цвет кнопки
//                            .padding(.trailing, 8)
//                            .padding(.leading, 6)
//                            .onTapGesture {
//                                // Обработчик нажатия на кнопку "лайк"
//                                likedFlights[flight.searchToken]?.toggle() // Изменяем статус "лайка"
//                            }
//                    }
//                }
//            }
//            
//            .listRowInsets(EdgeInsets())
//            .onAppear {
//                if flights.isEmpty {
//                    fetchData()
//                }
//            }
//            .navigationTitle("Пора в путешествие")
//        }
//    }
//    
//    @State private var flights: [Flight] = [] // Свойство для хранения данных о рейсах
//    @State private var likedFlights: [String: Bool] = [:] // Словарь для хранения состояния лайков
//    
//    func fetchData() {
//        if let url = URL(string: "https://vmeste.wildberries.ru/stream/api/avia-service/v1/suggests/getCheap") {
//            var request = URLRequest(url: url)
//            request.httpMethod = "POST"
//            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//            request.addValue("https://vmeste.wildberries.ru", forHTTPHeaderField: "Origin")
//            request.addValue("https://vmeste.wildberries.ru/avia", forHTTPHeaderField: "Referer")
//            
//            let requestBody = ["startLocationCode": "LED"]
//            do {
//                let jsonData = try JSONSerialization.data(withJSONObject: requestBody, options: [])
//                request.httpBody = jsonData
//            } catch {
//                print("Ошибка при создании JSON-данных: \(error)")
//            }
//            
//            URLSession.shared.dataTask(with: request) { (data, response, error) in
//                if let error = error {
//                    print("Ошибка запроса: \(error)")
//                } else if let data = data {
//                    do {
//                        let decoder = JSONDecoder()
//                        let flightResponse = try decoder.decode(FlightResponse.self, from: data)
//                        DispatchQueue.main.async {
//                            self.flights = flightResponse.flights // Сохраняем данные о рейсах
//                            print("Получены рейсы")
//                            
//                            // Инициализируем словарь лайков по умолчанию
//                            for flight in self.flights {
//                                self.likedFlights[flight.searchToken] = false
//                            }
//                        }
//                    } catch {
//                        print("Ошибка при декодировании JSON: \(error)")
//                    }
//                }
//            }.resume()
//        }
//    }
//}
//
import SwiftUI

struct ContentView: View {
    
    struct FlightDetail: View {
        let flight: Flight
        @Binding var likedFlights: [String: Bool] // Добавляем привязку к словарю лайков
        
        var body: some View {
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
                        // Обработчик нажатия на кнопку (вы можете добавить свою логику здесь)
                        likedFlights[flight.searchToken]?.toggle() // Изменяем статус "лайка"
                    }) {
                        Image(systemName: likedFlights[flight.searchToken] ?? false ? "heart.fill" : "heart")
                            .foregroundColor(likedFlights[flight.searchToken] ?? false ? .red : .gray) // Устанавливаем цвет кнопки
                            .padding(.trailing, 8)
                            .padding(.leading, 6)
                    }
                }
            }
            Spacer()
        }
    }
    
    var body: some View {
        NavigationView {
            if flights.isEmpty {
                ProgressView("Загрузка...") // Индикатор загрузки
                    .onAppear {
                        fetchData()
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
                                .foregroundColor(likedFlights[flight.searchToken] ?? false ? .red : .gray) // Устанавливаем цвет кнопки
                                .padding(.trailing, 8)
                                .padding(.leading, 6)
                                .onTapGesture {
                                    // Обработчик нажатия на кнопку "лайк"
                                    likedFlights[flight.searchToken]?.toggle() // Изменяем статус "лайка"
                                }
                        }
                    }
                }
                .listRowInsets(EdgeInsets())
                .navigationTitle("Пора в путешествие")
            }
        }
    }
    
    @State private var flights: [Flight] = [] // Свойство для хранения данных о рейсах
    @State private var likedFlights: [String: Bool] = [:] // Словарь для хранения состояния лайков
    
    func fetchData() {
        if let url = URL(string: "https://vmeste.wildberries.ru/stream/api/avia-service/v1/suggests/getCheap") {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("https://vmeste.wildberries.ru", forHTTPHeaderField: "Origin")
            request.addValue("https://vmeste.wildberries.ru/avia", forHTTPHeaderField: "Referer")
            
            let requestBody = ["startLocationCode": "LED"]
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: requestBody, options: [])
                request.httpBody = jsonData
            } catch {
                print("Ошибка при создании JSON-данных: \(error)")
            }
            
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("Ошибка запроса: \(error)")
                } else if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let flightResponse = try decoder.decode(FlightResponse.self, from: data)
                        DispatchQueue.main.async {
                            self.flights = flightResponse.flights // Сохраняем данные о рейсах
                            print("Получены рейсы")
                            
                            // Инициализируем словарь лайков по умолчанию
                            for flight in self.flights {
                                self.likedFlights[flight.searchToken] = false
                            }
                        }
                    } catch {
                        print("Ошибка при декодировании JSON: \(error)")
                    }
                }
            }.resume()
        }
    }
}
