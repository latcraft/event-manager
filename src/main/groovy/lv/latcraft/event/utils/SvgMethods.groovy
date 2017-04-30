package lv.latcraft.event.utils

import groovy.util.logging.Commons
import groovy.xml.XmlUtil
import org.apache.avalon.framework.configuration.Configuration
import org.apache.avalon.framework.configuration.DefaultConfigurationBuilder
import org.apache.avalon.framework.container.ContainerUtil
import org.apache.batik.transcoder.TranscoderException
import org.apache.batik.transcoder.TranscoderInput
import org.apache.batik.transcoder.TranscoderOutput
import org.apache.batik.transcoder.image.PNGTranscoder
import org.apache.fop.svg.PDFTranscoder

import static lv.latcraft.event.utils.LambdaMethods.*

import static java.lang.Boolean.FALSE
import static java.nio.charset.StandardCharsets.UTF_8
import static lv.latcraft.event.utils.FileMethods.temporaryFile
import static org.apache.batik.transcoder.SVGAbstractTranscoder.KEY_PIXEL_UNIT_TO_MILLIMETER
import static org.apache.batik.transcoder.SVGAbstractTranscoder.KEY_USER_STYLESHEET_URI
import static org.apache.batik.transcoder.XMLAbstractTranscoder.KEY_XML_PARSER_VALIDATING
import static org.apache.fop.svg.AbstractFOPTranscoder.KEY_AUTO_FONTS
import static org.apache.fop.svg.AbstractFOPTranscoder.KEY_STROKE_TEXT

@Commons
class SvgMethods {

  private static final int DEFAULT_DPI = 300

  static File renderPDF(File svgFile) {
    PDFTranscoder t = configureFonts(new PDFTranscoder())
    String svgURI = svgFile.toURI().toString()
    File pdfFile = temporaryFile('temporary', '.pdf')
    try {
      t.transcode(
        new TranscoderInput(svgURI),
        new TranscoderOutput(
          new FileOutputStream(pdfFile)
        )
      )
    } catch (TranscoderException e) {
      // Let's be very verbose about error logging, since it's very hard to debug FOP exceptions.
      log.debug(e)
      log.debug(e?.exception)
      log.debug(e?.exception?.cause)
      throw e
    }
    pdfFile
  }

  static File renderPNG(File svgFile) {
    PNGTranscoder t = configureFonts(new PNGTranscoder())
    String svgURI = svgFile.toURI().toString()
    File pngFile = temporaryFile('temporary', '.png')
    try {
      t.transcode(
        new TranscoderInput(svgURI),
        new TranscoderOutput(
          new FileOutputStream(pngFile)
        )
      )
    } catch (TranscoderException e) {
      log.debug(e)
      log.debug(e?.exception)
      log.debug(e?.exception?.cause)
      throw e
    }
    pngFile
  }

  private static PNGTranscoder configureFonts(PNGTranscoder t) {
    File cssFile = temporaryFile('temporary', '.css')
    cssFile.text = """
      @font-face { 
        font-family: 'sans-serif'; 
        src: url('src/main/resources/fonts/arial.ttf') format('truetype'); 
      } 
      @font-face { 
        font-family: 'sans-serif'; 
        src: url('src/main/resources/fonts/arialb.ttf') format('truetype');
        font-weight: bold;         
      } 
      @font-face { 
        font-family: 'sans-serif'; 
        src: url('src/main/resources/fonts/ariali.ttf') format('truetype');
        font-style: italic, oblique;         
      } 
      @font-face { 
        font-family: 'sans-serif'; 
        src: url('src/main/resources/fonts/arialbi.ttf') format('truetype');
        font-style: italic, oblique;         
        font-weight: bold;                 
      } 
      @font-face { 
        font-family: 'Economica'; 
        src: url('src/main/resources/fonts/economica.ttf') format('truetype'); 
      } 
      @font-face { 
        font-family: 'Britannic Bold'; 
        src: url('src/main/resources/fonts/britannic-bold.ttf') format('truetype'); 
      } 
    """
    t.addTranscodingHint(KEY_PIXEL_UNIT_TO_MILLIMETER, new Float((float) (25.4 / DEFAULT_DPI)))
    t.addTranscodingHint(KEY_USER_STYLESHEET_URI, cssFile.toURI().toString())
    t
  }

  private static PDFTranscoder configureFonts(PDFTranscoder t) {
    DefaultConfigurationBuilder cfgBuilder = new DefaultConfigurationBuilder()
    Configuration cfg = cfgBuilder.build(rendererConfiguration)
    ContainerUtil.configure(t, cfg)
    t.addTranscodingHint(KEY_PIXEL_UNIT_TO_MILLIMETER, new Float((float) (25.4 / DEFAULT_DPI)))
    t.addTranscodingHint(KEY_XML_PARSER_VALIDATING, FALSE)
    t.addTranscodingHint(KEY_STROKE_TEXT, FALSE)
    t.addTranscodingHint(KEY_AUTO_FONTS, FALSE)
    t
  }

  private static InputStream getRendererConfiguration() {
    File configFile = new File(insideLambda ? "/var/task/fonts/pdf-renderer-cfg.xml" : "fonts/pdf-renderer-cfg.xml")
    if (configFile.exists()) {
      log.debug "DEBUG: Using PDF renderer configuration: ${configFile.absolutePath}"
      if (insideLambda) {
        System.setProperty('user.home', System.getProperty('java.io.tmpdir'))
        def xml = new XmlParser().parse(configFile)
        xml.fonts.font.each {
          it.@'embed-url' = '/var/task/' + (it.@'embed-url' as String)
        }
        return new ByteArrayInputStream(XmlUtil.serialize(xml).getBytes(UTF_8))
      } else {
        return configFile.newInputStream()
      }
    } else {
      throw new RuntimeException('PDF renderer configuration is not found!')
    }
  }

}
