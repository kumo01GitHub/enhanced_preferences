import Foundation

public class CipherData {
    public let data: Data
    public let key: Data

    public init(data: Data, key: Data) {
        self.data = data
        self.key = key
    }
}
