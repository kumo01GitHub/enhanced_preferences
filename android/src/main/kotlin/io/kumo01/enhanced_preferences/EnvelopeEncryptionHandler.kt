package io.kumo01.enhanced_preferences

import android.content.Context
import android.security.keystore.KeyGenParameterSpec
import android.security.keystore.KeyProperties
import java.security.Key
import java.security.KeyPairGenerator
import java.security.KeyStore
import java.security.PublicKey
import java.security.spec.MGF1ParameterSpec
import javax.crypto.Cipher
import javax.crypto.spec.OAEPParameterSpec
import javax.crypto.spec.PSource

class EnvelopeEncryptionHandler(context: Context) {
    companion object {
        private const val KEY_PREFIX: String = "FEPMasterKey@"
        private const val KEY_STORE_PROVIDER: String = "AndroidKeyStore"
        private const val TRANSFORMATION: String = "RSA/ECB/OAEPwithSHA-256andMGF1Padding"
        private const val KEY_SIZE: Int = 2048
    }

    private val keyStore: KeyStore by lazy {
        KeyStore.getInstance(KEY_STORE_PROVIDER).apply { load(null) }
    }
    private val cipher: Cipher by lazy { Cipher.getInstance(TRANSFORMATION) }
    private val masterKeyAlias: String = "${KEY_PREFIX}${context.packageName}"

    private fun getPublicKey(): PublicKey {
        if (keyStore.containsAlias(masterKeyAlias)) {
            return keyStore.getCertificate(masterKeyAlias).publicKey
        } else {
            val kpg: KeyPairGenerator =
                    KeyPairGenerator.getInstance(
                            KeyProperties.KEY_ALGORITHM_RSA,
                            KEY_STORE_PROVIDER
                    )

            val parameterSpec: KeyGenParameterSpec =
                    KeyGenParameterSpec.Builder(
                                    this.masterKeyAlias,
                                    KeyProperties.PURPOSE_ENCRYPT or KeyProperties.PURPOSE_DECRYPT
                            )
                            .run {
                                setBlockModes(KeyProperties.BLOCK_MODE_ECB)
                                setEncryptionPaddings(KeyProperties.ENCRYPTION_PADDING_RSA_OAEP)
                                setDigests(KeyProperties.DIGEST_SHA256)
                                setKeySize(KEY_SIZE)
                                build()
                            }

            kpg.initialize(parameterSpec)
            return kpg.generateKeyPair().public
        }
    }

    private fun getPrivateKey(): Key {
        return this.keyStore.getKey(masterKeyAlias, null)
    }

    fun encrypt(dataKey: ByteArray): ByteArray {
        return synchronized(this.cipher) {
            this.cipher
                    .apply {
                        init(
                                Cipher.ENCRYPT_MODE,
                                getPublicKey(),
                                OAEPParameterSpec(
                                        "SHA-256",
                                        "MGF1",
                                        MGF1ParameterSpec.SHA1,
                                        PSource.PSpecified.DEFAULT
                                )
                        )
                    }
                    .run { this.doFinal(dataKey) }
        }
    }

    fun decrypt(encryptedKey: ByteArray): ByteArray {
        return synchronized(this.cipher) {
            this.cipher
                    .apply {
                        init(
                                Cipher.DECRYPT_MODE,
                                getPrivateKey(),
                                OAEPParameterSpec(
                                        "SHA-256",
                                        "MGF1",
                                        MGF1ParameterSpec.SHA1,
                                        PSource.PSpecified.DEFAULT
                                )
                        )
                    }
                    .run { this.doFinal(encryptedKey) }
        }
    }
}
