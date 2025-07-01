//
//  CanteenView.swift
//  Islamia College Portfolio
//
//  Created by Development on 17/06/2025.
//

import SwiftUI

struct CanteenView: View {
    @StateObject private var canteenModel = CanteenModel()
    @State private var showingCart = false
    @State private var showingOrderHistory = false
    @State private var selectedFoodItem: FoodItem?
    @State private var animateCategories = false
    @State private var showingStudentForm = false
    @State private var studentName = ""
    @State private var studentId = ""
    @State private var showFullMenu = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    headerSection
                    featuredSection
                    categoriesSection
                    popularItemsSection
                    if showFullMenu {
                        menuSection
                    }
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarTitleDisplayMode(.large)
            .sheet(item: $selectedFoodItem) { foodItem in
                FoodDetailView(foodItem: foodItem, canteenModel: canteenModel)
            }
        }
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Welcome back! 👋")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text("What's for today?")
                        .font(.title2)
                        .fontWeight(.bold)
                }
                
                Spacer()
                
                HStack(spacing: 4) {
                    Text("Open until 5 PM")
                        .font(.caption)
                        .foregroundColor(.accentColor)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .clipShape(Capsule())
                }
            }
        }
        .padding()
        .background(Color.white)
    }
    
    private var featuredSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Featured Today")
                .font(.title3)
                .fontWeight(.semibold)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.orange.opacity(0.2))
                        .frame(width: 280, height: 140)
                        .overlay(
                            VStack {
                                Image(systemName: "building.2")
                                    .font(.system(size: 30))
                                    .foregroundColor(.orange)
                                Text("Cozy Dining")
                                    .font(.caption)
                                    .foregroundColor(.orange)
                            }
                        )
                    
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.brown.opacity(0.2))
                        .frame(width: 200, height: 140)
                        .overlay(
                            VStack {
                                Image(systemName: "cup.and.saucer")
                                    .font(.system(size: 30))
                                    .foregroundColor(.brown)
                                Text("Fresh Coffee")
                                    .font(.caption)
                                    .foregroundColor(.brown)
                            }
                        )
                }
                .padding(.horizontal)
            }
        }
        .padding(.vertical)
        .background(Color.white)
    }
    
    private var categoriesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Categories")
                .font(.title3)
                .fontWeight(.semibold)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    CategorysButton(
                        title: "Cold Drinks",
                        isSelected: canteenModel.selectedCategory == .coldDrinks
                    ) {
                        canteenModel.selectedCategory = .coldDrinks
                    }
                    
                    CategorysButton(
                        title: "Fast Foods",
                        isSelected: canteenModel.selectedCategory == .fastFoods
                    ) {
                        canteenModel.selectedCategory = .fastFoods
                    }
                    
                    CategorysButton(
                        title: "Desserts",
                        isSelected: canteenModel.selectedCategory == .desserts
                    ) {
                        canteenModel.selectedCategory = .desserts
                    }
                    
                    CategorysButton(
                        title: "Lays",
                        isSelected: canteenModel.selectedCategory == .snacks
                    ) {
                        canteenModel.selectedCategory = .snacks
                    }
                    
                    CategorysButton(
                        title: "More",
                        isSelected: canteenModel.selectedCategory == .beverages
                    ) {
                        canteenModel.selectedCategory = .beverages
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.vertical)
        .background(Color.white)
    }
    
    private var popularItemsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                HStack(spacing: 4) {
                    Text("Popular Items")
                        .font(.title3)
                        .fontWeight(.semibold)
                    Image(systemName: "flame.fill")
                        .foregroundColor(.orange)
                        .font(.caption)
                }
                
                Spacer()
                
                Button(showFullMenu ? "Show Less" : "See All") {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        showFullMenu.toggle()
                    }
                }
                .font(.subheadline)
                .foregroundColor(.blue)
            }
            .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(canteenModel.filteredFoodItems.prefix(5)) { item in
                        PopularItemCard(foodItem: item) {
                            selectedFoodItem = item
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.vertical)
        .background(Color.white)
    }
    
    private var menuSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("Menu")
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Text("\(canteenModel.filteredFoodItems.count) items")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color.white)
            
            LazyVStack(spacing: 0) {
                ForEach(canteenModel.filteredFoodItems) { item in
                    MenuItemRow(foodItem: item) {
                        selectedFoodItem = item
                    }
                    
                    if item.id != canteenModel.filteredFoodItems.last?.id {
                        Divider()
                            .padding(.leading, 80)
                    }
                }
            }
            .background(Color.white)
        }
    }
}

struct CategorysButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color.accentColor : Color(.systemGray6))
                .foregroundColor(isSelected ? .white : .primary)
                .clipShape(Capsule())
        }
    }
}

struct PopularItemCard: View {
    let foodItem: FoodItem
    let onTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.orange.opacity(0.2))
                .frame(width: 120, height: 80)
                .overlay(
                    Image(systemName: "fork.knife")
                        .font(.title2)
                        .foregroundColor(.orange)
                )
            
            VStack(alignment: .leading, spacing: 2) {
                Text(foodItem.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .lineLimit(1)
                
                HStack(spacing: 2) {
                    Image(systemName: "star.fill")
                        .font(.caption2)
                        .foregroundColor(.yellow)
                    Text(String(format: "%.1f", foodItem.rating))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Text(foodItem.formattedPrice)
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }
        }
        .frame(width: 120)
        .onTapGesture(perform: onTap)
    }
}

struct MenuItemRow: View {
    let foodItem: FoodItem
    let onTap: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.orange.opacity(0.2))
                .frame(width: 60, height: 60)
                .overlay(
                    Image(systemName: "fork.knife")
                        .foregroundColor(.orange)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(foodItem.name)
                        .font(.headline)
                        .fontWeight(.medium)
                    
                    Spacer()
                    
                    Text("In Stock")
                        .font(.caption)
                        .foregroundColor(.green)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(Color.green.opacity(0.1))
                        .clipShape(Capsule())
                }
                
                Text(foodItem.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                HStack {
                    HStack(spacing: 2) {
                        Image(systemName: "star.fill")
                            .font(.caption)
                            .foregroundColor(.yellow)
                        Text(String(format: "%.1f", foodItem.rating))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Circle()
                        .fill(Color.secondary)
                        .frame(width: 3, height: 3)
                    
                    Text("Available")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Image(systemName: "leaf.fill")
                        .font(.caption)
                        .foregroundColor(.green)
                    
                    Spacer()
                    
                    Text(foodItem.formattedPrice)
                        .font(.headline)
                        .fontWeight(.semibold)
                }
            }
        }
        .padding()
        .background(Color.white)
        .onTapGesture(perform: onTap)
    }
}

#Preview {
    CanteenView()
}
