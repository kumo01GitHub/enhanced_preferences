package io.kumo01.enhanced_preferences

import androidx.datastore.core.DataStore
import androidx.datastore.preferences.core.Preferences
import androidx.datastore.preferences.core.booleanPreferencesKey
import androidx.datastore.preferences.core.doublePreferencesKey
import androidx.datastore.preferences.core.edit
import androidx.datastore.preferences.core.intPreferencesKey
import androidx.datastore.preferences.core.stringPreferencesKey
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.map

/** EnhancedPreferencesRepository */
class EnhancedPreferencesRepository(private val dataStore: DataStore<Preferences>) {
    fun getString(key: String): Flow<String?> {
        return this.dataStore.data.map { preferences: Preferences ->
            preferences[stringPreferencesKey(key)]
        }
    }

    suspend fun setString(key: String, value: String) {
        this.dataStore.edit { preferences -> preferences[stringPreferencesKey(key)] = value }
    }

    fun getInt(key: String): Flow<Int?> {
        return this.dataStore.data.map { preferences: Preferences ->
            preferences[intPreferencesKey(key)]
        }
    }

    suspend fun setInt(key: String, value: Int) {
        this.dataStore.edit { preferences -> preferences[intPreferencesKey(key)] = value }
    }

    fun getDouble(key: String): Flow<Double?> {
        return this.dataStore.data.map { preferences: Preferences ->
            preferences[doublePreferencesKey(key)]
        }
    }

    suspend fun setDouble(key: String, value: Double) {
        this.dataStore.edit { preferences -> preferences[doublePreferencesKey(key)] = value }
    }

    fun getBoolean(key: String): Flow<Boolean?> {
        return this.dataStore.data.map { preferences: Preferences ->
            preferences[booleanPreferencesKey(key)]
        }
    }

    suspend fun setBoolean(key: String, value: Boolean) {
        this.dataStore.edit { preferences -> preferences[booleanPreferencesKey(key)] = value }
    }
}
