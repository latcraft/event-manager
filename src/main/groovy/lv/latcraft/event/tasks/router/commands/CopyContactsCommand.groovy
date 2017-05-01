package lv.latcraft.event.tasks.router.commands

import lv.latcraft.event.tasks.CopyContactsFromEventBriteToSendGrid
import lv.latcraft.event.utils.JsonMethods

import static lv.latcraft.event.utils.LambdaMethods.invokeLambda

class CopyContactsCommand extends BaseCommand {

  @Override
  String getPrefix() { "copy contacts" }

  @Override
  String getDescription() { "copy contacts [number_of_past_events]" }

  @Override
  String apply(String command) {
    invokeLambda(functionName(CopyContactsFromEventBriteToSendGrid), JsonMethods.dumpJson([
      events: getCommandParameterList(command)
    ]))
    "Please, be patient, my master, I started copying the contacts!"
  }

}
