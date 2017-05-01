package lv.latcraft.event.utils

import com.amazonaws.services.lambda.AWSLambdaClientBuilder
import com.amazonaws.services.lambda.model.InvokeRequest
import groovy.transform.CompileStatic
import groovy.transform.TypeChecked

import java.nio.ByteBuffer

@CompileStatic
@TypeChecked
class LambdaMethods {

  static boolean isInsideLambda() {
    new File('/var/task').exists()
  }

  static void invokeLambda(String functionName) {
    invokeLambda(functionName, null)
  }

  static void invokeLambda(String functionName, ByteBuffer payload) {
    InvokeRequest request = new InvokeRequest(
      functionName: functionName,
      invocationType: 'Event',
      payload: payload
    )
    AWSLambdaClientBuilder.standard().build().invoke(request)
  }

}
