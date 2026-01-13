//
//  TransactionsListView.swift
//  LoginApp
//
//  Created by Nhs@123456 on 13/1/26.
//

import SwiftUI


struct TransactionItemView: View {
    
    let transaction: Transaction
    
    private func formatAmount(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 10
        return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
    }
    
    func formatDate(_ value: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd/MM/yyyy 'vào lúc' HH:mm:ss"
        outputFormatter.locale = Locale(identifier: "vi_VN")
        
        guard let date = inputFormatter.date(from: value) else {
            return value
        }
        return outputFormatter.string(from: date)
    }
    
    var body: some View {
        
        VStack(alignment: .leading) {
            HStack{
                Text(transaction.method)
                    .font(.title3)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                
                Text(transaction.currency)
                    .font(.title3)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                
            }
            Text(transaction.reference)
                .font(.title3)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
            
            
            Text(transaction.description)
                .font(.title3)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
            
            
            Text("\(formatAmount(transaction.amount)) $")
                .font(.title3)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
            
            
            Text(formatDate(transaction.date))
                .font(.title3)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(transaction.status)
                .font(.title3)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(12)
    }
}

private struct AdvancedSearchSheet: View {
    
    @ObservedObject var viewModel: TransactionsListModel
    let onApply: () -> Void
    let onReset: () -> Void
    
    private let statuses: [(title: String, value: String?)] = [
        ("Tất cả", nil),
        ("COMPLETE", "completed"),
        ("FAILED", "failed"),
        ("PENDING", "pending"),
        ("REFUND", "refunded")
    ]
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text("Tìm kiếm nâng cao")
                    .font(.headline)
                    .padding(.top, 10)
                
                TextField(
                    "Từ khoá (mã giao dịch)",
                    text: $viewModel.keyword
                )
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.gray.opacity(0.2), lineWidth: 2)
                )
                
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(statuses, id: \.title) { item in
                        Button {
                            viewModel.selectedStatus = item.value
                        } label: {
                            Text(item.title)
                                .font(.subheadline)
                                .bold()
                                .frame(maxWidth: .infinity, minHeight: 44)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(viewModel.selectedStatus == item.value
                                              ? Color.blue
                                              : Color.gray.opacity(0.2))
                                )
                                .foregroundColor(
                                    viewModel.selectedStatus == item.value
                                    ? .white
                                    : .black
                                )
                        }
                    }
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Thời gian giao dịch")
                        .font(.subheadline)
                        .bold()
                    
                    DatePicker(
                        "Từ ngày",
                        selection: Binding(
                            get: { viewModel.fromDate ?? Date() },
                            set: { viewModel.fromDate = $0 }
                        ),
                        displayedComponents: .date
                    )
                    
                    DatePicker(
                        "Đến ngày",
                        selection: Binding(
                            get: { viewModel.toDate ?? Date() },
                            set: { viewModel.toDate = $0 }
                        ),
                        displayedComponents: .date
                    )
                }
                
                
                
                HStack {
                    TextField("Số tiền từ",
                              value: $viewModel.minAmount,
                              format: .number)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.gray.opacity(0.2), lineWidth: 2)
                    )
                    
                    TextField("Đến",
                              value: $viewModel.maxAmount,
                              format: .number)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.gray.opacity(0.2), lineWidth: 2)
                    )
                }
                
                Spacer()
                
                HStack(alignment: .bottom) {
                    Button {
                        onReset()
                    } label: {
                        Text("Reset")
                            .foregroundStyle(.white)
                            .padding(16)
                            .background(Color.red)
                            .cornerRadius(16)
                            .bold()
                    }
                    
                    Spacer()
                    
                    Button {
                        onApply()
                    } label: {
                        Text("Apply")
                            .foregroundStyle(.white)
                            .padding(16)
                            .background(Color.green)
                            .cornerRadius(16)
                            .bold()
                    }
                }
                .padding(.horizontal)
            }
            .padding()
        }
    }
}


struct TransactionsListView: View {
    @StateObject private var viewModel = TransactionsListModel()
    
    @State private var showFilterSheet = false
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            HStack() {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Đăng xuất")
                        .bold()
                        .font(.title3)
                }
                
                Spacer()
                
                Text("Danh sách giao dịch")
                    .bold()
                    .font(.title2)
                
                Spacer()
                
                Button {
                    showFilterSheet = true
                } label: {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                        .font(.title)
                }
            }
            .padding(.horizontal)
            
            ScrollView {
                LazyVStack(spacing: 12) {
                    
                    switch viewModel.state {
                        
                    case .idle, .loading:
                        ProgressView()
                            .padding(.top, 40)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        
                    case .error(let message):
                        Text(message)
                            .foregroundColor(.red)
                        
                    case .loaded(let transactions):
                        if transactions.isEmpty {
                            VStack(spacing: 12) {
                                Image(systemName: "tray")
                                    .font(.system(size: 40))
                                    .foregroundColor(.gray)
                                
                                Text("Không có dữ liệu")
                                    .foregroundColor(.gray)
                                    .font(.subheadline)
                            }
                            .frame(maxWidth: .infinity, minHeight: 200)
                        } else {
                            ForEach(transactions) { item in
                                TransactionItemView(transaction: item)
                            }
                        }
                    }
                }
                .padding(12)
            }
            .background(Color.gray.opacity(0.2))
            .onAppear {
                viewModel.fetchTransactions()
            }
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showFilterSheet) {
            AdvancedSearchSheet(
                viewModel: viewModel,
                onApply: {
                    viewModel.applyAdvancedSearch()
                    showFilterSheet = false
                },
                onReset: {
                    viewModel.resetSearch()
                    showFilterSheet = false
                }
            )
            .presentationDetents([.medium, .large])
        }
        
    }
}


#Preview {
    TransactionsListView()
}
