import Foundation
import SwiftyJSON

func += (lhs: inout [JSON], rhs: [String:Any]) {
    lhs.append(JSON(rhs))
}

func += (lhs: inout JSON, rhs: [String:Any]) {
    for (k, v) in rhs {
        lhs[k] = JSON(v)
    }
}
