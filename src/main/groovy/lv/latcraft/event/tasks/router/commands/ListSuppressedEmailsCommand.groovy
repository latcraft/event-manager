package lv.latcraft.event.tasks.router.commands

import groovy.util.logging.Log4j
import lv.latcraft.event.tasks.ListSuppressedEmails

import static lv.latcraft.event.utils.LambdaMethods.invokeLambda

@Log4j("logger")
class ListSuppressedEmailsCommand extends BaseCommand {

  @Override
  String getPrefix() { "list suppressions" }

  @Override
  String getDescription() { "list suppressions" }

  @Override
  String apply(String command) {
    invokeLambda(functionName(ListSuppressedEmails))
    "Master, I started my search for suppressed emails!"
  }

}
