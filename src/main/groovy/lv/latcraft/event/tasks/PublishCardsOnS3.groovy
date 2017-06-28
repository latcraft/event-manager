package lv.latcraft.event.tasks

import com.amazonaws.services.lambda.runtime.Context
import groovy.util.logging.Log4j
import groovy.util.slurpersupport.GPathResult
import groovy.xml.XmlUtil
import lv.latcraft.event.lambda.mock.InternalContext
import org.apache.commons.lang.WordUtils

import static lv.latcraft.event.utils.FileMethods.temporaryFile
import static lv.latcraft.event.utils.S3Methods.*
import static lv.latcraft.event.utils.SanitizationMethods.replaceLatvianLetters
import static lv.latcraft.event.utils.SvgMethods.renderPNG
import static lv.latcraft.event.utils.XmlMethods.setAttributeValue
import static lv.latcraft.event.utils.XmlMethods.setElementValue

@Log4j("logger")
class PublishCardsOnS3 extends BaseTask {

  static final Set<String> EVENT_CARDS = [
    'normal_event_card_v1',                // twitter, linkedin
    'normal_event_card_v2',
    'normal_event_card_v3',
    'normal_event_facebook_background_v1',
    'normal_event_facebook_background_v2',
    'workshop_event_card_v1',
    'workshop_event_card_v2',
    'workshop_facebook_background_v1',
  ]

  static final Set<String> SPEAKER_CARDS = [
    'speaker_card_v1',
    'speaker_card_v2',
  ]

  Map<String, String> doExecute(Map<String, String> request, Context context) {

    // Parse request parameters
    Set<String> selectedCards = request.containsKey('cards') && request.cards ? request.cards.split(',') as Set : EVENT_CARDS + SPEAKER_CARDS
    boolean sendLinksToSlack = request.containsKey('sendLinksToSlack') ? Boolean.valueOf(request.sendLinksToSlack) : true
    boolean updateEventData = request.containsKey('updateEventData') ? Boolean.valueOf(request.updateEventData) : true
    logger.info("Selected cards: ${selectedCards}")
    logger.info("Send Slack message: ${sendLinksToSlack}")
    logger.info("Update event data: ${updateEventData}")

    Map<String, String> response = [:]
    boolean cardsGenerated = false
    futureEvents.each { Map<String, ?> event ->

      String eventId = calculateEventId(event)

      if (!event.containsKey('cards')) {
        event['cards'] = [:]
      }

      EVENT_CARDS.findAll { selectedCards.contains(it) }.each { String templateId ->

        String filePrefix = "event-${templateId}-${eventId}"
        File cardFile = temporaryFile(filePrefix, '.svg')
        cardFile.text = generateEventCard(getSvgTemplate(templateId), event)

        def cards = generateCards(filePrefix, cardFile)
        // Save result S3 object URLs.
        response << cards
        event['cards'] << cards
        cardsGenerated = true
      }

      event.schedule.each { Map<String, ?> session ->
        if (session.type == 'speech') {

          String speakerId = replaceLatvianLetters(session.name as String).trim().toLowerCase().replaceAll('[ ]', '_')

          if (!session.containsKey('cards')) {
            session['cards'] = [:]
          }

          SPEAKER_CARDS.findAll { selectedCards.contains(it) }.each { String templateId ->

            String filePrefix = "event-${templateId}-${eventId}-${speakerId}"
            File cardFile = temporaryFile(filePrefix, '.svg')
            cardFile.text = generateSpeakerCard(getSvgTemplate(templateId), event, session)

            def cards = generateCards(filePrefix, cardFile)
            // Save result S3 object URLs.
            response << cards
            event['cards'] << cards
            cardsGenerated = true
          }
        }
      }

      // Update master data on GitHub.
      if (cardsGenerated && updateEventData) {
        List<Map<String, ?>> eventsToUpdate = events
        eventsToUpdate.eachWithIndex { eventToUpdate, i ->
          if (calculateEventId(eventToUpdate) == eventId) {
            eventsToUpdate[i] = event
          }
        }
        updateMasterData(eventsToUpdate)
      }

      // Send Slack message.
      if (cardsGenerated) {
        slack.send("Good news, master! Event card(s) are uploaded to AWS S3!")
        if (sendLinksToSlack) {
          response.sort { it.key }.each { key, value ->
            slack.send(value)
          }
        }
      } else {
        slack.send("Master, I know you asked me to generate some cards, but it looks like there is nothing to do. Either there are no future events or card you asked me to generate does not exist. I'm very sorry, master!")
      }

    }
    response
  }

  private Map<String, String> generateCards(String filePrefix, File cardFile) {
    def cards = [:]
    // Generate event card.
    logger.info "Generating ${filePrefix}"
    def pngFile = renderPNG(cardFile)
    s3.putObject(putRequest("${filePrefix}.png", pngFile))
    String pngObjectUrl = getObjectUrl("${filePrefix}.png")
    logger.info("Object created/updated: ${pngObjectUrl}")
    cards[filePrefix] = pngObjectUrl

    cards
  }

  static String getSvgTemplate(String templateId) {
    String templateName = "${templateId}.svg"
    getClass().getResource("/cards/${templateName}")?.text ?: new File("cards/${templateName}").text
  }

  static String generateEventCard(String svgTemplateText, Map<String, ?> event) {
    GPathResult svg = new XmlSlurper().parseText(svgTemplateText)
    setElementValue(svg, 'event-title', (event.'short-theme' ?: event.theme) as String)
    setElementValue(svg, 'event-time', event.time as String)
    setElementValue(svg, 'event-date', event.date as String)
    setElementValue(svg, 'event-location', event.venue as String)
    XmlUtil.serialize(svg)
  }

  static String generateSpeakerCard(String svgTemplateText, Map<String, ?> event, Map<String, ?> session) {
    GPathResult svg = new XmlSlurper().parseText(svgTemplateText)
    def titleLines = WordUtils.wrap(session.title.toString(), 35).readLines()
    setElementValue(svg, 'event-title', (event.'short-theme' ?: event.theme) as String)
    setElementValue(svg, 'speaker-name', replaceLatvianLetters(session.name as String))
    setElementValue(svg, 'session-title-line1', titleLines.first())
    setElementValue(svg, 'session-title-line2', titleLines.size() > 1 ? titleLines.get(1) : '')
    setElementValue(svg, 'event-time', session.time as String)
    setElementValue(svg, 'event-date', event.date as String)
    setElementValue(svg, 'event-location', event.venue as String)
    setAttributeValue(svg, 'speaker-image', 'xlink:href', "data:image/png;base64,${new URL("http://latcraft.lv/${session.img}").bytes.encodeBase64().toString().toList().collate(76)*.join('').join(' ')}".toString())
    XmlUtil.serialize(svg)
  }

  static void main(String[] args) {
    new PublishCardsOnS3().execute([
      cards           : 'normal_event_card_v3',
      sendLinksToSlack: 'true',
      updateEventData : 'false',
    ], new InternalContext())
  }

}
