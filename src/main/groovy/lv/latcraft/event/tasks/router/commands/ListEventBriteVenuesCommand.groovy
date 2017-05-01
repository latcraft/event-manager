package lv.latcraft.event.tasks.router.commands

import static lv.latcraft.event.utils.LambdaMethods.invokeLambda

class ListEventBriteVenuesCommand implements Command {

  @Override
  void accept(String params) {
    invokeLambda('list_event_brite_venues_function')
  }

  @Override
  String getPrefix() { "list venues" }

}
