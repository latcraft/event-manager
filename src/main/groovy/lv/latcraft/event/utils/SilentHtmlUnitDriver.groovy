package lv.latcraft.event.utils

import com.gargoylesoftware.htmlunit.Page
import com.gargoylesoftware.htmlunit.SilentCssErrorHandler
import com.gargoylesoftware.htmlunit.html.HtmlPage
import org.openqa.selenium.htmlunit.HtmlUnitDriver

class SilentHtmlUnitDriver extends HtmlUnitDriver {

  SilentHtmlUnitDriver() {
    super()
    this.webClient.cssErrorHandler = new SilentCssErrorHandler()
  }

  HtmlPage getLastPage() {
    lastPage() as HtmlPage
  }

}
