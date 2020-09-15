import Foundation
import SwiftyJSON

extension Array where Element == JSON {
    subscript(getIndex key: String, value: Any) -> Index? {
        firstIndex(where: { $0[key] == JSON(value) })
    }
    
    mutating func mustGetIndex(_ key: String, _ value: Any) -> Index {
        if let idx = self[getIndex: key, value] {
            return idx
        } else {
            self += [key: JSON(value)]
            return self[getIndex: key, value]!
        }
    }
}
