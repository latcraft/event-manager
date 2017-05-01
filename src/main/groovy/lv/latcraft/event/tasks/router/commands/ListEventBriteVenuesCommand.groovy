package lv.latcraft.event.tasks.router.commands

import lv.latcraft.event.tasks.ListEventBriteVenues

import static lv.latcraft.event.utils.LambdaMethods.invokeLambda

class ListEventBriteVenuesCommand extends BaseCommand {

  @Override
  String getPrefix() { "list venues" }

  @Override
  String getDescription() { "list venues" }

  @Override
  String apply(String command) {
    invokeLambda(functionName(ListEventBriteVenues))
    "Master, I started searching for venues!"
  }

}
