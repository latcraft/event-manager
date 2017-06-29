package lv.latcraft.event.tasks.router.commands

import lv.latcraft.event.tasks.PublishEventOnLanyrd

import static lv.latcraft.event.utils.LambdaMethods.invokeLambda

class PublishEventOnLanyrdCommand extends BaseCommand {

  @Override
  String getPrefix() { "publish lanyrd" }

  @Override
  String getDescription() { "publish lanyrd" }

  @Override
  String apply(String command) {
    invokeLambda(functionName(PublishEventOnLanyrd))
    "Please, be patient, my master, I started publishing the event!"
  }

}