import Foundation
import Thrift

// https://www.raywenderlich.com/3437391-real-time-communication-with-streams-tutorial-for-ios

final class TTCPStream: NSObject, TTransport, StreamDelegate {
    private let inputStream: InputStream!
    private let outputStream: OutputStream!
    
    init(hostname: String, port: UInt32) {
        var readStream: Unmanaged<CFReadStream>?
        var writeStream: Unmanaged<CFWriteStream>?
        
        CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault,
                                           hostname as CFString,
                                           port,
                                           &readStream,
                                           &writeStream)
        
        inputStream = readStream?.takeRetainedValue()
        outputStream = writeStream?.takeRetainedValue()
        
        inputStream.schedule(in: .current, forMode: .common)
        outputStream.schedule(in: .current, forMode: .common)
        
        inputStream.open()
        outputStream.open()
        
        super.init()
    }
    
    deinit {
        close()
    }
    
    func close() {
        inputStream.close()
        outputStream.close()
    }
    
    private var inputstreambytesavailable = false
    
    func read(size: Int) throws -> Data {
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: size)
        let numberOfBytesRead = inputStream.read(buffer, maxLength: size)
        if numberOfBytesRead < 0 {
            throw NSError(
                domain: "\(Self.self)",
                code: -1,
                userInfo: [
                    NSLocalizedFailureReasonErrorKey:
                    "Number of bytes \(numberOfBytesRead)"
            ])
        }
        return Data(bytes: UnsafeRawPointer(buffer),
                    count: numberOfBytesRead)
        
    }
    
    func write(data: Data) throws {
        _ = try data.withUnsafeBytes {
            guard let pointer = $0.baseAddress?.assumingMemoryBound(to: UInt8.self) else {
                throw NSError(
                    domain: "\(self)",
                    code: 1,
                    userInfo: [
                        NSLocalizedFailureReasonErrorKey:
                        "Error writing data"
                ])
            }
            outputStream.write(pointer, maxLength: data.count)
        }
    }
    
    func flush() throws {
        
    }
}