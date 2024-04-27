
import 've_sdk_flutter_platform_interface.dart';

class VeSdkFlutter {
  Future<String?> getPlatformVersion() {
    return VeSdkFlutterPlatform.instance.getPlatformVersion();
  }
}
