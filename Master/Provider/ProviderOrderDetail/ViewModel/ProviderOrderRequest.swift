import Foundation

struct ProviderOrderRequest: Codable {
    let orderId: Int
    let state: Int
    var extraPrice: Double
    let extraDescription: String
}
