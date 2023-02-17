//
//  TransactionListViewModel.swift
//  expense_tracker
//
//  Created by Experimental Station on 2/15/23.
//

import Foundation
import Combine
import Collections

typealias TransactionGroup = OrderedDictionary<String, [Transaction]>

typealias TransactionPrefixSum = [(String, Double)]

final class TransactionListViewModel: ObservableObject{
    // turns any object into a publisher & will notify its subscribers of its state changes so users can refresh their views
    @Published var transactions: [Transaction] = []
    private var cancellables = Set<AnyCancellable>()
    
    init(){
        getTransactions()
    }
    
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
    
    func groupTransactionsByMonth() -> TransactionGroup {
        guard !transactions.isEmpty else {return [ : ]}
        
        let groupedTransactions = TransactionGroup(grouping: transactions){$0.month}
        
        return groupedTransactions
    }
    
    func accumulateTransactions() -> TransactionPrefixSum {
        guard !transactions.isEmpty else {return []}
        let startDate = "12/01/2020"
        let endDate = "12/31/2025"
        let dateFormatter = ISO8601DateFormatter()
        let start = dateFormatter.date(from: startDate)
        let end = dateFormatter.date(from: endDate)!
        
        let dateInterval = DateInterval(start: start, end: end)
//        Calendar.current.dateInterval(of: .month, for: endDate)!
        print("date interval", dateInterval)
//        date interval 2019-12-22 07:00:00 +0000 to 2020-12-20 07:00:00 +0000
        var sum: Double = .zero //single value
        var cumulativeSum = TransactionPrefixSum() //set of values
        
        for date in stride(from: dateInterval.start, to: dateInterval.end, by: 60 * 60 * 24){
            let dailyExpenses = transactions.filter({ $0.isExpense })
            
//            print("daily expenses", dailyExpenses)
            
            let dailyTotal = dailyExpenses.reduce(0){ $0 - $1.signedAmount }
            
//            print("daily total", dailyTotal)
            
            sum += dailyTotal
            sum = sum.roundedTo2Digits()
            cumulativeSum.append((date.formatted(), sum))
            
        }
        return cumulativeSum
    }
    
}
