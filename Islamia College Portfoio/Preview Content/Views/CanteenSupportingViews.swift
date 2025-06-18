//
//  CanteenSupportingViews.swift
//  Islamia College Portfolio
//
//  Created by Development on 17/06/2025.
//

import SwiftUI

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
