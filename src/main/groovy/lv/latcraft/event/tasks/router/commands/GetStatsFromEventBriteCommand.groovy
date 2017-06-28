package lv.latcraft.event.tasks.router.commands

import lv.latcraft.event.tasks.GetStatsFromEventBrite

import static lv.latcraft.event.utils.JsonMethods.dumpJson

import static lv.latcraft.event.utils.LambdaMethods.invokeLambda

class GetStatsFromEventBriteCommand extends BaseCommand {

  @Override
  String getPrefix() { "get stats eventbrite" }

  @Override
  String getDescription() { "get stats eventbrite [number_of_past_events]" }

  @Override
  String apply(String command) {
    List<String> parameters = getCommandParameterList(command)
    if (parameters.size() > 0 && parameters.get(0).isInteger()) {
      invokeLambda(functionName(GetStatsFromEventBrite), dumpJson([past: parameters.get(0).toInteger()]))
    } else {
      invokeLambda(functionName(GetStatsFromEventBrite))
    }
    "Please, be patient, my master, I started retrieving event statistics!"
  }

}
