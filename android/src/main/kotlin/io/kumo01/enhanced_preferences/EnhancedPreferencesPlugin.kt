package io.kumo01.enhanced_preferences

import android.util.Log
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.security.GeneralSecurityException
import kotlinx.coroutines.flow.firstOrNull
import kotlinx.coroutines.runBlocking

const val TAG = "EnhancedPreferencesPlugin"

/** EnhancedPreferencesPlugin */
class EnhancedPreferencesPlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel
    private lateinit var repository: EnhancedPreferencesRepository

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "enhanced_preferences")
        channel.setMethodCallHandler(this)
        repository = EnhancedPreferencesRepository(flutterPluginBinding.applicationContext)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        Log.d(TAG, "${call.method}")

        try {
            when (call.method) {
                "getString" -> {
                    result.success(getString(
                        call.argument<String>("key"),
                        call.argument<Boolean>("enableEncryption")
                    ))
                }
                "setString" -> {
                    result.success(setString(
                        call.argument<String>("key"),
                        call.argument<String>("value"),
                        call.argument<Boolean>("enableEncryption")
                    ))
                }
                "getInt" -> {
                    result.success(getInt(
                        call.argument<String>("key"),
                        call.argument<Boolean>("enableEncryption")
                    ))
                }
                "setInt" -> {
                    result.success(setInt(
                        call.argument<String>("key"),
                        call.argument<Int>("value"),
                        call.argument<Boolean>("enableEncryption")
                    ))
                }
                "getDouble" -> {
                    result.success(getDouble(
                        call.argument<String>("key"),
                        call.argument<Boolean>("enableEncryption")
                    ))
                }
                "setDouble" -> {
                    result.success(setDouble(
                        call.argument<String>("key"),
                        call.argument<Double>("value"),
                        call.argument<Boolean>("enableEncryption")
                    ))
                }
                "getBool" -> {
                    result.success(getBool(
                        call.argument<String>("key"),
                        call.argument<Boolean>("enableEncryption")
                    ))
                }
                "setBool" -> {
                    result.success(setBool(
                        call.argument<String>("key"),
                        call.argument<Boolean>("value"),
                        call.argument<Boolean>("enableEncryption")
                    ))
                }
                "remove" -> {
                    result.success(remove(call.argument<String>("key")))
                }
                "keys" -> {
                    result.success(keys())
                }
                else -> {
                    result.notImplemented()
                }
            }
        } catch (e: EnhancedPreferencesError) {
            result.error(e.code.name, e.message, null)
        } catch (e: Exception) {
            result.error(ErrorCode.UNKNOWN_ERROR.name, e.message, null)
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    private fun getString(key: String?, enableEncryption: Boolean?): String {
        if (key.isNullOrBlank()) {
            throw EnhancedPreferencesError(ErrorCode.INVALID_ARGUMENT, "Key is null or blank.")
        }

        val value: String? = if (enableEncryption == true) {
            try {
                runBlocking { repository.getEncryptedString(key).firstOrNull() }
            } catch (e: GeneralSecurityException) {
                throw EnhancedPreferencesError(ErrorCode.ILLEGAL_ACCESS, e.message)
            }
        } else {
            runBlocking { repository.getString(key).firstOrNull() }
        }

        if (value == null) {
            throw EnhancedPreferencesError(ErrorCode.REFERENCE_ERROR, "Value for '$key' is null.")
        } else {
            return value
        }
    }

    private fun setString(key: String?, value: String?, enableEncryption: Boolean?): String {
        if (key.isNullOrBlank()) {
            throw EnhancedPreferencesError(ErrorCode.INVALID_ARGUMENT, "Key is null or blank.")
        }
        if (value == null) {
            throw EnhancedPreferencesError(ErrorCode.INVALID_ARGUMENT, "Value is null or blank.")
        }

        if (enableEncryption == true) {
            try {
                runBlocking { repository.setEncryptedString(key, value) }
            } catch (e: GeneralSecurityException) {
                throw EnhancedPreferencesError(ErrorCode.ILLEGAL_ACCESS, e.message)
            }
        } else {
            runBlocking { repository.setString(key, value) }
        }

        return key
    }

    private fun getInt(key: String?, enableEncryption: Boolean?): Int {
        if (key.isNullOrBlank()) {
            throw EnhancedPreferencesError(ErrorCode.INVALID_ARGUMENT, "Key is null or blank.")
        }

        val value: Int? = if (enableEncryption == true) {
            try {
                runBlocking { repository.getEncryptedInt(key).firstOrNull() }
            } catch (e: GeneralSecurityException) {
                throw EnhancedPreferencesError(ErrorCode.ILLEGAL_ACCESS, e.message)
            }
        } else {
            runBlocking { repository.getInt(key).firstOrNull() }
        }

        if (value == null) {
            throw EnhancedPreferencesError(ErrorCode.REFERENCE_ERROR, "Value for '$key' is null.")
        } else {
            return value
        }
    }

    private fun setInt(key: String?, value: Int?, enableEncryption: Boolean?): String {
        if (key.isNullOrBlank()) {
            throw EnhancedPreferencesError(ErrorCode.INVALID_ARGUMENT, "Key is null or blank.")
        }
        if (value == null) {
            throw EnhancedPreferencesError(ErrorCode.INVALID_ARGUMENT, "Value is null or blank.")
        }

        if (enableEncryption == true) {
            try {
                runBlocking { repository.setEncryptedInt(key, value) }
            } catch (e: GeneralSecurityException) {
                throw EnhancedPreferencesError(ErrorCode.ILLEGAL_ACCESS, e.message)
            }
        } else {
            runBlocking { repository.setInt(key, value) }
        }

        return key
    }

    private fun getDouble(key: String?, enableEncryption: Boolean?): Double {
        if (key.isNullOrBlank()) {
            throw EnhancedPreferencesError(ErrorCode.INVALID_ARGUMENT, "Key is null or blank.")
        }

        val value: Double? = if (enableEncryption == true) {
            try {
                runBlocking { repository.getEncryptedDouble(key).firstOrNull() }
            } catch (e: GeneralSecurityException) {
                throw EnhancedPreferencesError(ErrorCode.ILLEGAL_ACCESS, e.message)
            }
        } else {
            runBlocking { repository.getDouble(key).firstOrNull() }
        }

        if (value == null) {
            throw EnhancedPreferencesError(ErrorCode.REFERENCE_ERROR, "Value for '$key' is null.")
        } else {
            return value
        }
    }

    private fun setDouble(key: String?, value: Double?, enableEncryption: Boolean?): String {
        if (key.isNullOrBlank()) {
            throw EnhancedPreferencesError(ErrorCode.INVALID_ARGUMENT, "Key is null or blank.")
        }
        if (value == null) {
            throw EnhancedPreferencesError(ErrorCode.INVALID_ARGUMENT, "Value is null or blank.")
        }

        if (enableEncryption == true) {
            try {
                runBlocking { repository.setEncryptedDouble(key, value) }
            } catch (e: GeneralSecurityException) {
                throw EnhancedPreferencesError(ErrorCode.ILLEGAL_ACCESS, e.message)
            }
        } else {
            runBlocking { repository.setDouble(key, value) }
        }

        return key
    }

    private fun getBool(key: String?, enableEncryption: Boolean?): Boolean {
        if (key.isNullOrBlank()) {
            throw EnhancedPreferencesError(ErrorCode.INVALID_ARGUMENT, "Key is null or blank.")
        }

        val value: Boolean? = if (enableEncryption == true) {
            try {
                runBlocking { repository.getEncryptedBoolean(key).firstOrNull() }
            } catch (e: GeneralSecurityException) {
                throw EnhancedPreferencesError(ErrorCode.ILLEGAL_ACCESS, e.message)
            }
        } else {
            runBlocking { repository.getBoolean(key).firstOrNull() }

        }

        if (value == null) {
            throw EnhancedPreferencesError(ErrorCode.REFERENCE_ERROR, "Value for '$key' is null.")
        } else {
            return value
        }
    }

    private fun setBool(key: String?, value: Boolean?, enableEncryption: Boolean?): String {
        if (key.isNullOrBlank()) {
            throw EnhancedPreferencesError(ErrorCode.INVALID_ARGUMENT, "Key is null or blank.")
        }
        if (value == null) {
            throw EnhancedPreferencesError(ErrorCode.INVALID_ARGUMENT, "Value is null or blank.")
        }

        if (enableEncryption == true) {
            try {
                runBlocking { repository.setEncryptedBoolean(key, value) }
            } catch (e: GeneralSecurityException) {
                throw EnhancedPreferencesError(ErrorCode.ILLEGAL_ACCESS, e.message)
            }
        } else {
            runBlocking { repository.setBoolean(key, value) }
        }

        return key
    }

    private fun remove(key: String?): String {
        if (key.isNullOrBlank()) {
            throw EnhancedPreferencesError(ErrorCode.INVALID_ARGUMENT, "Key is null or blank.")
        }

        runBlocking { repository.remove(key) }

        return key
    }

    private fun keys(): List<String> {
        val value: List<String>? = runBlocking { repository.keys().firstOrNull() }

        return value ?: ArrayList(0)
    }
}
