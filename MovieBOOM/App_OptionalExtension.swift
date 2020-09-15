import Foundation

extension Optional {
    func `do`(_ completion: (Wrapped) -> Void) {
        switch self {
        case .none: break
        case .some(let value):
            completion(value)
        }
    }
}
