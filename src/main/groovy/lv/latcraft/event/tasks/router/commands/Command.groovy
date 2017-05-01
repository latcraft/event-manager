package lv.latcraft.event.tasks.router.commands

import java.util.function.Consumer

interface Command extends Consumer<String> {

  String getPrefix()

}
