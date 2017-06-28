package lv.latcraft.event.tasks

import com.amazonaws.services.lambda.runtime.Context
import groovy.transform.Canonical
import groovy.util.logging.Log4j
import lv.latcraft.event.lambda.mock.InternalContext

@Log4j("logger")
class GetStatsFromEventBrite extends BaseTask {

  @Override
  Map<String, String> doExecute(Map<String, String> input, Context context) {
    Map response = [:]
    futureEvents.each { Map event ->
      String eventId = calculateEventId(event)
      if (event.eventbriteEventId) {
        String eventTitle = "LatCraft | ${event.theme}"
        EventStats eventStats = getEventStats(eventTitle, event.eventbriteEventId as String)
        slack.send("Event \"LatCraft | ${event.theme}\" (${eventId}, ${event.eventbriteEventId}) has ${eventStats.total} registration(s) and ${eventStats.cancelled} cancellation(s)!")
      } else {
        slack.send("Master, it seems , that event \"LatCraft | ${event.theme}\" (${eventId}) is not yet published on EventBrite, so, I can't get you any statistics!")
      }
    }
    response
  }

  EventStats getEventStats(String eventTitle, String eventbriteEventId) {
    def attendees = eventBrite.getAttendees(eventbriteEventId)
    new EventStats(
      title: eventTitle,
      total: attendees.size(),
      cancelled: attendees.findAll { it.cancelled }.size(),
      checkedIn: attendees.findAll { it.checked_in }.size(),
    )
  }

  @Canonical
  class EventStats {
    String title
    Integer total
    Integer checkedIn
    Integer cancelled
  }

  static void main(String[] args) {
    new GetStatsFromEventBrite().execute([:], new InternalContext())
  }

}
