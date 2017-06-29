package lv.latcraft.event.tasks

import com.amazonaws.services.lambda.runtime.Context
import com.gargoylesoftware.htmlunit.html.HtmlHiddenInput
import geb.Browser
import groovy.util.logging.Log4j
import lv.latcraft.event.lambda.mock.InternalContext
import lv.latcraft.event.utils.SilentHtmlUnitDriver

import java.util.logging.Level
import java.util.logging.Logger

import static lv.latcraft.event.integrations.Configuration.lanyrdPassowrd
import static lv.latcraft.event.integrations.Configuration.lanyrdUser
import static lv.latcraft.event.utils.Constants.getDateFormat
import static lv.latcraft.event.utils.Constants.getTimeZone

@Log4j("logger")
class PublishEventOnLanyrd extends BaseTask {

  @Override
  Map<String, String> doExecute(Map<String, String> request, Context context) {
    Map response = [:]
    futureEvents.each { Map event ->
      login().with {
        if (!event.lanyrd) {

          go '/add'
          fillEventDetails(event)
          finalizeEventCreation()
          saveLanyrdUrlToGitHub(event)

        } else {

          go "${event.lanyrd}edit"
          fillEventDetails(event)
          finalizeUpdate()

        }

        updateEventTimes(event)
        updateEventSchedule(event)
        // TODO: updateEventSpeakers(event)
        // TODO: assignSpeakersToSessions(event)
        // TODO: updateEventStaff(event)
        // TODO: updateEventCoverage(event)
        // TODO: updateEventVenue(event)
        // TODO: claimEvent(event)
        // TODO: addEventToSeries(event)
        // TODO: addEventTopics(event)

      }
    }
    response
  }

  private void updateEventSchedule(Map event) {
    browser.with {
      go "${event.lanyrd}edit/schedule/"
      if (!$("p", class: "tagline pullup-tag").empty) {
        if ($("p", class: "tagline pullup-tag").text() == 'There are currently no sessions added to this event') {
          event.schedule.each { Map<String, ?> session ->
            if (session.type == 'speech') {
              go "${event.lanyrd}edit/schedule/add/"
              logger.info('Creating session ' + session.title)
              $("input", id: "id_title").value(session.title)
              $("input", id: "id_abstract").value(session.description)
              $("input", id: "id_start_time").value(session.time)
              $("input", id: "id_end_time").value('')
              $("input", type: "submit", value: "Save session").click()
              logger.info('Session created!')
            }
          }
        } else {
          // TODO: finish session update
          $("div", class: "sessions-table").$("div", class: "js-picker-row js-picker-simple row").each { row ->
            // TODO: row.$("a", class: "js-picker-ajax icon micro-edit").click()
          }
        }
      }
    }
  }

  private void updateEventTimes(Map event) {
    browser.with {
      go "${event.lanyrd}edit/times/"
      String prefix = 'id_' + dateFormat.parse(event.date as String).format('yyyyMMdd', timeZone)
      logger.info('Filling in event start and end times')
      $("input", id: "${prefix}-open_time").value(event.time)
      $("input", id: "${prefix}-close_time").value(event.endTime)
      finalizeUpdate()
    }
  }

  private void fillEventDetails(Map event) {
    browser.with {
      logger.info('Filling in event details')
      $("input", id: "id_name").value("LatCraft | ${event.theme}")
      $("input", id: "id_tagline").value(event.desc)
      $("input", id: "id_online_conference").value(true)
      $("input", id: "id_url").value('http://latcraft.lv')
      $("input", id: "id_start_date").value(dateFormat.parse(event.date as String).format('yyyy-MM-dd', timeZone))
      $("input", id: "id_twitter_account").value('@latcraft')
      $("input", id: "id_twitter_hash_tag").value('#latcraft')
      logger.info('Setting location to Riga')
      $("input", id: "id_location").value('Riga, Latvia')
      updateHiddenValue("854823", "id_exact_location")
      logger.info('Event details are filled in')
    }
  }

  private void finalizeEventCreation() {
    browser.with {
      $("input", type: "radio", name: 'you_are', value: 'organising').click()
      $("input", type: "submit", value: "Add event").click()
      checkMaintenanceMode()
      waitFor { $("h1", class: 'summary') }
      logger.info("New Lanyrd event created at: ${currentUrl}")
    }
  }

  private void finalizeUpdate() {
    browser.with {
      $("input", type: "submit", value: "Save changes").click()
      checkMaintenanceMode()
      if (!$("ul", class: 'errorlist').empty) {
        $("ul", class: 'errorlist').children('li').each {
          logger.info("Error during update: " + it.text())
          throw new RuntimeException("Error during Lanyrd update: " + it.text())
        }
      }
      logger.info("Update completed!")
    }
  }

  private void saveLanyrdUrlToGitHub(Map event) {
    String eventId = calculateEventId(event)
    List<Map<String, ?>> eventsToUpdate = events
    eventsToUpdate.each { updatedEvent ->
      if (calculateEventId(updatedEvent) == eventId) {
        updatedEvent.lanyrd = browser.currentUrl
        event.lanyrd = browser.currentUrl
      }
    }
    updateMasterData(eventsToUpdate)
  }

  Browser login() {
    setupDriver()
    targetUrl = 'https://lanyrd.com'
    logger.info("Opened home page")
    browser.with {
      go '/signin'
      logger.info("Opened sign-in page")
      checkMaintenanceMode()
      $("input", id: "login-email") << lanyrdUser
      $("input", id: "login-password") << lanyrdPassowrd
      logger.info("Ready to login")
      $("input", type: "submit", value: "Go").click()
      logger.info("Login processed")
      checkMaintenanceMode()
      $("a", href: '/logout/?next=http://lanyrd.com/').verifyNotEmpty()
    }
    browser
  }

  private void checkMaintenanceMode() {
    if (!browser.$("h2", text: 'Lanyrd is undergoing maintenance.').empty) {
      throw new RuntimeException("Lanyrd is in maintenance, again!")
    }
  }

  private void updateHiddenValue(String value, String id) {
    HtmlHiddenInput hidden = (HtmlHiddenInput) driver.lastPage.getElementById(id)
    hidden.valueAttribute = value
  }

  void setupDriver() {
    Logger.getLogger("com.gargoylesoftware").setLevel(Level.OFF)
    Logger.getLogger("com.gargoylesoftware.htmlunit.html").setLevel(Level.SEVERE)
    browser = new Browser()
    driver = new SilentHtmlUnitDriver()
    browser.driver = driver
  }

  void setTargetUrl(String url) {
    browser.baseUrl = url
    browser.go()
  }

  SilentHtmlUnitDriver driver = null
  Browser browser = null

  static void main(String[] args) {
    new PublishEventOnLanyrd().execute([:], new InternalContext())
  }

}
