package lv.latcraft.event.tasks

import com.amazonaws.services.lambda.runtime.Context
import lv.latcraft.event.lambda.mock.InternalContext

class CreateNewEvent extends BaseTask {

  @Override
  Map<String, String> doExecute(Map<String, String> request, Context context) {
    Map response = [:]
    if (futureEvents.size() > 0) {
      slack.send("I'm sorry, master, but it seems that there's already one event planned, so, I will not create another one!")
    } else {

      // TODO: create event from template

    }
    response
  }

  static void main(String[] args) {
    new CreateNewEvent().execute([:], new InternalContext())
  }

}
