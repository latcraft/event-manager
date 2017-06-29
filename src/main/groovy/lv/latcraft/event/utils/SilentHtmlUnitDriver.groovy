package lv.latcraft.event.utils

import com.gargoylesoftware.htmlunit.SilentCssErrorHandler
import org.openqa.selenium.htmlunit.HtmlUnitDriver

class SilentHtmlUnitDriver extends HtmlUnitDriver {
  SilentHtmlUnitDriver() {
    super()
    this.webClient.cssErrorHandler = new SilentCssErrorHandler()
  }
}
