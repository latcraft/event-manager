package lv.latcraft.event.utils

import com.amazonaws.services.lambda.AWSLambdaClientBuilder
import com.amazonaws.services.lambda.model.InvokeRequest
import groovy.transform.CompileStatic
import groovy.transform.TypeChecked

import static com.amazonaws.services.lambda.model.InvocationType.Event

@CompileStatic
@TypeChecked
class LambdaMethods {

  static boolean isInsideLambda() {
    new File('/var/task').exists()
  }

  static void invokeLambda(String functionName) {
    invokeLambda(functionName, "")
  }

  static void invokeLambda(String functionName, String payload) {
    InvokeRequest request = new InvokeRequest()
      .withFunctionName(functionName)
      .withPayload(payload)
      .withInvocationType(Event)
    AWSLambdaClientBuilder.standard().build().invoke(request)
  }

}
