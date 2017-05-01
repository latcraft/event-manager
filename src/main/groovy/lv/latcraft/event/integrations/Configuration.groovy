package lv.latcraft.event.integrations

import com.amazonaws.services.kms.AWSKMS
import com.amazonaws.services.kms.AWSKMSClientBuilder
import com.amazonaws.services.kms.model.DecryptRequest
import com.amazonaws.services.kms.model.DecryptResult
import com.amazonaws.services.s3.AmazonS3
import com.amazonaws.services.s3.AmazonS3ClientBuilder
import com.amazonaws.services.s3.model.S3Object
import com.amazonaws.util.Base64
import groovy.util.logging.Log4j

import java.nio.ByteBuffer

import static lv.latcraft.event.utils.LambdaMethods.isInsideLambda

@Log4j("configLogger")
class Configuration {

  private final static Properties LOCAL_PROPERTIES = new Properties()

  static {
    try {
      File localPropertiesFile = new File('local.properties')
      if (insideLambda) {
        configLogger.info("Executing from within Lambda context")
        localPropertiesFile = File.createTempFile("local", "properties")
        S3Object object = defaultS3().getObject('latcraft-code', 'local.properties.encrypted.base64')
        configLogger.info("Retrieved encrypted properties file")
        localPropertiesFile.bytes = decrypt(Base64.decode(object.objectContent.text.trim()))
      }
      if (localPropertiesFile.exists()) {
        LOCAL_PROPERTIES.load(localPropertiesFile.newInputStream())
      }
    } catch (Throwable t) {
      configLogger.fatal("Problem during initialization", t)
      throw t
    }
  }

  private static byte[] decrypt(byte[] data) {
    DecryptRequest decryptRequest = new DecryptRequest().withCiphertextBlob(ByteBuffer.wrap(data))
    DecryptResult result = defaultKMS().decrypt(decryptRequest)
    byte[] resultData = new byte[result.plaintext.remaining()]
    result.plaintext.get(resultData)
    resultData
  }

  private static AmazonS3 defaultS3() {
    AmazonS3ClientBuilder.standard().build()
  }

  private static AWSKMS defaultKMS() {
    AWSKMSClientBuilder.standard().build()
  }

  private static String getConfigProperty(String name) {
    System.getProperty(name) ?: LOCAL_PROPERTIES.get(name)
  }

  static String getEventbriteToken() {
    getConfigProperty('latcraftEventbriteToken')
  }

  static String getGitHubToken() {
    getConfigProperty('latcraftGitHubToken')
  }

  static String getSendGridApiKey() {
    getConfigProperty('latcraftSendGridApiKey')
  }

  static String getEventDataFile() {
    getConfigProperty('latcraftEventDataFile')
  }

  static String getEventbriteTemplateBaseDir() {
    getConfigProperty('latcraftEventBriteTemplateBaseDir')
  }

  static String getEventbriteVenueId() {
    getConfigProperty('latcraftEventbriteVenueId')
  }

  static String getEventbriteCapacity() {
    getConfigProperty('latcraftEventbriteCapacity')
  }

  static String getEventbriteOrganizerId() {
    getConfigProperty('latcraftEventbriteOrganizerId')
  }

  static String getEventbriteLogoId() {
    getConfigProperty('latcraftEventbriteLogoId')
  }

  static String getEventbriteCategoryId() {
    getConfigProperty('latcraftEventbriteCategoryId')
  }

  static String getEventbriteSubcategoryId() {
    getConfigProperty('latcraftEventbriteSubcategoryId')
  }

  static String getEventbriteFormatId() {
    getConfigProperty('latcraftEventbriteFormatId')
  }

  static String getDefaultSlackHookUrl() {
    getConfigProperty('latcraftSlackHookUrl')
  }

  static String getSlackCommandSecret() {
    getConfigProperty('latcraftSlackCommandSecret')
  }

  static String getSendGridDefaultListId() {
    getConfigProperty('latcraftSendGridDefaultListId')
  }

  static String getSendGridDefaultSenderId() {
    getConfigProperty('latcraftSendGridDefaultSenderId')
  }

  static String getSendGridDefaultUnsubscribeGroupId() {
    getConfigProperty('latcraftSendGridDefaultUnsubscribeGroupId')
  }

  static String getNewsletterTemplateBaseDir() {
    getConfigProperty('latcraftNewsletterTemplateBaseDir')
  }

  static String getAwsAccessKeyId() {
    getConfigProperty('latcraftAwsAccessKeyId')
  }

  static String getAwsSecretAccessKey() {
    getConfigProperty('latcraftAwsSecretAccessKey')
  }

  static String getGitCommitter() {
    getConfigProperty('latcraftGitCommitter')
  }

  static String getGitEmail() {
    getConfigProperty('latcraftGitEmail')
  }

}
