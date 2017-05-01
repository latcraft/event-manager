package lv.latcraft.event.tasks.router.commands

import lv.latcraft.event.tasks.PublishCampaignOnSendGrid

import static lv.latcraft.event.utils.LambdaMethods.invokeLambda

class PublishEventOnSendGridCommand extends BaseCommand {

  @Override
  String getPrefix() { "publish sendgrid" }

  @Override
  String getDescription() { "publish sendgrid" }

  @Override
  String apply(String command) {
    invokeLambda(functionName(PublishCampaignOnSendGrid))
    "Please, be patient, my master, I started publishing the event!"
  }

}
