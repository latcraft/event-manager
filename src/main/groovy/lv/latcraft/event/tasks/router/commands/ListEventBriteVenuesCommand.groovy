package lv.latcraft.event.tasks.router.commands

import static lv.latcraft.event.utils.LambdaMethods.invokeLambda

class ListEventBriteVenuesCommand implements Command {

  @Override
  String getPrefix() { "list venues" }

  @Override
  String getDescription() { "list venues" }

  @Override
  String apply(String command) {
    invokeLambda('list_event_brite_venues_function')
    "Master, I started searching for venues!"
  }

}
