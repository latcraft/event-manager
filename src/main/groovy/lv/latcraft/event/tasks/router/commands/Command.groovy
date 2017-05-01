package lv.latcraft.event.tasks.router.commands

import java.util.function.Function

interface Command extends Function<String, String> {

  String getPrefix()

}
