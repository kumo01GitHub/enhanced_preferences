package io.kumo01.enhanced_preferences

class EnhancedPreferencesError(
    val code: ErrorCode,
    override val message: String? = null
) : Throwable()

enum class ErrorCode {
    INVALID_ARGUMENT,

    REFERENCE_ERROR,

    INVALID_ACCESS,

    UNKNOWN_ERROR,
}
