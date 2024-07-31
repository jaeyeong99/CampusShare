//
//  Rental.swift
//  GnuRental
//
//  Created by 정재영 on 2/15/24.
//

import Foundation

final class Rental: ObservableObject{

    @Published var wares: [Ware] = []
    @Published var rentalInfo: [RentalInfo] = []
    
    
    
    func fetchWares(accessToken: String) {
        guard let url = URL(string: "http://58.122.188.69:8080/ware") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "accept")
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching data: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Error with the response, unexpected status code: \((response as? HTTPURLResponse)?.statusCode ?? 0)")
                return
            }
            
            guard let data = data else {
                print("No data")
                return
            }
            
            do {
                let wares = try JSONDecoder().decode([Ware].self, from: data)
                DispatchQueue.main.async {
                    self.wares = wares
                }
                for ware in wares {
                    print("Ware ID: \(ware.wareId), Category: \(ware.category), Name: \(ware.name), Max Count: \(ware.maxCount), Current Count: \(ware.currentCount)")
                }
            } catch {
                print("Error decoding data: \(error.localizedDescription)")
            }
        }.resume()
    }
}





