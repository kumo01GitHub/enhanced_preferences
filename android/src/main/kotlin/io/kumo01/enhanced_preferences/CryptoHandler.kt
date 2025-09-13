package io.kumo01.enhanced_preferences

import android.content.Context
import java.security.GeneralSecurityException
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
        private const val ENCRYPTED_KEYS_SIZE = 256
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

    fun encrypt(plain: ByteArray): ByteArray? {
        val key = generateKey()
        val iv = generateIv()

        return synchronized(this.cipher) {
            this.cipher.init(Cipher.ENCRYPT_MODE, key, GCMParameterSpec(GCM_TAG_LENGTH, iv))
            envelopeEncryptionHandler.encrypt(key.encoded).plus(iv).plus(cipher.doFinal(plain))
        }
    }

    fun decrypt(encrypted: ByteArray): ByteArray? {
        val key =
            SecretKeySpec(
                envelopeEncryptionHandler.decrypt(
                    encrypted.sliceArray(0..ENCRYPTED_KEYS_SIZE - 1)
                ),
                ALGORITHM
            )
        val iv = encrypted.sliceArray(ENCRYPTED_KEYS_SIZE..ENCRYPTED_KEYS_SIZE + IV_LENGTH - 1)
        val data = encrypted.sliceArray(ENCRYPTED_KEYS_SIZE + IV_LENGTH..encrypted.size - 1)

        return synchronized(this.cipher) {
            this.cipher.init(Cipher.DECRYPT_MODE, key, GCMParameterSpec(GCM_TAG_LENGTH, iv))
            this.cipher.doFinal(data)
        }
    }
}
