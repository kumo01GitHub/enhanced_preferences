package io.kumo01.enhanced_preferences

import androidx.datastore.core.DataStore
import androidx.datastore.preferences.core.Preferences
import androidx.datastore.preferences.core.edit
import androidx.datastore.preferences.core.stringPreferencesKey
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.map

/** EnhancedPreferencesRepository */
class EnhancedPreferencesRepository(
    private val dataStore: DataStore<Preferences>
) {
    fun getString(key: String): Flow<String?> {
        return this.dataStore.data
            .map { preferences: Preferences ->
                preferences[stringPreferencesKey(key)]
            }
    }

    suspend fun setString(key: String, value: String) {
        this.dataStore.edit { preferences ->
            preferences[stringPreferencesKey(key)] = value
        }
    }
}
