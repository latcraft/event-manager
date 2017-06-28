package lv.latcraft.event.tasks

import com.amazonaws.services.lambda.runtime.Context
import groovy.json.JsonSlurper
import groovy.util.logging.Log4j
import lv.latcraft.event.integrations.EventBrite
import lv.latcraft.event.integrations.GitHub
import lv.latcraft.event.integrations.SendGrid
import lv.latcraft.event.integrations.Slack

import static lv.latcraft.event.utils.Constants.dateTimeFormat
import static lv.latcraft.event.utils.Constants.timeZone
import static lv.latcraft.event.utils.Utils.dumpJson
import static lv.latcraft.event.utils.Constants.dateFormat
import static lv.latcraft.event.integrations.Configuration.eventDataFile
import static org.apache.commons.lang.StringUtils.isNotBlank

@Log4j("baseLogger")
abstract class BaseTask {

  EventBrite eventBrite = new EventBrite()
  Slack slack = new Slack()
  GitHub gitHub = new GitHub()
  SendGrid sendGrid = new SendGrid()

  static String getRemoteFileContents(URL url) {
    remoteURLExists(url) ? url.text : null
  }

  static boolean remoteURLExists(URL url) {
    try {
      HttpURLConnection.setFollowRedirects(false)
      HttpURLConnection con = url.openConnection() as HttpURLConnection
      con.requestMethod = "HEAD"
      return con.getResponseCode() == HttpURLConnection.HTTP_OK
    } catch (Exception e) {
      baseLogger.debug("Remote URL ${url} does not exist!", e)
      return false
    }
  }

  Map<String, String> execute(Map<String, String> request, Context context) {
    System.setProperty('user.timezone', 'Europe/Riga')
    Map<String, String> response = [:]
    try {
      baseLogger.info "Received request parameters: ${request}"
      response = doExecute(request, context)
    } catch (Throwable t) {
      baseLogger.error('Uncaught exception', t)
      try {
        slack.send("Sorry, master, there seems to be some error with ${this.getClass().simpleName}, it threw ${t.getClass().simpleName} at '${t.stackTrace[0]}' with message '${t.message}'")
      } catch (Throwable x) {
        baseLogger.error('Problem sending slack message', x)
      }
    } finally {
      baseLogger.info "Sending response: ${response}"
    }
    response
  }

  abstract Map<String, String> doExecute(Map<String, String> request, Context context)

  static List<Map<String, ?>> getMasterData() {
    baseLogger.info "Retrieving master data from GitHub"
    new JsonSlurper().parse(new URL(eventDataFile).newInputStream()) as List<Map<String, ?>>
  }

  void updateMasterData(List<Map<String, ?>> eventsToUpdate) {
    if (dumpJson(eventsToUpdate) != dumpJson(getMasterData())) {
      baseLogger.info "Updating master data in GitHub"
      gitHub.updateFile('/repos/latcraft/website/contents/data/events.json', dumpJson(eventsToUpdate))
    } else {
      baseLogger.info "Master data in GitHub is already up-to-date"
    }
  }

  static List<Map<String, ?>> getEvents() {
    getMasterData()
  }

  static List<Map<String, ?>> getFutureEvents() {
    events.findAll { isFutureEvent(it) }
  }

  /**
   * Calculate unique event ID used to distinguish this event from others in various data sources.
   */
  static String calculateEventId(Map<String, ?> event) {
    dateFormat.parse(event['date'].toString()).format('yyyyMMdd', timeZone)
  }

  static String calculateInvitationCampaignTitle(Map event) {
    "LatCraft ${event.theme} Invitation ${calculateEventId(event)}".toString()
  }

  static boolean isFutureEvent(Map<String, ?> event) {
    dateTimeFormat.parse("${event['date']} ${event['time'] ?: '18:30'}") > new Date()
  }

  static boolean validateRequiredFields(Map<String, ?> event) {
    String[] requireFields = ['theme', 'desc', 'time', 'date', 'tickets']
    requireFields.every { isNotBlank(event.get(it) as String) }
  }

}
