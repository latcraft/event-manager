package lv.latcraft.event.tasks

import com.amazonaws.services.lambda.runtime.Context
import groovy.util.logging.Log4j

@Log4j("logger")
class PublishEventOnLanyrd extends BaseTask {

  @Override
  Map<String, String> doExecute(Map<String, String> input, Context context) {
    return null
  }

}
