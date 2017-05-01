package lv.latcraft.event.tasks.router.commands

import lv.latcraft.event.tasks.ListSuppressedEmails
import lv.latcraft.event.tasks.SendCampaignOnSendGrid

import static lv.latcraft.event.utils.LambdaMethods.invokeLambda

class SendCampaignOnSendGridCommand extends BaseCommand {

  @Override
  String getPrefix() { "send campaign" }

  @Override
  String getDescription() { "send campaign" }

  @Override
  String apply(String command) {
    invokeLambda(functionName(SendCampaignOnSendGrid))
    "Master, I initiated a request for campaign sending!"
  }
}
