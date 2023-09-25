import SwiftUI

struct ContentView: View {
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
                .onAppear {
                    fetchData()
                }
        }
        .padding()
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
