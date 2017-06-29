package lv.latcraft.event.tasks.router

import com.amazonaws.services.lambda.runtime.Context
import lv.latcraft.event.lambda.mock.InternalContext
import lv.latcraft.event.tasks.BaseTask
import lv.latcraft.event.tasks.router.commands.*

import static lv.latcraft.event.integrations.Configuration.slackCommandSecret

class CraftBotCommands extends BaseTask {

  static {
    addCommand(new ListCardTemplatesCommand())
    addCommand(new ListEventBriteVenuesCommand())
    addCommand(new ListSuppressedEmailsCommand())
    addCommand(new ListEventTemplatesCommand())
    addCommand(new CopyContactsCommand())
    addCommand(new CreateNewEventCommand())
    addCommand(new PublishCardsOnS3Command())
    addCommand(new PublishEventOnEventBriteCommand())
    addCommand(new PublishEventOnSendGridCommand())
    addCommand(new PublishEventOnLanyrdCommand())
    addCommand(new SendCampaignOnSendGridCommand())
    addCommand(new GetStatsFromEventBriteCommand())
  }

  Map<String, String> doExecute(Map<String, String> request, Context context) {
    if (request.containsKey('token') && request.token == slackCommandSecret) {
      if (request.containsKey('text') && request.text) {
        if (request.text.startsWith('help')) {
          return [
            "response_type": "in_channel",
            "text"         : "Master, I can do the following things for you:\n" + commands.collect { "    " + it.value.description }.join('\n')
          ]
        } else {
          def response = [
            "response_type": "in_channel",
            "text": "I'm very sorry, master, I do not know such a command. Please, make me smarter!"
          ]
          commands.each { String prefix, Command command ->
            if (request.text.startsWith(prefix)) {
              response = [
                "response_type": "in_channel",
                "text"         : command.apply(request.text)
              ]
            }
          }
          return response
        }
      } else {
        return [
          "text": "invalid command"
        ]
      }
    } else {
      return [
        "text": "invalid token"
      ]
    }
  }

  static final Map<String, Command> commands = [:]

  static void addCommand(Command c) {
    commands[c.prefix] = c
  }

  static void main(String[] args) {
    new CraftBotCommands().execute([:], new InternalContext())
  }

}
