//
//  PreviewData.swift
//  expense_tracker
//
//  Created by Experimental Station on 2/15/23.
//

import Foundation

var transactionPreviewData = Transaction(id: 1, date: "01/20/2023", institution: "Desjarins", account: "Visa Desjardins", merchant: "Apple", amount: 11.49, type: "debit", categoryId: 801, category: "Software", isPending: false, isTransfer: false, isExpense: true, isEdited: false)

var transactionListPreviewData = [Transaction](repeating: transactionPreviewData, count: 10)
