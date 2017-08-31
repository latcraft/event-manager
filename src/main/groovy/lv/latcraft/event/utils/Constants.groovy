package lv.latcraft.event.utils

import groovy.text.SimpleTemplateEngine

import java.security.MessageDigest
import java.text.SimpleDateFormat

import static java.util.TimeZone.getTimeZone

class Constants {

  static templateEngine = new SimpleTemplateEngine()
  static timeZone = getTimeZone('Europe/Riga')
  static gmt = getTimeZone("GMT")
  static dateFormat = new SimpleDateFormat('d MMMM, yyyy')
  static monthFormat = new SimpleDateFormat('MMMM yyyy')
  static dateTimeFormat = new SimpleDateFormat('d MMMM, yyyy HH:mm')
  static isoDateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss")
  static sha1 = MessageDigest.getInstance("SHA1")

  static {
    dateFormat.timeZone = timeZone
    dateTimeFormat.timeZone = timeZone
    isoDateFormat.timeZone = timeZone
  }

}
