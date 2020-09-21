import Foundation
import Thrift

final class TMDBThrift {
    static let shared = TMDBThrift()
    private init() {}
    
    private lazy var ttransport = TTCPStream(
        hostname: "192.168.1.2",
        port: 9900
    )

    private lazy var tprotocol = TBinaryProtocol(on: ttransport)
    
    func createClient<T: TClient>(_ type: T.Type) -> T {
        return T(inoutProtocol: tprotocol)
    }
}
