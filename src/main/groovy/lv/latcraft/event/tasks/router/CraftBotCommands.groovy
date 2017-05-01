package lv.latcraft.event.tasks.router

import com.amazonaws.services.lambda.runtime.Context
import lv.latcraft.event.lambda.mock.InternalContext
import lv.latcraft.event.tasks.BaseTask
import lv.latcraft.event.tasks.router.commands.Command
import lv.latcraft.event.tasks.router.commands.ListEventBriteVenuesCommand

import static lv.latcraft.event.integrations.Configuration.slackCommandSecret

class CraftBotCommands extends BaseTask {

  static final Map<String, Command> commands = [:]
  static {
    addCommand(new ListEventBriteVenuesCommand())
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
            "text"         : "Master, I can do the following things for you:\n" + commands.collect { it.value.prefix }.join('\n')
          ]
        } else {
          def response = [
            "error": "unknown command"
          ]
          commands.each { String prefix, Command command ->
            if (input.text.startsWith(prefix)) {
              command.accept(input.text)
              response = [:]
            }
          }
          return response
        }
      } else {
        return [
          "error": "invalid command"
        ]
      }
    } else {
      return [
        "error": "invalid token"
      ]
    }
  }

  static void main(String[] args) {
    new CraftBotCommands().execute([:], new InternalContext())
  }

}
