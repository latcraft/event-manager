package lv.latcraft.event.tasks.router.commands

import lv.latcraft.event.tasks.CreateNewEvent

class ListEventTemplatesCommand implements Command {

  @Override
  String getPrefix() { "list event templates" }

  @Override
  String getDescription() { "list event templates" }

  @Override
  String apply(String command) {
    """The following event templates are available to you, master:
    ${CreateNewEvent.EVENT_TEMPLATES.join('\n    ')}"""
  }

}
