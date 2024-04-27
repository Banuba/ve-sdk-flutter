/// Error occurs when the sdk cannot be initialized with provided license token: invalid, empty.
const errCodeSdkNotInitialized = 'ERR_SDK_NOT_INITIALIZED';

/// Error occurs when the license has be revoked. Please contact Banuba
const errCodeSdkLicenseRevoked = 'ERR_SDK_LICENSE_REVOKED';

/// Error occurs when view controller on Android(Activity) or iOS(ViewController) is not available.
const errCodeMissingHost = 'ERR_MISSING_HOST';

/// Error occurs when the SDK received invalid input params.
const errCodeInvalidParams = 'ERR_INVALID_PARAMS';

/// Error occurs when the SDK cannot make exported video.
const errCodeMissingExportResult = 'ERR_MISSING_EXPORT_RESULT';