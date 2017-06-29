package lv.latcraft.event.tasks

import com.amazonaws.services.lambda.runtime.Context
import geb.Browser
import groovy.util.logging.Log4j
import lv.latcraft.event.lambda.mock.InternalContext
import lv.latcraft.event.utils.SilentHtmlUnitDriver
import org.openqa.selenium.WebDriver

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
          finalizeEventUpdate()

        }
      }

    }
    response
  }

  private void finalizeEventUpdate() {
    browser.with {
      $("input", type: "submit", value: "Save changes").click()
      if (!$("ul", class: 'errorlist').empty) {
        $("ul", class: 'errorlist').children('li').each {
          logger.info("Error during update: " + it.text())
          throw new RuntimeException("Error during Lanyrd update: " + it.text())
        }
      }
      $("div", class: 'notification confirmation').verifyNotEmpty()
      logger.info("Lanyrd event has been updated: ${currentUrl}")
    }
  }

  private void finalizeEventCreation() {
    browser.with {
      $("input", type: "radio", name: 'you_are', value: 'organising').click()
      $("input", type: "submit", value: "Add event").click()
      logger.debug("Page source: ${driver.pageSource}")
      waitFor { $("h1", class: 'summary') }
      logger.info("New Lanyrd event created at: ${currentUrl}")
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
      $("input", id: "id_location").value('Riga, Town in Latvia')
      logger.info('Event details are filled in')
    }
  }

  Browser login() {
    setupDriver()
    targetUrl = 'https://lanyrd.com'
    logger.info("Opened Lanyrd home page")
    browser.with {
      go '/signin'
      logger.info("Opened sign-in page")
      $("input", id: "login-email") << lanyrdUser
      $("input", id: "login-password") << lanyrdPassowrd
      logger.info("Ready to login")
      $("input", type: "submit", value: "Go").click()
      logger.info("Login processed")
      $("a", href: 'http://lanyrd.com/dashboard/').verifyNotEmpty()
    }
    browser
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

  WebDriver driver = null
  Browser browser = null

  static void main(String[] args) {
    new PublishEventOnLanyrd().execute([:], new InternalContext())
  }

}
