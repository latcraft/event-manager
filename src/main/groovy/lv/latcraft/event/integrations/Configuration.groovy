package lv.latcraft.event.integrations

import com.amazonaws.services.kms.AWSKMSClient
import com.amazonaws.services.kms.model.DecryptRequest
import com.amazonaws.services.kms.model.DecryptResult
import com.amazonaws.services.s3.AmazonS3Client
import com.amazonaws.services.s3.model.S3Object

import java.nio.ByteBuffer

import static lv.latcraft.event.utils.LambdaMethods.isInsideLambda


class Configuration {

  private final static Properties LOCAL_PROPERTIES = new Properties()

  static {
    File localPropertiesFile = new File('local.properties')
    if (insideLambda) {
      localPropertiesFile = new File('/tmp/local.properties')
      S3Object object = new AmazonS3Client().getObject('latcraft-code', 'local.properties.base64')
      localPropertiesFile.bytes = decrypt(Base64.decoder.decode(object.objectContent.text))
    }
    if (localPropertiesFile.exists()) {
      LOCAL_PROPERTIES.load(localPropertiesFile.newInputStream())
    }
  }

  private static byte[] decrypt(byte[] data) {
    DecryptRequest decryptRequest = new DecryptRequest().withCiphertextBlob(ByteBuffer.wrap(data))
    DecryptResult result = new AWSKMSClient().decrypt(decryptRequest)
    byte[] resultData = new byte[result.plaintext.remaining()]
    result.plaintext.get(resultData)
    resultData
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
