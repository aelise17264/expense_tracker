//
//  TransactionListViewModel.swift
//  expense_tracker
//
//  Created by Experimental Station on 2/15/23.
//

import Foundation
import Combine

final class TransactionListViewModel: ObservableObject{
    // turns any object into a publisher & will notify its subscribers of its state changes so users can refresh their views
    @Published var transactions: [Transaction] = []
    private var cancellables = Set<AnyCancellable>()
    
    func getTransactions(){
        guard let url = URL(string: "https://designcode.io/data/transactions.json") else{
            print("invalid URL")
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap{
                (data, response) -> Data in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else{
                    dump(response)
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: [Transaction].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion{
                case .failure(let error):
                    print("Error fetching transations:", error.localizedDescription)
                case .finished:
                    print("Finished fetching transaction")
                }
                
            } receiveValue: { [weak self] result in
                //prevent memory leaks
                self?.transactions = result
                dump(self?.transactions)
            }
            .store(in: &cancellables)

    }
    
}
