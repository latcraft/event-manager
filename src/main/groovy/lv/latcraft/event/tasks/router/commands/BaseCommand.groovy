package lv.latcraft.event.tasks.router.commands

import groovy.util.logging.Log4j
import lv.latcraft.event.integrations.EventBrite
import lv.latcraft.event.integrations.GitHub
import lv.latcraft.event.integrations.SendGrid
import lv.latcraft.event.integrations.Slack
import lv.latcraft.event.tasks.BaseTask

@Log4j("commandLogger")
abstract class BaseCommand implements Command {

  EventBrite eventBrite = new EventBrite()
  Slack slack = new Slack()
  GitHub gitHub = new GitHub()
  SendGrid sendGrid = new SendGrid()

  List<String> getCommandParameterList(String command) {
    command.replaceAll(prefix, '').trim().split(/[\s\t\r\n]+/).toList()
  }

  static String functionName(Class<? extends BaseTask> taskClass) {
    taskClass.simpleName.split("(?<!(^|[A-Z]))(?=[A-Z])|(?<!^)(?=[A-Z][a-z])").join('_') + '_function'
  }

}
