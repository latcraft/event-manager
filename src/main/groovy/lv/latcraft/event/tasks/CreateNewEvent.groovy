package lv.latcraft.event.tasks

import com.amazonaws.services.lambda.runtime.Context
import lv.latcraft.event.lambda.mock.InternalContext

class CreateNewEvent extends BaseTask {

  static final Set<String> EVENT_TEMPLATES = [
    '2sessions1quickie',
    '3sessions',
    '4quickies',
    'panel',
    'workshop',
    'workshop3trainers',
  ]

  @Override
  Map<String, String> doExecute(Map<String, String> request, Context context) {
    Map response = [:]
    if (futureEvents.size() > 0) {
      slack.send("I'm sorry, master, but it seems that there's already one event planned, so, I will not create another one!")
    } else {
      // TODO: create event from template
      slack.send("I'm sorry, master, but this functionality is not yet implemented!")
    }
    response
  }

  static void main(String[] args) {
    new CreateNewEvent().execute([:], new InternalContext())
  }

}
