import SwiftUI

struct ContentView: View {
    
    struct FlightDetail: View {
        let flight: Flight
        
        var body: some View {
            VStack{
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
                    }) {
                        Image(systemName: "heart")
                            .foregroundColor(Color.gray) // Устанавливаем цвет сердечка
                            .padding(.trailing, 8)
                            .padding(.leading, 8)
                    }
                }
            }
            Spacer()
        }
    }
    
    var body: some View {
        NavigationView {
            List(flights, id: \.searchToken) { flight in
                NavigationLink(destination: FlightDetail(flight: flight)) {
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
                        Button(action: {
                            // Обработчик нажатия на кнопку (вы можете добавить свою логику здесь)
                        }) {
                            Image(systemName: "heart")
                                .foregroundColor(Color.gray) // Устанавливаем цвет сердечка
                                .padding(.trailing, 8)
                                .padding(.leading, 6)
                        }
                    }
                }
            }
            .listRowInsets(EdgeInsets())
            .onAppear {
                fetchData()
            }
            .navigationTitle("Пора в путешествие")
        }
    }
    
    @State private var flights: [Flight] = [] // Свойство для хранения данных о рейсах
    
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
                            print("Полученные рейсы: \(self.flights)")
                        }
                        // Теперь у вас есть массив данных о рейсах в свойстве flights
                    } catch {
                        print("Ошибка при декодировании JSON: \(error)")
                    }
                }
            }.resume()
        }
    }
}
