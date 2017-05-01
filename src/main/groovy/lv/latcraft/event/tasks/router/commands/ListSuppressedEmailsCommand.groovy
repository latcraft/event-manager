package lv.latcraft.event.tasks.router.commands

import groovy.util.logging.Log4j

@Log4j("logger")
class ListSuppressedEmailsCommand extends BaseCommand {

  @Override
  String getPrefix() { "list suppressions" }

  @Override
  String getDescription() { "list suppressions" }

  @Override
  String apply(String command) {
    Map<String, String> response = [:]
    sendGrid.suppressions.each { suppression ->
      logger.info "${suppression.email} (${suppression.group_name})"
      response[suppression.email.toString()] = suppression.group_name as String
    }
    sendGrid.globalUnsubscribes.each { unsubscribe ->
      logger.info "${unsubscribe.email} (global)"
      response[unsubscribe.email.toString()] = "Global Unsubscribe"
    }
    sendGrid.invalidEmails.each { invalidEmail ->
      logger.info "${invalidEmail.email} (${invalidEmail.reason})"
      response[invalidEmail.email.toString()] = invalidEmail.reason as String
    }
    sendGrid.spamReports.each { spamReport ->
      logger.info "${spamReport.email} (spam)"
      response[spamReport.email.toString()] = "Spam Report"
    }
    "Master, here are SendGrid's suppressed emails: \n" + response.collect { key, value -> "${key} (${value})" }.join("\n")
  }

}
