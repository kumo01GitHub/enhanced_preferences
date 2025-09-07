package io.kumo01.enhanced_preferences

import android.content.Context
import android.util.Base64
import com.google.crypto.tink.Aead
import com.google.crypto.tink.KeyTemplates
import com.google.crypto.tink.RegistryConfiguration
import com.google.crypto.tink.aead.AeadConfig
import com.google.crypto.tink.integration.android.AndroidKeysetManager
import kotlinx.coroutines.runBlocking

const val SUFFIX = "_FlutterEnhancedPreferences"

class CryptoHandler(context: Context) {
    private val aead: Aead

    init {
        AeadConfig.register()
        val name = Base64.encodeToString("${context.packageName}$SUFFIX".toByteArray(), Base64.DEFAULT)
        aead = AndroidKeysetManager.Builder()
            .withKeyTemplate(KeyTemplates.get("AES256_GCM"))
            .withMasterKeyUri("android-keystore://$name")
            .withSharedPref(context, name, name)
            .build()
            .keysetHandle
            .getPrimitive(RegistryConfiguration.get(), Aead::class.java)
    }

    fun encrypt(plain: ByteArray): ByteArray? {
        return runBlocking {
            aead.encrypt(plain, null)
        }
    }

    fun decrypt(encrypted: ByteArray): ByteArray? {
        return runBlocking {
            aead.decrypt(encrypted, null)
        }
    }
}
