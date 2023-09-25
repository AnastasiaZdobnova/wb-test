import Foundation

struct FlightDataModel {
    var flights: [Flight] = []
    var likedFlights: [String: Bool] = [:]
}

class FlightDataFetcher {
    static func fetchData(completion: @escaping (FlightDataModel) -> Void) {
        var flightData = FlightDataModel()
        
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
                            flightData.flights = flightResponse.flights
                            print("Получены рейсы")
                            //Инициализируем словарь лайков по умолчанию
                            for flight in flightResponse.flights {
                                flightData.likedFlights[flight.searchToken] = false
                            }
                            completion(flightData)
                        }
                    } catch {
                        print("Ошибка при декодировании JSON: \(error)")
                    }
                }
            }.resume()
        }
    }
}

