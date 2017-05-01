package lv.latcraft.event.tasks.router.commands

class ListEventBriteVenuesCommand extends BaseCommand {

  @Override
  String getPrefix() { "list venues" }

  @Override
  String getDescription() { "list venues" }

  @Override
  String apply(String command) {
    Map<String, String> venues = [:]
    eventBrite.events.each { Map event ->
      Map<String, ?> venue = eventBrite.getVenueData(event.venue_id as String)
      venues.put(event.venue_id as String, "${venue.name}, ${venue.address.address_1}".toString())
    }
    "Master, here are available EventBrite venues: \n" + venues.sort { entry -> entry.value }.collect { key, value -> "${key} -> ${value}" }.join("\n")
  }

}
