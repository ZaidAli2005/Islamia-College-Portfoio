//
//  CanteenModel.swift
//  Islamia College Portfolio
//
//  Created by Development on 18/06/2025.
//

import Foundation

struct FoodItem: Identifiable, Codable {
    var id = UUID()
    let name: String
    let description: String
    let price: Double
    let category: FoodCategory
    let imageName: String
    let isAvailable: Bool
    let preparationTime: Int
    let rating: Double
    let ingredients: [String]
    
    var formattedPrice: String {
        return String(format: "₨%.0f", price)
    }
}

enum FoodCategory: String, CaseIterable, Codable {
    case coldDrinks = "Cold Drinks"
    case fastFoods = "Fast Foods"
    case desserts = "Desserts"
    case lays = "Lays"
    
    var icon: String {
        switch self {
        case .coldDrinks: return "cup.and.saucer.fill"
        case .fastFoods: return "flame.fill"
        case .desserts: return "birthday.cake.fill"
        case .lays: return "mug.fill"
        }
    }
    
    var color: String {
        switch self {
        case .coldDrinks: return "blue"
        case .fastFoods: return "red"
        case .desserts: return "pink"
        case .lays: return "teal"
        }
    }
}

struct OrderItem: Identifiable, Codable {
    var id = UUID()
    let foodItem: FoodItem
    var quantity: Int
    let timestamp: Date
    
    var totalPrice: Double {
        return foodItem.price * Double(quantity)
    }
    
    var formattedTotalPrice: String {
        return String(format: "₨%.0f", totalPrice)
    }
}

enum OrderStatus: String, CaseIterable, Codable {
    case pending = "Pending"
    case preparing = "Preparing"
    case ready = "Ready"
    case completed = "Completed"
    case cancelled = "Cancelled"
    
    var color: String {
        switch self {
        case .pending: return "orange"
        case .preparing: return "blue"
        case .ready: return "green"
        case .completed: return "gray"
        case .cancelled: return "red"
        }
    }
    
    var icon: String {
        switch self {
        case .pending: return "clock.fill"
        case .preparing: return "flame.fill"
        case .ready: return "checkmark.circle.fill"
        case .completed: return "checkmark.seal.fill"
        case .cancelled: return "xmark.circle.fill"
        }
    }
}

struct Order: Identifiable, Codable {
    var id = UUID()
    let orderNumber: String
    let items: [OrderItem]
    let timestamp: Date
    var status: OrderStatus
    let studentName: String
    let studentId: String
    
    var totalAmount: Double {
        return items.reduce(0) { $0 + $1.totalPrice }
    }
    
    var formattedTotalAmount: String {
        return String(format: "₨%.0f", totalAmount)
    }
    
    var totalItems: Int {
        return items.reduce(0) { $0 + $1.quantity }
    }
    
    var estimatedTime: Int {
        let maxTime = items.map { $0.foodItem.preparationTime }.max() ?? 0
        return maxTime + (items.count * 2)
    }
}

class CanteenModel: ObservableObject {
    @Published var foodItems: [FoodItem] = []
    @Published var currentOrders: [Order] = []
    @Published var orderHistory: [Order] = []
    @Published var selectedCategory: FoodCategory = .coldDrinks
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    @Published var cart: [OrderItem] = []
    
    init() {
        loadSampleData()
    }
    
    var filteredFoodItems: [FoodItem] {
        let categoryFiltered = foodItems.filter { $0.category == selectedCategory }
        
        if searchText.isEmpty {
            return categoryFiltered
        } else {
            return categoryFiltered.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.description.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var cartTotal: Double {
        return cart.reduce(0) { $0 + $1.totalPrice }
    }
    
    var cartTotalFormatted: String {
        return String(format: "₨%.0f", cartTotal)
    }
    
    var cartItemCount: Int {
        return cart.reduce(0) { $0 + $1.quantity }
    }
    
    func addToCart(_ foodItem: FoodItem, quantity: Int = 1) {
        if let existingIndex = cart.firstIndex(where: { $0.foodItem.id == foodItem.id }) {
            cart[existingIndex].quantity += quantity
        } else {
            let orderItem = OrderItem(foodItem: foodItem, quantity: quantity, timestamp: Date())
            cart.append(orderItem)
        }
    }
    
    func removeFromCart(_ orderItem: OrderItem) {
        cart.removeAll { $0.id == orderItem.id }
    }
    
    func updateCartItemQuantity(_ orderItem: OrderItem, newQuantity: Int) {
        if let index = cart.firstIndex(where: { $0.id == orderItem.id }) {
            if newQuantity <= 0 {
                cart.remove(at: index)
            } else {
                cart[index].quantity = newQuantity
            }
        }
    }
    
    func clearCart() {
        cart.removeAll()
    }
    
    func placeOrder(studentName: String, studentId: String) {
        guard !cart.isEmpty else { return }
        
        let orderNumber = "ORD-\(Date().timeIntervalSince1970)"
        let newOrder = Order(
            orderNumber: orderNumber,
            items: cart,
            timestamp: Date(),
            status: .pending,
            studentName: studentName,
            studentId: studentId
        )
        
        currentOrders.append(newOrder)
        clearCart()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.updateOrderStatus(newOrder.id, to: .preparing)
        }
    }
    
    func updateOrderStatus(_ orderId: UUID, to status: OrderStatus) {
        if let index = currentOrders.firstIndex(where: { $0.id == orderId }) {
            currentOrders[index].status = status
            
            if status == .completed {
                let completedOrder = currentOrders.remove(at: index)
                orderHistory.append(completedOrder)
            }
        }
    }
    
    private func loadSampleData() {
        foodItems = [
            FoodItem(name: "Coca Cola", description: "Chilled Coca Cola bottle", price: 25, category: .coldDrinks, imageName: "coca_cola", isAvailable: true, preparationTime: 2, rating: 4.2, ingredients: ["Regular", "Half Liter", "Liter"]),
            FoodItem(name: "Pepsi", description: "Ice cold Pepsi bottle", price: 25, category: .coldDrinks, imageName: "pepsi", isAvailable: true, preparationTime: 2, rating: 4.1, ingredients: ["Regular", "Half Liter", "Liter"]),
            FoodItem(name: "Sprite", description: "Refreshing lemon-lime soda", price: 25, category: .coldDrinks, imageName: "sprite", isAvailable: true, preparationTime: 2, rating: 4.0, ingredients: ["Regular", "Half Liter", "Liter"]),
            FoodItem(name: "Fanta", description: "Orange flavored fizzy drink", price: 25, category: .coldDrinks, imageName: "fanta", isAvailable: true, preparationTime: 2, rating: 3.9, ingredients: ["Regular", "Half Liter", "Liter"]),
            FoodItem(name: "7UP", description: "Crisp lemon-lime soda", price: 25, category: .coldDrinks, imageName: "7up", isAvailable: true, preparationTime: 2, rating: 4.0, ingredients: ["Regular", "Half Liter", "Liter"]),
            FoodItem(name: "Dew", description: "Energizing citrus soda", price: 30, category: .coldDrinks, imageName: "mountain_dew", isAvailable: true, preparationTime: 2, rating: 4.3, ingredients: ["Regular", "Half Liter", "Liter"]),
            
            FoodItem(name: "Chicken Burger", description: "Juicy chicken burger with fries", price: 80, category: .fastFoods, imageName: "chicken_burger", isAvailable: true, preparationTime: 15, rating: 4.7, ingredients: ["Chicken patty", "Bun", "Lettuce", "Tomato", "Sauce"]),
            FoodItem(name: "Beef Burger", description: "Classic beef burger with cheese", price: 90, category: .fastFoods, imageName: "beef_burger", isAvailable: true, preparationTime: 15, rating: 4.8, ingredients: ["Beef patty", "Cheese", "Bun", "Pickles", "Sauce"]),
            FoodItem(name: "French Fries", description: "Crispy golden french fries", price: 30, category: .fastFoods, imageName: "french_fries", isAvailable: true, preparationTime: 8, rating: 4.4, ingredients: ["Potatoes", "Oil", "Salt"]),
            FoodItem(name: "Chicken Wings", description: "Spicy chicken wings (6 pieces)", price: 70, category: .fastFoods, imageName: "chicken_wings", isAvailable: true, preparationTime: 18, rating: 4.5, ingredients: ["Chicken wings", "Spices", "Hot sauce"]),
            FoodItem(name: "Pizza Slice", description: "Cheesy pizza slice", price: 45, category: .fastFoods, imageName: "pizza_slice", isAvailable: true, preparationTime: 10, rating: 4.3, ingredients: ["Pizza dough", "Cheese", "Tomato sauce", "Toppings"]),
            FoodItem(name: "Hot Dog", description: "Grilled hot dog with mustard", price: 35, category: .fastFoods, imageName: "hot_dog", isAvailable: true, preparationTime: 8, rating: 4.1, ingredients: ["Sausage", "Bun", "Mustard", "Ketchup"]),
            FoodItem(name: "Chicken Nuggets", description: "Crispy chicken nuggets (8 pieces)", price: 55, category: .fastFoods, imageName: "chicken_nuggets", isAvailable: true, preparationTime: 12, rating: 4.4, ingredients: ["Chicken", "Breadcrumbs", "Spices"]),
            
            FoodItem(name: "Kheer", description: "Sweet rice pudding with nuts", price: 30, category: .desserts, imageName: "kheer", isAvailable: true, preparationTime: 8, rating: 4.5, ingredients: ["Rice", "Milk", "Sugar", "Almonds"]),
            FoodItem(name: "Gulab Jamun", description: "Sweet milk balls in syrup (2 pieces)", price: 25, category: .desserts, imageName: "gulab_jamun", isAvailable: true, preparationTime: 5, rating: 4.6, ingredients: ["Milk powder", "Sugar syrup", "Cardamom"]),
            FoodItem(name: "Ras Malai", description: "Soft cheese balls in sweet milk (2 pieces)", price: 35, category: .desserts, imageName: "ras_malai", isAvailable: true, preparationTime: 8, rating: 4.7, ingredients: ["Cottage cheese", "Milk", "Sugar", "Pistachios"]),
            FoodItem(name: "Jalebi", description: "Crispy orange spirals in sugar syrup", price: 20, category: .desserts, imageName: "jalebi", isAvailable: true, preparationTime: 10, rating: 4.3, ingredients: ["Flour", "Sugar syrup", "Food color"]),
            FoodItem(name: "Ice Cream", description: "Vanilla ice cream scoop", price: 40, category: .desserts, imageName: "ice_cream", isAvailable: true, preparationTime: 3, rating: 4.4, ingredients: ["Cream", "Sugar", "Vanilla"]),
            FoodItem(name: "Chocolate Cake", description: "Rich chocolate cake slice", price: 50, category: .desserts, imageName: "chocolate_cake", isAvailable: true, preparationTime: 5, rating: 4.8, ingredients: ["Chocolate", "Flour", "Sugar", "Cream"]),
            
            FoodItem(name: "Masala", description: "Hot milk tea with cardamom", price: 8, category: .lays, imageName: "chai", isAvailable: true, preparationTime: 5, rating: 4.7, ingredients: ["Tea", "Milk", "Sugar", "Cardamom"]),
            FoodItem(name: "Yougert", description: "Fresh brewed coffee", price: 15, category: .lays, imageName: "coffee", isAvailable: true, preparationTime: 5, rating: 4.3, ingredients: ["Coffee beans", "Hot water", "Sugar"]),
            FoodItem(name: "Paprika", description: "Healthy green tea", price: 12, category: .lays, imageName: "green_tea", isAvailable: true, preparationTime: 4, rating: 4.1, ingredients: ["Green tea leaves", "Hot water"]),
            FoodItem(name: "French Cheese", description: "Sweet yogurt drink", price: 25, category: .lays, imageName: "lassi", isAvailable: true, preparationTime: 5, rating: 4.5, ingredients: ["Yogurt", "Sugar", "Cardamom"])
        ]
    }
}
