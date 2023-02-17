//
//  TransactionList.swift
//  expense_tracker
//
//  Created by Experimental Station on 2/16/23.
//

import SwiftUI

struct TransactionList: View {
    @EnvironmentObject var transactionListVM: TransactionListViewModel
    
    var body: some View {
        VStack{
            List{
                ForEach(Array(transactionListVM.groupTransactionsByMonth()), id: \.key){ month,
                    transactions in
                    Section{
                        ForEach(transactions){
                            transaction in TransactionRow(transaction: transaction)
                        }
                    }header: {
                        Text(month)
                    }
                    .listSectionSeparator(.hidden)
                }
            }
            .listStyle(.plain)
        }
        .navigationTitle("Transactions")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.background)
    }
}

struct TransactionList_Previews: PreviewProvider {
    static let transactionListVM: TransactionListViewModel = {
        let transactionListVM = TransactionListViewModel()
        transactionListVM.transactions = transactionListPreviewData
        return transactionListVM
    }()
    static var previews: some View {
        Group{
            NavigationView{
                TransactionList()
            }
            NavigationView{
                TransactionList().preferredColorScheme(.dark)
                
            }
        }
        .environmentObject(transactionListVM)
    }
}
