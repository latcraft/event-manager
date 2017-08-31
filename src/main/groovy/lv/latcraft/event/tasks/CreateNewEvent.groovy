package lv.latcraft.event.tasks

import com.amazonaws.services.lambda.runtime.Context
import groovy.json.JsonSlurper
import groovy.util.logging.Log4j
import lv.latcraft.event.lambda.mock.InternalContext

import static lv.latcraft.event.utils.Utils.dumpJson

@Log4j("logger")
class CreateNewEvent extends BaseTask {

  static final Set<String> EVENT_TEMPLATES = [
    '3sessions',
    '2sessions1quickie',
    '4quickies',
    'panel',
    'workshop',
    'workshop3trainers',
  ]

  @Override
  Map<String, String> doExecute(Map<String, String> request, Context context) {

    Map response = [:]

    // Parse request parameters
    String templateId = request.containsKey('template') && request.template ? request.template : EVENT_TEMPLATES.first()
    boolean dryRun = request.containsKey('dryRun') ? Boolean.valueOf(request.dryRun) : false
    logger.info("Selected templateId: ${templateId}")
    logger.info("Dry run: ${dryRun}")

    if (futureEvents.size() > 0 && !dryRun) {
      slack.send("I'm sorry, master, but it seems that there's already one event planned, so, I will not create another one! Please, edit the `events.json` file directly.")
    } else {
      Map<String, ?> template = new JsonSlurper().parseText(getEventTemplate(templateId)) as Map<String, ?>
      template.date = nextEventDateAsString()
      template.month = nextEventMonth()
      if (!dryRun) {
        insertTemplate(template, templateId)
      } else {
        sendTemplate(templateId, template)
      }
    }

    response

  }

  void insertTemplate(Map<String, ?> template, String templateId) {
    events.add(0, template)
    updateMasterData(events)
    slack.send("Master, I have added new event template (${templateId}) for you!")
  }

  void sendTemplate(String templateId, Map<String, ?> template) {
    slack.send("""Master, here goes event template (${templateId}) that you can insert into the `events.json` file: 
```
${dumpJson(template)}
```""")
  }

  static String getEventTemplate(String templateId) {
    String templateName = "${templateId}.json"
    getClass().getResource("/templates/${templateName}")?.text ?: new File("templates/${templateName}").text
  }

  static void main(String[] args) {
    new CreateNewEvent().execute([dryRun: 'true'], new InternalContext())
  }

}
