package lv.latcraft.event.tasks.router

import com.amazonaws.services.lambda.runtime.Context
import lv.latcraft.event.lambda.mock.InternalContext
import lv.latcraft.event.tasks.BaseTask
import lv.latcraft.event.tasks.router.commands.*

import static lv.latcraft.event.integrations.Configuration.slackCommandSecret

class CraftBotCommands extends BaseTask {

  static final Map<String, Command> commands = [:]
  static {
    addCommand(new ListCardTemplatesCommand())
    addCommand(new ListEventBriteVenuesCommand())
    addCommand(new ListSuppressedEmailsCommand())
    addCommand(new CopyContactsCommand())
    addCommand(new PublishCardsOnS3Command())
    addCommand(new PublishEventOnEventBriteCommand())
    addCommand(new PublishEventOnSendGridCommand())
  }

  static void addCommand(Command c) {
    commands[c.prefix] = c
  }

  Map<String, String> doExecute(Map<String, String> input, Context context) {
    if (input.containsKey('token') && input.token == slackCommandSecret) {
      if (input.containsKey('text') && input.text) {
        if (input.text.startsWith('help')) {
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
            if (input.text.startsWith(prefix)) {
              response = [
                "response_type": "in_channel",
                "text"         : command.apply(input.text)
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

  static void main(String[] args) {
    new CraftBotCommands().execute([:], new InternalContext())
  }

}
