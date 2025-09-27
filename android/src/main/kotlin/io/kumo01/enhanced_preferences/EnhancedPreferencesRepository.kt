package io.kumo01.enhanced_preferences

import android.content.Context
import android.util.Base64
import androidx.datastore.core.DataStore
import androidx.datastore.preferences.core.MutablePreferences
import androidx.datastore.preferences.core.Preferences
import androidx.datastore.preferences.core.edit
import androidx.datastore.preferences.core.stringPreferencesKey
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
        return getItem(key, EnhancedPreferencesType.STRING, false).map { bytes ->
            if (bytes == null) {
                null
            } else {
                String(bytes, Charsets.UTF_8)
            }
        }
    }

    suspend fun setString(key: String, value: String) {
        setItem(key, value.toByteArray(Charsets.UTF_8), EnhancedPreferencesType.STRING, false)
    }

    fun getInt(key: String): Flow<Int?> {
        return getItem(key, EnhancedPreferencesType.INT, false).map { bytes ->
            if (bytes == null) {
                null
            } else {
                ByteBuffer.wrap(bytes).int
            }
        }
    }

    suspend fun setInt(key: String, value: Int) {
        val bytes = ByteBuffer.allocate(Int.SIZE_BYTES).putInt(value).array()
        setItem(key, bytes,EnhancedPreferencesType.INT, false)
    }

    fun getDouble(key: String): Flow<Double?> {
        return getItem(key, EnhancedPreferencesType.DOUBLE, false).map { bytes ->
            if (bytes == null) {
                null
            } else {
                ByteBuffer.wrap(bytes).double
            }
        }
    }

    suspend fun setDouble(key: String, value: Double) {
        val bytes = ByteBuffer.allocate(Double.SIZE_BYTES).putDouble(value).array()
        setItem(key, bytes, EnhancedPreferencesType.DOUBLE, false)
    }

    fun getBoolean(key: String): Flow<Boolean?> {
        return getItem(key, EnhancedPreferencesType.BOOL, false).map { bytes ->
            if (bytes == null || bytes.size != 1) {
                null
            } else {
                bytes[0] != 0.toByte()
            }
        }
    }

    suspend fun setBoolean(key: String, value: Boolean) {
        val bytes = ByteArray(1)
        bytes[0] = if (value) 1.toByte() else 0.toByte()
        setItem(key, bytes, EnhancedPreferencesType.BOOL, false)
    }

    fun getEncryptedString(key: String): Flow<String?> {
        return getItem(key, EnhancedPreferencesType.STRING, true).map { bytes ->
            if (bytes == null) {
                null
            } else {
                String(bytes, Charsets.UTF_8)
            }
        }
    }

    suspend fun setEncryptedString(key: String, value: String) {
        setItem(key, value.toByteArray(Charsets.UTF_8), EnhancedPreferencesType.STRING, true)
    }

    fun getEncryptedInt(key: String): Flow<Int?> {
        return getItem(key, EnhancedPreferencesType.INT, true).map { bytes ->
            if (bytes == null) {
                null
            } else {
                ByteBuffer.wrap(bytes).int
            }
        }
    }

    suspend fun setEncryptedInt(key: String, value: Int) {
        val bytes = ByteBuffer.allocate(Int.SIZE_BYTES).putInt(value).array()
        setItem(key, bytes,EnhancedPreferencesType.INT, true)
    }

    fun getEncryptedDouble(key: String): Flow<Double?> {
        return getItem(key, EnhancedPreferencesType.DOUBLE, true).map { bytes ->
            if (bytes == null) {
                null
            } else {
                ByteBuffer.wrap(bytes).double
            }
        }
    }

    suspend fun setEncryptedDouble(key: String, value: Double) {
        val bytes = ByteBuffer.allocate(Double.SIZE_BYTES).putDouble(value).array()
        setItem(key, bytes, EnhancedPreferencesType.DOUBLE, true)
    }

    fun getEncryptedBoolean(key: String): Flow<Boolean?> {
        return getItem(key, EnhancedPreferencesType.BOOL, true).map { bytes ->
            if (bytes == null || bytes.size != 1) {
                null
            } else {
                bytes[0] != 0.toByte()
            }
        }
    }

    suspend fun setEncryptedBoolean(key: String, value: Boolean) {
        val bytes = ByteArray(1)
        bytes[0] = if (value) 1.toByte() else 0.toByte()
        setItem(key, bytes, EnhancedPreferencesType.BOOL, true)
    }

    suspend fun remove(key: String) {
        this.dataStore.edit { preferences: MutablePreferences ->
            preferences.remove(stringPreferencesKey(key))
        }
    }

    fun keys(): Flow<List<String>> {
        return this.dataStore.data.map { preferences: Preferences ->
            val keys = ArrayList<String>()
            for (key in preferences.asMap().keys) {
                keys.add(key.name)
            }
            keys
        }
    }

    private fun getItem(key: String, type: EnhancedPreferencesType, enableEncryption: Boolean): Flow<ByteArray?> {
        return this.dataStore.data.map { preferences: Preferences ->
            val value: String? = preferences[stringPreferencesKey(key)]
            val regex: Regex = if (enableEncryption) {
                Regex("^$type:[A-Za-z0-9+/=\n]+:[A-Za-z0-9+/=\n]+:[A-Za-z0-9+/=\n]+$")
            } else {
                Regex("^$type:[A-Za-z0-9+/=\n]+$")
            }

            if (value == null) {
                null
            } else if (value.matches(regex) && enableEncryption) {
                val splitValues = value.split(":")
                cryptoHandler.decrypt(CryptoData(
                    Base64.decode(splitValues[1], Base64.DEFAULT),
                    Base64.decode(splitValues[2], Base64.DEFAULT),
                    Base64.decode(splitValues[3], Base64.DEFAULT),
                ))
            } else if (value.matches(regex)) {
                Base64.decode(value.split(":")[1], Base64.DEFAULT)
            } else {
                null
            }
        }
    }

    private suspend fun setItem(key: String, value: ByteArray, type: EnhancedPreferencesType, enableEncryption: Boolean) {
        this.dataStore.edit { preferences: MutablePreferences ->
            if (enableEncryption) {
                val cryptoData = cryptoHandler.encrypt(value)
                val data = Base64.encodeToString(cryptoData.data, Base64.DEFAULT)
                val dataKey = Base64.encodeToString(cryptoData.key, Base64.DEFAULT)
                val iv = Base64.encodeToString(cryptoData.iv, Base64.DEFAULT)
                preferences[stringPreferencesKey(key)] = "$type:$data:$dataKey:$iv"
            } else {
                preferences[stringPreferencesKey(key)] = "$type:${Base64.encodeToString(value, Base64.DEFAULT)}"
            }
        }
    }
}
