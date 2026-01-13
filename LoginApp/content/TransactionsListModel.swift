//
//  TransactionsListModel.swift
//  LoginApp
//
//  Created by Nhs@123456 on 13/1/26.
//

import Foundation
internal import Combine

enum TransactionState {
    case idle
    case loading
    case loaded([Transaction])
    case error(String)
}

class TransactionsListModel: ObservableObject {
    @Published private(set) var state: TransactionState = .idle
    
    private var allTransactions: [Transaction] = []
    private var cancelLables = Set<AnyCancellable>()
    
    @Published var keyword: String = ""
    @Published var selectedStatus: String? = nil
    @Published var minAmount: Double? = nil
    @Published var maxAmount: Double? = nil
    @Published var fromDate: Date? = nil
    @Published var toDate: Date? = nil
    
    private let apiDateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd HH:mm:ss"
        f.locale = Locale(identifier: "en_US_POSIX")
        return f
    }()



    
    func fetchTransactions() {
        state = .loading
        
        guard let url = URL(string: "https://mockly.me/transactions") else {
            state = .error("Lỗi lấy dữ liệu giao dịch")
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [Transaction].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink{
                [weak self] completion in
                if case .failure(let error) = completion {
                    self?.state = .error(error.localizedDescription)
                }
            }
        receiveValue: { [weak self] transactions in
            self?.allTransactions = transactions
            self?.state = .loaded(transactions)
        }
        .store(in: &cancelLables)
    }
    
    func applyAdvancedSearch() {
        guard case .loaded = state else { return }

        let filtered = allTransactions.filter { t in

            let matchKeyword =
                keyword.isEmpty ||
                t.reference.lowercased().contains(keyword.lowercased())

            let matchStatus =
                selectedStatus == nil || t.status == selectedStatus

            let matchMinAmount =
                minAmount == nil || t.amount >= minAmount!

            let matchMaxAmount =
                maxAmount == nil || t.amount <= maxAmount!
            
            var matchDate = true
                  if let date = apiDateFormatter.date(from: t.date) {

                      if let from = fromDate {
                          let endOfDay = Calendar.current.date(
                              bySettingHour: 00, minute: 00, second: 00, of: from
                          )!
                          matchDate = date >= endOfDay
                      }

                      if let to = toDate {
                          let endOfDay = Calendar.current.date(
                              bySettingHour: 23, minute: 59, second: 59, of: to
                          )!
                          matchDate = matchDate && date <= endOfDay
                      }
                  }

            return matchKeyword
                && matchStatus
                && matchMinAmount
                && matchMaxAmount
                && matchDate
        }

        state = .loaded(filtered)
    }
    
    func resetSearch() {
        keyword = ""
        selectedStatus = nil
        minAmount = nil
        maxAmount = nil
        fromDate = nil
        toDate = nil
        state = .loaded(allTransactions)
    }


}
