package lv.latcraft.event.lambda.mock

import com.amazonaws.services.lambda.runtime.Client

class InternalClient implements Client {

  String getInstallationId() {
    ""
  }

  String getAppTitle() {
    ""
  }

  String getAppVersionName() {
    ""
  }

  String getAppVersionCode() {
    ""
  }

  String getAppPackageName() {
    ""
  }

}
