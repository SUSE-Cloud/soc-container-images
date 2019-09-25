<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" encoding="UTF-8" indent="yes"/>
<xsl:template match="/">
<xsl:comment>
  This file is generated,
  don't manually modify this file,
  please check README
</xsl:comment>

<image schemaversion="6.9" name="memcached-image" xmlns:suse_label_helper="com.suse.label_helper">

  <description type="system">
    <author>SUSE OpenStack Cloud Team</author>
    <contact>cloud@suse.com</contact>
    <specification>memcached container</specification>
  </description>

  <preferences>
    <type image="docker">
      <xsl:attribute name="derived_from">
        <xsl:value-of select="param/container_base_image" />
      </xsl:attribute>
      <containerconfig
          user="memcached"
          additionaltags="%LONG_VERSION%,%LONG_VERSION%-%RELEASE%"
          maintainer="SUSE Cloud Team &lt;cloud@suse.com&gt;">
          <xsl:attribute name="name">
            <xsl:value-of select="param/container_name" />
          </xsl:attribute>
          <xsl:attribute name="tag">
            <xsl:value-of select="param/container_tag" />
          </xsl:attribute>

        <expose>
          <port number="11211/tcp"/>
          <port number="11211/udp"/>
        </expose>
        <subcommand execute="/usr/sbin/memcached"/>
        <entrypoint execute="/usr/local/sbin/docker-entrypoint.sh"/>

         <labels>
          <suse_label_helper:add_prefix>
            <xsl:attribute name="prefix">
              <xsl:value-of select="param/label_helper_prefix" />
            </xsl:attribute>

            <label name="org.opencontainers.image.title" value="memcached container"/>
            <label name="org.opencontainers.image.description" value="memcached container"/>
            <label name="org.opencontainers.image.version" value="%LONG_VERSION%-%RELEASE%"/>
            <label name="org.opencontainers.image.created" value="%BUILDTIME%"/>
            <label name="org.openbuildservice.disturl" value="%DISTURL%"/>

            <label name="org.opensuse.reference">
              <xsl:attribute name="value">
                <xsl:value-of select="param/reference"/>
              </xsl:attribute>
            </label>

          </suse_label_helper:add_prefix>

          <xsl:for-each select="param/labels/label">
            <label>
              <xsl:attribute name="name">
                <xsl:value-of select="name"/>
              </xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="value"/>
              </xsl:attribute>
            </label>
          </xsl:for-each>

        </labels>

        <history author="Thomas Bechtold &lt;tbechtold@suse.com&gt;">memcached</history>
     </containerconfig>
    </type>
    <version>1.0.0</version>
    <packagemanager>zypper</packagemanager>
    <rpm-check-signatures>false</rpm-check-signatures>
    <rpm-excludedocs>true</rpm-excludedocs>
  </preferences>

  <repository type='rpm-md'>
    <source path='obsrepositories:/'/>
  </repository>

  <!-- extra packages for image -->
  <xsl:variable name="packages_image" select="param/packages_image/package" />
  <xsl:if test="count($packages_image)!=0">
    <packages type="image">
      <package name="ca-certificates"/>
      <package name="memcached"/>

      <xsl:for-each select="$packages_image">
        <package>
          <xsl:attribute name="name">
            <xsl:value-of select="name"/>
          </xsl:attribute>
        </package>
      </xsl:for-each>
    </packages>
  </xsl:if>

  <!-- extra packages for bootstrap -->
  <xsl:variable name="packages_bootstrap" select="param/packages_boot/package" />
  <xsl:if test="count($packages_bootstrap)!=0">
    <packages type='bootstrap'>
      <xsl:for-each select="$packages_bootstrap">
        <package>
          <xsl:attribute name="name">
            <xsl:value-of select="name"/>
          </xsl:attribute>
        </package>
      </xsl:for-each>
    </packages>
  </xsl:if>

</image>

</xsl:template>
</xsl:stylesheet>
