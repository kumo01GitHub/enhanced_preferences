import CryptoKit
import Foundation

public class CryptoHandler {
    private static let kAlgorithm: SecKeyAlgorithm = .rsaEncryptionOAEPSHA512
    private static let kTag = (Bundle.main.bundleIdentifier! + ".FEPKeystore").data(
        using: .utf8)!
    private static let kPublicKey: String = "FEPPublicKey"
    private static let kPrivateKey: String = "FEPPrivateKey"

    public static func encrypt(plain: Data) throws -> CryptoData {
        let key = SymmetricKey(size: .bits256)
        let nonce = AES.GCM.Nonce()
        let sealedBox = try AES.GCM.seal(plain, using: key, nonce: nonce)
        return CryptoData(data: sealedBox.combined!, key: try encryptKey(key: key.withUnsafeBytes { body in Data(body) }))
    }

    public static func decrypt(encrypted: CryptoData) throws -> Data? {
        let key = SymmetricKey(data: try decryptKey(encryptedKey: encrypted.key))
        let sealedBox = try AES.GCM.SealedBox(combined: encrypted.data)
        return try AES.GCM.open(sealedBox, using: key)
    }

    private static func encryptKey(key: Data) throws -> Data {
        var error: Unmanaged<CFError>?

        let publicKey = SecKeyCopyPublicKey(try getMasterKey())!

        guard SecKeyIsAlgorithmSupported(publicKey, .encrypt, kAlgorithm) else {
            throw error!.takeRetainedValue() as Error
        }
        guard key.count < (SecKeyGetBlockSize(publicKey) - 130) else {
            throw error!.takeRetainedValue() as Error
        }

        guard
            let encryptedKey = SecKeyCreateEncryptedData(
                publicKey,
                .rsaEncryptionOAEPSHA512,
                key as CFData,
                &error
            ) as Data?
        else {
            throw error!.takeRetainedValue() as Error
        }

        return encryptedKey
    }

    private static func decryptKey(encryptedKey: Data) throws -> Data {
        var error: Unmanaged<CFError>?

        let privateKey = try getMasterKey()

        guard SecKeyIsAlgorithmSupported(privateKey, .decrypt, kAlgorithm) else {
            throw error!.takeRetainedValue() as Error
        }
        guard encryptedKey.count == SecKeyGetBlockSize(privateKey) else {
            throw error!.takeRetainedValue() as Error
        }

        guard
            let decryptedKey = SecKeyCreateDecryptedData(
                privateKey,
                kAlgorithm,
                encryptedKey as CFData,
                &error
            ) as Data?
        else {
            throw error!.takeRetainedValue() as Error
        }

        return decryptedKey
    }

    private static func getMasterKey() throws -> SecKey {
        let query: [String: Any] = [
            kSecClass as String: kSecClassKey,
            kSecAttrApplicationTag as String: kTag,
            kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
            kSecReturnRef as String: true,
        ]

        var key: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &key)

        if status == errSecSuccess {
            return key as! SecKey
        } else {
            let attributes: [String: Any] = [
                kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
                kSecAttrKeySizeInBits as String: 2048,
                kSecPrivateKeyAttrs as String: [
                    kSecAttrIsPermanent as String: true,
                    kSecAttrApplicationTag as String: kTag,
                ],
            ]
            var error: Unmanaged<CFError>?
            guard
                let generatedPrivateKey = SecKeyCreateRandomKey(attributes as CFDictionary, &error)
            else {
                throw error!.takeRetainedValue() as Error
            }
            return generatedPrivateKey
        }
    }
}
