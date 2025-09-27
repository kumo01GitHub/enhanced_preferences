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

        when (call.method) {
            "getString" -> {
                try {
                    if (call.argument<Boolean>("enableEncryption") == true) {
                        result.success(getEncryptedString(call.argument<String>("key")))
                    } else {
                        result.success(getString(call.argument<String>("key")))
                    }
                } catch (e: EnhancedPreferencesError) {
                    result.error(e.code.name, e.message, null)
                } catch (e: Exception) {
                    result.error(ErrorCode.UNKNOWN_ERROR.name, e.message, null)
                }
            }
            "setString" -> {
                try {
                    if (call.argument<Boolean>("enableEncryption") == true) {
                        result.success(
                                setEncryptedString(
                                        call.argument<String>("key"),
                                        call.argument<String>("value")
                                )
                        )
                    } else {
                        result.success(
                                setString(
                                        call.argument<String>("key"),
                                        call.argument<String>("value")
                                )
                        )
                    }
                } catch (e: EnhancedPreferencesError) {
                    result.error(e.code.name, e.message, null)
                } catch (e: Exception) {
                    result.error(ErrorCode.UNKNOWN_ERROR.name, e.message, null)
                }
            }
            "getInt" -> {
                try {
                    if (call.argument<Boolean>("enableEncryption") == true) {
                        result.success(getEncryptedInt(call.argument<String>("key")))
                    } else {
                        result.success(getInt(call.argument<String>("key")))
                    }
                } catch (e: EnhancedPreferencesError) {
                    result.error(e.code.name, e.message, null)
                } catch (e: Exception) {
                    result.error(ErrorCode.UNKNOWN_ERROR.name, e.message, null)
                }
            }
            "setInt" -> {
                try {
                    if (call.argument<Boolean>("enableEncryption") == true) {
                        result.success(
                                setEncryptedInt(
                                        call.argument<String>("key"),
                                        call.argument<Int>("value")
                                )
                        )
                    } else {
                        result.success(
                                setInt(call.argument<String>("key"), call.argument<Int>("value"))
                        )
                    }
                } catch (e: EnhancedPreferencesError) {
                    result.error(e.code.name, e.message, null)
                } catch (e: Exception) {
                    result.error(ErrorCode.UNKNOWN_ERROR.name, e.message, null)
                }
            }
            "getDouble" -> {
                try {
                    if (call.argument<Boolean>("enableEncryption") == true) {
                        result.success(getEncryptedDouble(call.argument<String>("key")))
                    } else {
                        result.success(getDouble(call.argument<String>("key")))
                    }
                } catch (e: EnhancedPreferencesError) {
                    result.error(e.code.name, e.message, null)
                } catch (e: Exception) {
                    result.error(ErrorCode.UNKNOWN_ERROR.name, e.message, null)
                }
            }
            "setDouble" -> {
                try {
                    if (call.argument<Boolean>("enableEncryption") == true) {
                        result.success(
                                setEncryptedDouble(
                                        call.argument<String>("key"),
                                        call.argument<Double>("value")
                                )
                        )
                    } else {
                        result.success(
                                setDouble(
                                        call.argument<String>("key"),
                                        call.argument<Double>("value")
                                )
                        )
                    }
                } catch (e: EnhancedPreferencesError) {
                    result.error(e.code.name, e.message, null)
                } catch (e: Exception) {
                    result.error(ErrorCode.UNKNOWN_ERROR.name, e.message, null)
                }
            }
            "getBool" -> {
                try {
                    if (call.argument<Boolean>("enableEncryption") == true) {
                        result.success(getEncryptedBool(call.argument<String>("key")))
                    } else {
                        result.success(getBool(call.argument<String>("key")))
                    }
                } catch (e: EnhancedPreferencesError) {
                    result.error(e.code.name, e.message, null)
                } catch (e: Exception) {
                    result.error(ErrorCode.UNKNOWN_ERROR.name, e.message, null)
                }
            }
            "setBool" -> {
                try {
                    if (call.argument<Boolean>("enableEncryption") == true) {
                        result.success(
                                setEncryptedBool(
                                        call.argument<String>("key"),
                                        call.argument<Boolean>("value")
                                )
                        )
                    } else {
                        result.success(
                                setBool(
                                        call.argument<String>("key"),
                                        call.argument<Boolean>("value")
                                )
                        )
                    }
                } catch (e: EnhancedPreferencesError) {
                    result.error(e.code.name, e.message, null)
                } catch (e: Exception) {
                    result.error(ErrorCode.UNKNOWN_ERROR.name, e.message, null)
                }
            }
            "remove" -> {
                try {
                    result.success(remove(call.argument<String>("key")))
                } catch (e: EnhancedPreferencesError) {
                    result.error(e.code.name, e.message, null)
                } catch (e: Exception) {
                    result.error(ErrorCode.UNKNOWN_ERROR.name, e.message, null)
                }
            }
            "keys" -> {
                try {
                    result.success(keys())
                } catch (e: EnhancedPreferencesError) {
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
            throw EnhancedPreferencesError(ErrorCode.INVALID_ARGUMENT, "Key is null or blank.")
        }

        val value: String? = runBlocking { repository.getString(key).firstOrNull() }

        if (value == null) {
            throw EnhancedPreferencesError(ErrorCode.REFERENCE_ERROR, "Value for '$key' is null.")
        } else {
            return value
        }
    }

    private fun setString(key: String?, value: String?): String {
        if (key.isNullOrBlank()) {
            throw EnhancedPreferencesError(ErrorCode.INVALID_ARGUMENT, "Key is null or blank.")
        }
        if (value == null) {
            throw EnhancedPreferencesError(ErrorCode.INVALID_ARGUMENT, "Value is null or blank.")
        }

        runBlocking { repository.setString(key, value) }

        return key
    }

    private fun getInt(key: String?): Int {
        if (key.isNullOrBlank()) {
            throw EnhancedPreferencesError(ErrorCode.INVALID_ARGUMENT, "Key is null or blank.")
        }

        val value: Int? = runBlocking { repository.getInt(key).firstOrNull() }

        if (value == null) {
            throw EnhancedPreferencesError(ErrorCode.REFERENCE_ERROR, "Value for '$key' is null.")
        } else {
            return value
        }
    }

    private fun setInt(key: String?, value: Int?): String {
        if (key.isNullOrBlank()) {
            throw EnhancedPreferencesError(ErrorCode.INVALID_ARGUMENT, "Key is null or blank.")
        }
        if (value == null) {
            throw EnhancedPreferencesError(ErrorCode.INVALID_ARGUMENT, "Value is null or blank.")
        }

        runBlocking { repository.setInt(key, value) }

        return key
    }

    private fun getDouble(key: String?): Double {
        if (key.isNullOrBlank()) {
            throw EnhancedPreferencesError(ErrorCode.INVALID_ARGUMENT, "Key is null or blank.")
        }

        val value: Double? = runBlocking { repository.getDouble(key).firstOrNull() }

        if (value == null) {
            throw EnhancedPreferencesError(ErrorCode.REFERENCE_ERROR, "Value for '$key' is null.")
        } else {
            return value
        }
    }

    private fun setDouble(key: String?, value: Double?): String {
        if (key.isNullOrBlank()) {
            throw EnhancedPreferencesError(ErrorCode.INVALID_ARGUMENT, "Key is null or blank.")
        }
        if (value == null) {
            throw EnhancedPreferencesError(ErrorCode.INVALID_ARGUMENT, "Value is null or blank.")
        }

        runBlocking { repository.setDouble(key, value) }

        return key
    }

    private fun getBool(key: String?): Boolean {
        if (key.isNullOrBlank()) {
            throw EnhancedPreferencesError(ErrorCode.INVALID_ARGUMENT, "Key is null or blank.")
        }

        val value: Boolean? = runBlocking { repository.getBoolean(key).firstOrNull() }

        if (value == null) {
            throw EnhancedPreferencesError(ErrorCode.REFERENCE_ERROR, "Value for '$key' is null.")
        } else {
            return value
        }
    }

    private fun setBool(key: String?, value: Boolean?): String {
        if (key.isNullOrBlank()) {
            throw EnhancedPreferencesError(ErrorCode.INVALID_ARGUMENT, "Key is null or blank.")
        }
        if (value == null) {
            throw EnhancedPreferencesError(ErrorCode.INVALID_ARGUMENT, "Value is null or blank.")
        }

        runBlocking { repository.setBoolean(key, value) }

        return key
    }

    private fun getEncryptedString(key: String?): String {
        if (key.isNullOrBlank()) {
            throw EnhancedPreferencesError(ErrorCode.INVALID_ARGUMENT, "Key is null or blank.")
        }

        var value: String? = null

        try {
            value = runBlocking { repository.getEncryptedString(key).firstOrNull() }
        } catch (e: GeneralSecurityException) {
            throw EnhancedPreferencesError(ErrorCode.ILLEGAL_ACCESS, e.message)
        }

        if (value == null) {
            throw EnhancedPreferencesError(ErrorCode.REFERENCE_ERROR, "Value for '$key' is null.")
        } else {
            return value
        }
    }

    private fun setEncryptedString(key: String?, value: String?): String {
        if (key.isNullOrBlank()) {
            throw EnhancedPreferencesError(ErrorCode.INVALID_ARGUMENT, "Key is null or blank.")
        }
        if (value == null) {
            throw EnhancedPreferencesError(ErrorCode.INVALID_ARGUMENT, "Value is null or blank.")
        }

        try {
            runBlocking { repository.setEncryptedString(key, value) }
        } catch (e: GeneralSecurityException) {
            throw EnhancedPreferencesError(ErrorCode.ILLEGAL_ACCESS, e.message)
        }

        return key
    }

    private fun getEncryptedInt(key: String?): Int {
        if (key.isNullOrBlank()) {
            throw EnhancedPreferencesError(ErrorCode.INVALID_ARGUMENT, "Key is null or blank.")
        }

        var value: Int? = null

        try {
            value = runBlocking { repository.getEncryptedInt(key).firstOrNull() }
        } catch (e: GeneralSecurityException) {
            throw EnhancedPreferencesError(ErrorCode.ILLEGAL_ACCESS, e.message)
        }

        if (value == null) {
            throw EnhancedPreferencesError(ErrorCode.REFERENCE_ERROR, "Value for '$key' is null.")
        } else {
            return value
        }
    }

    private fun setEncryptedInt(key: String?, value: Int?): String {
        if (key.isNullOrBlank()) {
            throw EnhancedPreferencesError(ErrorCode.INVALID_ARGUMENT, "Key is null or blank.")
        }
        if (value == null) {
            throw EnhancedPreferencesError(ErrorCode.INVALID_ARGUMENT, "Value is null or blank.")
        }

        try {
            runBlocking { repository.setEncryptedInt(key, value) }
        } catch (e: GeneralSecurityException) {
            throw EnhancedPreferencesError(ErrorCode.ILLEGAL_ACCESS, e.message)
        }

        return key
    }

    private fun getEncryptedDouble(key: String?): Double {
        if (key.isNullOrBlank()) {
            throw EnhancedPreferencesError(ErrorCode.INVALID_ARGUMENT, "Key is null or blank.")
        }

        var value: Double? = null

        try {
            value = runBlocking { repository.getEncryptedDouble(key).firstOrNull() }
        } catch (e: GeneralSecurityException) {
            throw EnhancedPreferencesError(ErrorCode.ILLEGAL_ACCESS, e.message)
        }

        if (value == null) {
            throw EnhancedPreferencesError(ErrorCode.REFERENCE_ERROR, "Value for '$key' is null.")
        } else {
            return value
        }
    }

    private fun setEncryptedDouble(key: String?, value: Double?): String {
        if (key.isNullOrBlank()) {
            throw EnhancedPreferencesError(ErrorCode.INVALID_ARGUMENT, "Key is null or blank.")
        }
        if (value == null) {
            throw EnhancedPreferencesError(ErrorCode.INVALID_ARGUMENT, "Value is null or blank.")
        }

        try {
            runBlocking { repository.setEncryptedDouble(key, value) }
        } catch (e: GeneralSecurityException) {
            throw EnhancedPreferencesError(ErrorCode.ILLEGAL_ACCESS, e.message)
        }

        return key
    }

    private fun getEncryptedBool(key: String?): Boolean {
        if (key.isNullOrBlank()) {
            throw EnhancedPreferencesError(ErrorCode.INVALID_ARGUMENT, "Key is null or blank.")
        }

        var value: Boolean? = null

        try {
            value = runBlocking { repository.getEncryptedBoolean(key).firstOrNull() }
        } catch (e: GeneralSecurityException) {
            throw EnhancedPreferencesError(ErrorCode.ILLEGAL_ACCESS, e.message)
        }

        if (value == null) {
            throw EnhancedPreferencesError(ErrorCode.REFERENCE_ERROR, "Value for '$key' is null.")
        } else {
            return value
        }
    }

    private fun setEncryptedBool(key: String?, value: Boolean?): String {
        if (key.isNullOrBlank()) {
            throw EnhancedPreferencesError(ErrorCode.INVALID_ARGUMENT, "Key is null or blank.")
        }
        if (value == null) {
            throw EnhancedPreferencesError(ErrorCode.INVALID_ARGUMENT, "Value is null or blank.")
        }

        try {
            runBlocking { repository.setEncryptedBoolean(key, value) }
        } catch (e: GeneralSecurityException) {
            throw EnhancedPreferencesError(ErrorCode.ILLEGAL_ACCESS, e.message)
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
