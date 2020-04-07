import Foundation

public extension DateFormatter {
    @nonobjc static let customDateFormatter: DateFormatter = {
          let formatter = DateFormatter()
          formatter.dateFormat = "dd MMM YYYY"
          
          return formatter
      }()
}
