package io.kumo01.enhanced_preferences

import android.content.Context
import androidx.datastore.core.DataStore
import androidx.datastore.preferences.core.Preferences
import androidx.datastore.preferences.core.byteArrayPreferencesKey
import androidx.datastore.preferences.core.edit
import androidx.datastore.preferences.preferencesDataStore
import java.nio.ByteBuffer
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.map

const val ENHANCED_PREFERENCES_NAME = "FlutterEnhancedPreferences"
val Context.dataStore: DataStore<Preferences> by preferencesDataStore(ENHANCED_PREFERENCES_NAME)

/** EnhancedPreferencesRepository */
class EnhancedPreferencesRepository(context: Context) {
    private val dataStore: DataStore<Preferences> = context.applicationContext.dataStore
    private val cryptoHandler: CryptoHandler = CryptoHandler(context)

    fun getString(key: String): Flow<String?> {
        return this.dataStore.data.map { preferences: Preferences ->
            val bytes = preferences[byteArrayPreferencesKey(key)]
            if (bytes == null) {
                null
            } else {
                String(bytes, Charsets.UTF_8)
            }
        }
    }

    suspend fun setString(key: String, value: String) {
        this.dataStore.edit { preferences ->
            preferences[byteArrayPreferencesKey(key)] = value.toByteArray(Charsets.UTF_8)
        }
    }

    fun getInt(key: String): Flow<Int?> {
        return this.dataStore.data.map { preferences: Preferences ->
            val bytes = preferences[byteArrayPreferencesKey(key)]
            if (bytes == null) {
                null
            } else {
                ByteBuffer.wrap(bytes).int
            }
        }
    }

    suspend fun setInt(key: String, value: Int) {
        this.dataStore.edit { preferences ->
            preferences[byteArrayPreferencesKey(key)] =
                    ByteBuffer.allocate(Int.SIZE_BYTES).putInt(value).array()
        }
    }

    fun getDouble(key: String): Flow<Double?> {
        return this.dataStore.data.map { preferences: Preferences ->
            val bytes = preferences[byteArrayPreferencesKey(key)]
            if (bytes == null) {
                null
            } else {
                ByteBuffer.wrap(bytes).double
            }
        }
    }

    suspend fun setDouble(key: String, value: Double) {
        this.dataStore.edit { preferences ->
            preferences[byteArrayPreferencesKey(key)] =
                    ByteBuffer.allocate(Double.SIZE_BYTES).putDouble(value).array()
        }
    }

    fun getBoolean(key: String): Flow<Boolean?> {
        return this.dataStore.data.map { preferences: Preferences ->
            val bytes = preferences[byteArrayPreferencesKey(key)]
            if (bytes == null || bytes.size != 1) {
                null
            } else {
                bytes[0] != 0.toByte()
            }
        }
    }

    suspend fun setBoolean(key: String, value: Boolean) {
        this.dataStore.edit { preferences ->
            val bytes = ByteArray(1)
            bytes[0] = if (value) 1.toByte() else 0.toByte()
            preferences[byteArrayPreferencesKey(key)] = bytes
        }
    }

    fun getEncryptedString(key: String): Flow<String?> {
        return this.dataStore.data.map { preferences: Preferences ->
            val bytes = preferences[byteArrayPreferencesKey(key)]
            if (bytes == null) {
                null
            } else {
                val decrypted = this.cryptoHandler.decrypt(bytes)
                if (decrypted == null) {
                    null
                } else {
                    String(decrypted, Charsets.UTF_8)
                }
            }
        }
    }

    suspend fun setEncryptedString(key: String, value: String) {
        this.dataStore.edit { preferences ->
            val encrypted = cryptoHandler.encrypt(value.toByteArray(Charsets.UTF_8))
            if (encrypted != null) {
                preferences[byteArrayPreferencesKey(key)] = encrypted
            }
        }
    }

    fun getEncryptedInt(key: String): Flow<Int?> {
        return this.dataStore.data.map { preferences: Preferences ->
            val bytes = preferences[byteArrayPreferencesKey(key)]
            if (bytes == null) {
                null
            } else {
                val decrypted = this.cryptoHandler.decrypt(bytes)
                if (decrypted == null) {
                    null
                } else {
                    ByteBuffer.wrap(decrypted).int
                }
            }
        }
    }

    suspend fun setEncryptedInt(key: String, value: Int) {
        this.dataStore.edit { preferences ->
            val encrypted = cryptoHandler.encrypt(ByteBuffer.allocate(Int.SIZE_BYTES).putInt(value).array())
            if (encrypted != null) {
                preferences[byteArrayPreferencesKey(key)] = encrypted
            }
        }
    }

    fun getEncryptedDouble(key: String): Flow<Double?> {
        return this.dataStore.data.map { preferences: Preferences ->
            val bytes = preferences[byteArrayPreferencesKey(key)]
            if (bytes == null) {
                null
            } else {
                val decrypted = this.cryptoHandler.decrypt(bytes)
                if (decrypted == null) {
                    null
                } else {
                    ByteBuffer.wrap(decrypted).double
                }
            }
        }
    }

    suspend fun setEncryptedDouble(key: String, value: Double) {
        this.dataStore.edit { preferences ->
            val encrypted = cryptoHandler.encrypt(ByteBuffer.allocate(Double.SIZE_BYTES).putDouble(value).array())
            if (encrypted != null) {
                preferences[byteArrayPreferencesKey(key)] = encrypted
            }
        }
    }

    fun getEncryptedBoolean(key: String): Flow<Boolean?> {
        return this.dataStore.data.map { preferences: Preferences ->
            val bytes = preferences[byteArrayPreferencesKey(key)]
            if (bytes == null) {
                null
            } else {
                val decrypted = this.cryptoHandler.decrypt(bytes)
                if (decrypted == null || decrypted.size != 1) {
                    null
                } else {
                    decrypted[0] != 0.toByte()
                }
            }
        }
    }

    suspend fun setEncryptedBoolean(key: String, value: Boolean) {
        this.dataStore.edit { preferences ->
            val bytes = ByteArray(1)
            bytes[0] = if (value) 1.toByte() else 0.toByte()
            val encrypted = cryptoHandler.encrypt(bytes)
            if (encrypted != null) {
                preferences[byteArrayPreferencesKey(key)] = encrypted
            }
        }
    }

    suspend fun remove(key: String) {
        this.dataStore.edit { preferences -> preferences.remove(byteArrayPreferencesKey(key)) }
    }
}
