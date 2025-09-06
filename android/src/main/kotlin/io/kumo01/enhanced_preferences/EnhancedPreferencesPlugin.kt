package io.kumo01.enhanced_preferences

import android.content.Context
import android.util.Log
import androidx.datastore.core.DataStore
import androidx.datastore.preferences.core.Preferences
import androidx.datastore.preferences.preferencesDataStore
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import kotlinx.coroutines.flow.firstOrNull
import kotlinx.coroutines.runBlocking

const val TAG = "EnhancedPreferencesPlugin"
const val ENHANCED_PREFERENCES_NAME = "FlutterEnhancedPreferences"
val Context.dataStore: DataStore<Preferences> by preferencesDataStore(ENHANCED_PREFERENCES_NAME)

/** EnhancedPreferencesPlugin */
class EnhancedPreferencesPlugin :
    FlutterPlugin,
    MethodCallHandler {
    private lateinit var channel: MethodChannel
    private lateinit var repository: EnhancedPreferencesRepository

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "enhanced_preferences")
        channel.setMethodCallHandler(this)
        repository = EnhancedPreferencesRepository(flutterPluginBinding.applicationContext.dataStore)
    }

    override fun onMethodCall(
        call: MethodCall,
        result: Result
    ) {
        Log.d(TAG, "${call.method} called")

        when (call.method) {
            "getString" -> {
                try {
                    result.success(getString(call.argument<String>("key")))
                } catch(e: EnhancedPreferencesError) {
                    result.error(e.code.name, e.message, null)
                } catch (e: Exception) {
                    result.error(ErrorCode.UNKNOWN_ERROR.name, e.message, null)
                }
            }
            "setString" -> {
                try {
                    result.success(setString(call.argument<String>("key"), call.argument<String>("value")))
                } catch(e: EnhancedPreferencesError) {
                    result.error(e.code.name, e.message, null)
                } catch (e: Exception) {
                    result.error(ErrorCode.UNKNOWN_ERROR.name, e.message, null)
                }
            }
            "getInt" -> {
                try {
                    result.success(getInt(call.argument<String>("key")))
                } catch(e: EnhancedPreferencesError) {
                    result.error(e.code.name, e.message, null)
                } catch (e: Exception) {
                    result.error(ErrorCode.UNKNOWN_ERROR.name, e.message, null)
                }
            }
            "setInt" -> {
                try {
                    result.success(setInt(call.argument<String>("key"), call.argument<Int>("value")))
                } catch(e: EnhancedPreferencesError) {
                    result.error(e.code.name, e.message, null)
                } catch (e: Exception) {
                    result.error(ErrorCode.UNKNOWN_ERROR.name, e.message, null)
                }
            }
            "getDouble" -> {
                try {
                    result.success(getDouble(call.argument<String>("key")))
                } catch(e: EnhancedPreferencesError) {
                    result.error(e.code.name, e.message, null)
                } catch (e: Exception) {
                    result.error(ErrorCode.UNKNOWN_ERROR.name, e.message, null)
                }
            }
            "setDouble" -> {
                try {
                    result.success(setDouble(call.argument<String>("key"), call.argument<Double>("value")))
                } catch(e: EnhancedPreferencesError) {
                    result.error(e.code.name, e.message, null)
                } catch (e: Exception) {
                    result.error(ErrorCode.UNKNOWN_ERROR.name, e.message, null)
                }
            }
            "getBool" -> {
                try {
                    result.success(getBool(call.argument<String>("key")))
                } catch(e: EnhancedPreferencesError) {
                    result.error(e.code.name, e.message, null)
                } catch (e: Exception) {
                    result.error(ErrorCode.UNKNOWN_ERROR.name, e.message, null)
                }
            }
            "setBool" -> {
                try {
                    result.success(setBool(call.argument<String>("key"), call.argument<Boolean>("value")))
                } catch(e: EnhancedPreferencesError) {
                    result.error(e.code.name, e.message, null)
                } catch (e: Exception) {
                    result.error(ErrorCode.UNKNOWN_ERROR.name, e.message, null)
                }
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    private fun getString(key: String?): String {
        if (key.isNullOrBlank()) {
            throw EnhancedPreferencesError(
                ErrorCode.INVALID_ARGUMENT,
                "Key is null or blank."
            )
        }

        val value: String? = runBlocking {
            repository.getString(key).firstOrNull()
        }

        if (value == null) {
            throw EnhancedPreferencesError(
                ErrorCode.REFERENCE_ERROR,
                "Value for '$key' is null."
            )
        } else {
            return value
        }
    }

    private fun setString(key: String?, value: String?): String {
        if (key.isNullOrBlank()) {
            throw EnhancedPreferencesError(
                ErrorCode.INVALID_ARGUMENT,
                "Key is null or blank."
            )
        }
        if (value == null) {
            throw EnhancedPreferencesError(
                ErrorCode.INVALID_ARGUMENT,
                "Value is null or blank."
            )
        }

        runBlocking {
            repository.setString(key, value)
        }

        return key
    }

    private fun getInt(key: String?): Int {
        if (key.isNullOrBlank()) {
            throw EnhancedPreferencesError(
                ErrorCode.INVALID_ARGUMENT,
                "Key is null or blank."
            )
        }

        val value: Int? = runBlocking {
            repository.getInt(key).firstOrNull()
        }

        if (value == null) {
            throw EnhancedPreferencesError(
                ErrorCode.REFERENCE_ERROR,
                "Value for '$key' is null."
            )
        } else {
            return value
        }
    }

    private fun setInt(key: String?, value: Int?): String {
        if (key.isNullOrBlank()) {
            throw EnhancedPreferencesError(
                ErrorCode.INVALID_ARGUMENT,
                "Key is null or blank."
            )
        }
        if (value == null) {
            throw EnhancedPreferencesError(
                ErrorCode.INVALID_ARGUMENT,
                "Value is null or blank."
            )
        }

        runBlocking {
            repository.setInt(key, value)
        }

        return key
    }

    private fun getDouble(key: String?): Double {
        if (key.isNullOrBlank()) {
            throw EnhancedPreferencesError(
                ErrorCode.INVALID_ARGUMENT,
                "Key is null or blank."
            )
        }

        val value: Double? = runBlocking {
            repository.getDouble(key).firstOrNull()
        }

        if (value == null) {
            throw EnhancedPreferencesError(
                ErrorCode.REFERENCE_ERROR,
                "Value for '$key' is null."
            )
        } else {
            return value
        }
    }

    private fun setDouble(key: String?, value: Double?): String {
        if (key.isNullOrBlank()) {
            throw EnhancedPreferencesError(
                ErrorCode.INVALID_ARGUMENT,
                "Key is null or blank."
            )
        }
        if (value == null) {
            throw EnhancedPreferencesError(
                ErrorCode.INVALID_ARGUMENT,
                "Value is null or blank."
            )
        }

        runBlocking {
            repository.setDouble(key, value)
        }

        return key
    }

    private fun getBool(key: String?): Boolean {
        if (key.isNullOrBlank()) {
            throw EnhancedPreferencesError(
                ErrorCode.INVALID_ARGUMENT,
                "Key is null or blank."
            )
        }

        val value: Boolean? = runBlocking {
            repository.getBoolean(key).firstOrNull()
        }

        if (value == null) {
            throw EnhancedPreferencesError(
                ErrorCode.REFERENCE_ERROR,
                "Value for '$key' is null."
            )
        } else {
            return value
        }
    }

    private fun setBool(key: String?, value: Boolean?): String {
        if (key.isNullOrBlank()) {
            throw EnhancedPreferencesError(
                ErrorCode.INVALID_ARGUMENT,
                "Key is null or blank."
            )
        }
        if (value == null) {
            throw EnhancedPreferencesError(
                ErrorCode.INVALID_ARGUMENT,
                "Value is null or blank."
            )
        }

        runBlocking {
            repository.setBoolean(key, value)
        }

        return key
    }
}
