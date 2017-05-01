package lv.latcraft.event.tasks.router.commands

abstract class BaseCommand implements Command {

  List<String> getCommandParameterList(String command) {
    command.replaceAll(prefix, '').trim().split(/[\s\t\r\n]+/).toList()
  }

}
