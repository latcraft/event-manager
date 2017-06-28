package lv.latcraft.event.tasks

import com.amazonaws.services.lambda.runtime.Context
import groovy.transform.Canonical
import groovy.util.logging.Log4j
import lv.latcraft.event.lambda.mock.InternalContext

@Log4j("logger")
class GetStatsFromEventBrite extends BaseTask {

  @Override
  Map<String, String> doExecute(Map<String, String> request, Context context) {
    Map response = [:]
    int pastEvents = request.containsKey('past') ? Integer.valueOf(request.past) : 0
    if (pastEvents <= 0) {
      futureEvents.each { Map event ->
        shareEventStats(event)
      }
    } else {
      events.findAll { !isFutureEvent(it) }.take(pastEvents).each { Map event ->
        shareEventStats(event)
      }
    }
    response
  }

  private void shareEventStats(Map event) {
    String eventId = calculateEventId(event)
    if (event.eventbriteEventId) {
      String eventTitle = "LatCraft | ${event.theme}"
      EventStats eventStats = getEventStats(eventTitle, event.eventbriteEventId as String)
      if (isFutureEvent(event)) {
        slack.send("Event \"LatCraft | ${event.theme}\" (${eventId}, ${event.eventbriteEventId}) has ${eventStats.total - eventStats.cancelled} registration(s) and ${eventStats.cancelled} cancellation(s)!")
      } else {
        slack.send("Event \"LatCraft | ${event.theme}\" (${eventId}, ${event.eventbriteEventId}) had ${eventStats.checkedIn} check-in(s) of ${eventStats.total - eventStats.cancelled} registration(s) and ${eventStats.cancelled} cancellation(s)!")
      }
    } else {
      slack.send("Master, it seems , that event \"LatCraft | ${event.theme}\" (${eventId}) is not yet published on EventBrite, so, I can't get you any statistics!")
    }
  }

  EventStats getEventStats(String eventTitle, String eventbriteEventId) {
    def attendees = eventBrite.getAttendees(eventbriteEventId)
    new EventStats(
      title: eventTitle,
      total: attendees.size(),
      cancelled: attendees.findAll { it.cancelled }.size(),
      checkedIn: attendees.findAll { it.checked_in }.size()
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
    new GetStatsFromEventBrite().execute([past: "4"], new InternalContext())
  }

}
