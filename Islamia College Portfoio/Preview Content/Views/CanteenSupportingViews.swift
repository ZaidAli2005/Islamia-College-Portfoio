//
//  CanteenSupportingViews.swift
//  Islamia College Portfolio
//
//  Created by Development on 17/06/2025.
//

import SwiftUI

struct CartView: View {
    @ObservedObject var canteenModel: CanteenModel
    @Binding var showingStudentForm: Bool
    @Environment(\.dismiss) private var dismiss
    @State private var animateItems = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.gray.opacity(0.05).ignoresSafeArea()
            }
            .navigationTitle("Your Cart")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
                
                if !canteenModel.cart.isEmpty {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Clear") {
                            withAnimation(.easeInOut) {
                                canteenModel.clearCart()
                            }
                        }
                        .foregroundColor(.red)
                    }
                }
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.6)) {
                animateItems = true
            }
        }
    }
    
    private var emptyCartView: some View {
        VStack(spacing: 20) {
            Image(systemName: "cart")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("Your cart is empty")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.gray)
            
            Text("Add some delicious items from the canteen menu!")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
    }
}

struct FoodDetailView: View {
    let foodItem: FoodItem
    @ObservedObject var canteenModel: CanteenModel
    @Environment(\.dismiss) private var dismiss
    @State private var quantity = 1
    @State private var showingAddedToCart = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(LinearGradient(
                                gradient: Gradient(colors: [Color.orange.opacity(0.4), Color.red.opacity(0.4)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                            .frame(height: 250)
                        
                        Image(systemName: "fork.knife")
                            .font(.system(size: 60))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(foodItem.name)
                                    .font(.title)
                                    .fontWeight(.bold)
                                
                                HStack(spacing: 8) {
                                    HStack(spacing: 2) {
                                        ForEach(0..<5) { index in
                                            Image(systemName: "star.fill")
                                                .foregroundColor(Double(index) < foodItem.rating ? .yellow : .gray.opacity(0.3))
                                                .font(.caption)
                                        }
                                    }
                                    Text(String(format: "%.1f", foodItem.rating))
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                            }
                            
                            Spacer()
                        }
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description")
                                .font(.headline)
                                .fontWeight(.semibold)
                            
                            Text(foodItem.description)
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Ingredients")
                                .font(.headline)
                                .fontWeight(.semibold)
                            
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: 8) {
                                ForEach(foodItem.ingredients, id: \.self) { ingredient in
                                    Text(ingredient)
                                        .font(.caption)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(Color.blue.opacity(0.1))
                                        .foregroundColor(.blue)
                                        .clipShape(Capsule())
                                }
                            }
                        }
                        HStack(spacing: 16) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Category")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                HStack(spacing: 4) {
                                    Image(systemName: foodItem.category.icon)
                                    Text(foodItem.category.rawValue)
                                }
                                .font(.subheadline)
                                .fontWeight(.medium)
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .trailing, spacing: 4) {
                                Text("Status")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                
                                HStack(spacing: 4) {
                                    Circle()
                                        .fill(foodItem.isAvailable ? Color.green : Color.red)
                                        .frame(width: 8, height: 8)
                                    Text(foodItem.isAvailable ? "Available" : "Unavailable")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .foregroundColor(foodItem.isAvailable ? .green : .red)
                                }
                            }
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
        .alert("Added to Cart!", isPresented: $showingAddedToCart) {
            Button("OK") { }
        } message: {
            Text("\(quantity) \(foodItem.name) added to your cart.")
        }
    }
}

struct OrderHistoryView: View {
    @ObservedObject var canteenModel: CanteenModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.gray.opacity(0.05).ignoresSafeArea()
                
                if canteenModel.orderHistory.isEmpty {
                    emptyHistoryView
                } else {
                    orderHistoryList
                }
            }
            .navigationTitle("Order History")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private var emptyHistoryView: some View {
        VStack(spacing: 20) {
            Image(systemName: "clock.arrow.circlepath")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("No order history")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.gray)
            
            Text("Your completed orders will appear here.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
    }
    
    private var orderHistoryList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(canteenModel.orderHistory.sorted(by: { $0.timestamp > $1.timestamp })) { order in
                    OrderHistoryCard(order: order)
                }
            }
            .padding()
        }
    }
}

struct OrderHistoryCard: View {
    let order: Order
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Order #\(order.orderNumber.suffix(6))")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text(order.timestamp, style: .date)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text(order.formattedTotalAmount)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                    
                    HStack(spacing: 4) {
                        Image(systemName: order.status.icon)
                            .foregroundColor(Color(order.status.color))
                        Text(order.status.rawValue)
                            .font(.caption)
                            .foregroundColor(Color(order.status.color))
                    }
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color(order.status.color).opacity(0.1))
                    .clipShape(Capsule())
                }
            }
            
            Text("\(order.totalItems) items • \(order.studentName)")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            if isExpanded {
                Divider()
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Order Items:")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    
                    ForEach(order.items) { item in
                        HStack {
                            Text(item.foodItem.name)
                                .font(.subheadline)
                            Spacer()
                            Text("×\(item.quantity)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Text(item.formattedTotalPrice)
                                .font(.subheadline)
                                .fontWeight(.medium)
                        }
                    }
                }
            }
            
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    Text(isExpanded ? "Show Less" : "Show Details")
                        .font(.caption)
                        .foregroundColor(.blue)
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.caption)
                        .foregroundColor(.blue)
                }
            }
        }
        .padding()
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 1)
    }
}
