package lv.latcraft.event.tasks

import com.amazonaws.services.lambda.runtime.Context
import groovy.util.logging.Log4j
import lv.latcraft.event.lambda.mock.InternalContext

@Log4j("logger")
class PublishEventOnLanyrd extends BaseTask {

  @Override
  Map<String, String> doExecute(Map<String, String> request, Context context) {
    Map response = [:]
    futureEvents.each { Map event ->


    }
    response
  }

  static void main(String[] args) {
    new PublishEventOnLanyrd().execute([:], new InternalContext())
  }

}
