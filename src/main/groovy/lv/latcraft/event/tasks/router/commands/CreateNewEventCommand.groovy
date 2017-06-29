package lv.latcraft.event.tasks.router.commands

import lv.latcraft.event.tasks.CreateNewEvent

import static lv.latcraft.event.utils.LambdaMethods.invokeLambda

class CreateNewEventCommand extends BaseCommand {

  @Override
  String getPrefix() { "create event" }

  @Override
  String getDescription() { "create event [event_template_id]" }

  @Override
  String apply(String command) {
    invokeLambda(functionName(CreateNewEvent))
    "Please, be patient, my master, I started creating the event!"
  }

}
