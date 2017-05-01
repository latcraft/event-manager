package lv.latcraft.event.tasks.router.commands

import lv.latcraft.event.tasks.CopyContactsFromEventBriteToSendGrid

import static lv.latcraft.event.utils.LambdaMethods.invokeLambda

class CopyContactsCommand extends BaseCommand {

  @Override
  String getPrefix() { "copy contacts" }

  @Override
  String getDescription() { "copy contacts [event_id]" }

  @Override
  String apply(String command) {
    invokeLambda(functionName(CopyContactsFromEventBriteToSendGrid))
    "Please, be patient, my master, I started copying the contacts!"
  }

}
