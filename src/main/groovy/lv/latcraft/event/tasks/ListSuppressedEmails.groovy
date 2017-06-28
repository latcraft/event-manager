package lv.latcraft.event.tasks

import com.amazonaws.services.lambda.runtime.Context
import groovy.util.logging.Log4j
import lv.latcraft.event.lambda.mock.InternalContext

@Log4j("logger")
class ListSuppressedEmails extends BaseTask {

  @Override
  Map<String, String> doExecute(Map<String, String> request, Context context) {
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
    slack.send("Master, here are SendGrid's suppressed emails: \n" + response.collect { key, value -> "${key} (${value})" }.join("\n"))
    response
  }

  static void main(String[] args) {
    new ListSuppressedEmails().execute([:], new InternalContext())
  }

}
