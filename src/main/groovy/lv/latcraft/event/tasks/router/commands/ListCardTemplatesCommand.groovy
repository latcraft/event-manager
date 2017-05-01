package lv.latcraft.event.tasks.router.commands

import lv.latcraft.event.tasks.PublishCardsOnS3

class ListCardTemplatesCommand implements Command {

  @Override
  String getPrefix() { "list cards" }

  @Override
  String getDescription() { "list cards" }

  @Override
  String apply(String command) {
    """The following event card templates are available to you, master:
     ${PublishCardsOnS3.EVENT_CARDS.join('\n    ')}

Master, and for speaker cards these templates are at your disposal:
     ${PublishCardsOnS3.SPEAKER_CARDS.join('\n    ')}
    """
  }

}
