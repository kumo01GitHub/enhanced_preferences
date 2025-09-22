package io.kumo01.enhanced_preferences

import android.content.Context
import java.security.SecureRandom
import javax.crypto.Cipher
import javax.crypto.KeyGenerator
import javax.crypto.SecretKey
import javax.crypto.spec.GCMParameterSpec
import javax.crypto.spec.SecretKeySpec

class CryptoHandler(context: Context) {
    companion object {
        private const val ALGORITHM = "AES"
        private const val TRANSFORMATION = "${ALGORITHM}/GCM/NoPadding"
        private const val KEY_SIZE = 256
        private const val IV_LENGTH = 16
        private const val GCM_TAG_LENGTH = 128
    }

    private val cipher: Cipher by lazy { Cipher.getInstance(TRANSFORMATION) }
    private val envelopeEncryptionHandler: EnvelopeEncryptionHandler =
            EnvelopeEncryptionHandler(context)

    private fun generateKey(): SecretKey {
        val keyGenerator: KeyGenerator = KeyGenerator.getInstance(ALGORITHM)
        keyGenerator.init(KEY_SIZE)
        return keyGenerator.generateKey()
    }

    private fun generateIv(): ByteArray {
        val iv = ByteArray(IV_LENGTH)
        val secureRandom = SecureRandom()
        secureRandom.nextBytes(iv)
        return iv
    }

    fun encrypt(plain: ByteArray): CryptoData {
        val key = generateKey()
        val iv = generateIv()

        return synchronized(this.cipher) {
            this.cipher.init(
                Cipher.ENCRYPT_MODE,
                key,
                GCMParameterSpec(GCM_TAG_LENGTH, iv)
            )
            CryptoData(
                cipher.doFinal(plain),
                envelopeEncryptionHandler.encrypt(key.encoded),
                iv
            )
        }
    }

    fun decrypt(encrypted: CryptoData): ByteArray {
        val key =
            SecretKeySpec(
                envelopeEncryptionHandler.decrypt(encrypted.key),
                ALGORITHM
            )
        val param = GCMParameterSpec(GCM_TAG_LENGTH, encrypted.iv)

        return synchronized(this.cipher) {
            this.cipher.init(Cipher.DECRYPT_MODE, key, param)
            this.cipher.doFinal(encrypted.data)
        }
    }
}

class CryptoData (
    val data: ByteArray,
    val key: ByteArray,
    val iv: ByteArray
)
