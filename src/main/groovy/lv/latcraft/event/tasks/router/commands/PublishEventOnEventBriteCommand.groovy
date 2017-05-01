package lv.latcraft.event.tasks.router.commands

import lv.latcraft.event.tasks.PublishEventOnEventBrite

import static lv.latcraft.event.utils.LambdaMethods.invokeLambda

class PublishEventOnEventBriteCommand extends BaseCommand {

  @Override
  String getPrefix() { "publish evenbrite" }

  @Override
  String getDescription() { "publish eventbrite" }

  @Override
  String apply(String command) {
    invokeLambda(functionName(PublishEventOnEventBrite))
    "Please, be patient, my master, I started publishing the event!"
  }

}
