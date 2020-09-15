import Foundation

func createF<T>(_ completion: () -> T) -> T {
    return completion()
}
