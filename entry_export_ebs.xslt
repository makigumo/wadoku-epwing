<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:xs="http://www.w3.org/2001/XMLSchema"
        xmlns="http://www.w3.org/1999/xhtml"
        xmlns:wd="http://www.wadoku.de/xml/entry"
        exclude-result-prefixes="xs wd"
        version="2.0">
    <xsl:include href="gramgrp.xsl"/>

    <xsl:output
            method="xhtml"
            omit-xml-declaration="yes"
            encoding="SJIS"
            indent="yes"/>

    <!-- Parameter, der bestimmt, ob Untereinträge ihre eigenen Einträge erhalten,
         oder nur im Haupteintrag erscheinen, wenn = yes
    -->
    <xsl:param name="strictSubHeadIndex">yes</xsl:param>
    <xsl:param name="withPictures">no</xsl:param>

    <!-- Trenner für Schreibungen/Stichworte -->
    <xsl:param name="orthdivider">
        <xsl:text>；</xsl:text>
    </xsl:param>

    <!-- Trenner für Bedeutungen mit inhaltlicher Nähe -->
    <xsl:variable name="relationDivider">
        <xsl:text> ‖ </xsl:text>
    </xsl:variable>

    <!-- Kana/Symbole, die nicht als einzelne Mora gelten -->
    <xsl:variable name="letters" select="'ゅゃょぁぃぅぇぉ・･·~’￨|…'"/>

    <!-- kennzeichnet den Beginn eines Akzentverlaufs -->
    <xsl:variable name="accent_change_marker" select="'—'"/>

    <!-- lookup key für einträge mit referenzen auf einen Haupteintrag -->
    <xsl:key name="refs" match="wd:entry[./wd:ref[@type='main']]" use="./wd:ref/@id"/>

    <xsl:template match="entries">
        <html>
            <body>
                <dl>
                    <xsl:choose>
                        <xsl:when test="$strictSubHeadIndex = 'yes'">
                            <!-- nur Einträge,
                              * die Untereinträge haben
                              * ohne Untereinträge und selbst kein Untereintrag sind
                              -->
                            <xsl:for-each select="wd:entry[not(./wd:ref[@type='main']) or key('refs',@id)]">
                                <xsl:sort select="wd:form/wd:reading/wd:hira/text()"/>
                                <xsl:apply-templates select="."/>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:for-each select="wd:entry">
                                <xsl:apply-templates/>
                            </xsl:for-each>
                        </xsl:otherwise>
                    </xsl:choose>
                </dl>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="wd:entry">
        <xsl:variable name="yomi">
            <!-- no support for ゔ in JIS-X4081 -->
            <xsl:value-of select="replace(./wd:form/wd:reading/wd:hira,'ゔ','う゛')"/>
        </xsl:variable>
        <xsl:variable name="extended_yomi">
            <xsl:call-template name="reading_from_extended_yomi"/>
        </xsl:variable>
        <xsl:variable name="hyouki">
            <xsl:choose>
                <xsl:when test="./wd:form/wd:orth[@midashigo]">
                    <xsl:text>&#12304;</xsl:text>
                    <xsl:apply-templates mode="simple"
                                         select="./wd:form/wd:orth[@midashigo]"/>
                    <xsl:text>&#12305;</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:if test="./wd:form/wd:orth[not(@irr)]">
                        <xsl:text>&#12304;</xsl:text>
                        <xsl:apply-templates mode="simple"
                                             select="./wd:form/wd:orth[not(@irr) and not(@midashigo)]"/>
                        <xsl:text>&#12305;</xsl:text>
                    </xsl:if>
                    <xsl:if test="./wd:form/wd:orth[@irr]">
                        <xsl:text>&#12310;</xsl:text>
                        <xsl:apply-templates mode="simple"
                                             select="./wd:form/wd:orth[@irr]"/>
                        <xsl:text>&#12311;</xsl:text>
                    </xsl:if>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:element name="dt">
            <xsl:attribute name="id" select="@id"/>
            <xsl:attribute name="title">
                <xsl:value-of select="$yomi"/>
                <xsl:value-of select="$hyouki"/>
            </xsl:attribute>

            <xsl:copy-of select="$extended_yomi"/>
            <xsl:copy-of select="$hyouki"/>
            <!-- accent values -->
            <xsl:if test="./wd:form/wd:reading/wd:accent">
                <sub>
                    <xsl:text>[</xsl:text>
                    <xsl:for-each select="./wd:form/wd:reading/wd:accent">
                        <xsl:value-of select="."/>
                        <xsl:if test="position() lt last()">
                            <xsl:text>, </xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                    <xsl:text>]</xsl:text>
                </sub>
            </xsl:if>

        </xsl:element>

        <!-- index -->
        <xsl:variable name="idx">
            <xsl:call-template name="build_entry_index">
                <xsl:with-param name="yomi" select="$yomi"/>
            </xsl:call-template>
        </xsl:variable>
        <!-- filter duplicate index entries -->
        <xsl:for-each select="$idx">
            <xsl:copy-of select="."/>
        </xsl:for-each>
        <dd>
            <!-- meaning -->
            <!-- grammar group and global etymology-->
            <xsl:if test="./wd:gramGrp or ./wd:etym">
                <xsl:if test="./wd:gramGrp">
                    <xsl:text>(</xsl:text>
                    <xsl:apply-templates select="./wd:gramGrp"/>
                    <xsl:text>) </xsl:text>
                </xsl:if>
                <xsl:if test="./wd:etym">
                    <xsl:text>(&lt; </xsl:text>
                    <xsl:apply-templates select="./wd:etym"/>
                    <xsl:text>) </xsl:text>
                </xsl:if>
                <br/>
            </xsl:if>
            <!-- if only one sense, handle usg in sense template -->
            <xsl:apply-templates select="wd:usg"/>
            <xsl:apply-templates select="wd:sense"/>
            <xsl:if test="wd:expl">
                <p>
                    <xsl:text>(</xsl:text>
                    <xsl:apply-templates select="wd:expl"/>
                    <xsl:text>)</xsl:text>
                </p>
            </xsl:if>

            <xsl:apply-templates select="wd:ref[not(@type='main')]"/>
            <xsl:apply-templates select="wd:link"/>
            <xsl:apply-templates select="wd:link[@type='URL' or @type='url']"/>
            <xsl:if test="$withPictures = 'yes'">
                <xsl:if test="//wd:sense/wd:link[@type='picture']">
                    <xsl:apply-templates select="//wd:sense/wd:link"/>
                </xsl:if>
                <xsl:if test="wd:link[@type='picture']">
                    <xsl:apply-templates select="wd:link"/>
                </xsl:if>
            </xsl:if>
            <xsl:call-template name="entry_subs"/>
            <xsl:if test="./wd:ref[@type='main']">
                <br/>
                <xsl:apply-templates mode="global" select="./wd:ref[@type='main']"/>
            </xsl:if>
        </dd>
    </xsl:template>

    <xsl:template name="build_entry_index">
        <xsl:param name="yomi"/>
        <!-- Lesung -->
        <xsl:element name="key">
            <xsl:attribute name="type">かな</xsl:attribute>
            <xsl:value-of select="$yomi"/>
        </xsl:element>
        <!-- Lesung mit … auch ohne … in den Suchindex -->
        <xsl:if test="contains($yomi, '…')">
            <xsl:element name="key">
                <xsl:attribute name="type">かな</xsl:attribute>
                <xsl:value-of select="translate($yomi, '…', '')"/>
            </xsl:element>
        </xsl:if>
        <!-- Schreibungen -->
        <xsl:for-each select="./wd:form/wd:orth[not(@midashigo='true') and . != $yomi]">
            <xsl:element name="key">
                <xsl:attribute name="type">表記</xsl:attribute>
                <xsl:value-of select="."/>
            </xsl:element>
            <!-- Schreibung mit … auch ohne … in den Suchindex -->
            <xsl:if test="contains(., '…')">
                <xsl:element name="key">
                    <xsl:attribute name="type">表記</xsl:attribute>
                    <xsl:value-of select="translate(., '…', '')"/>
                </xsl:element>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

    <!-- Untereinträge -->
    <xsl:template name="entry_subs">
        <br/>
        <xsl:variable name="subs" select="key('refs',@id)"/>
        <xsl:if test="$subs">
            <!-- Ableitungen -->
            <xsl:variable name="hasei" select="$subs[wd:ref[
                    not(@subentrytype='head')
                    and not(@subentrytype='tail')
                    and not(@subentrytype='VwBsp')
                    and not(@subentrytype='WIdiom')
                    and not(@subentrytype='XSatz')
                    and not(@subentrytype='ZSprW')
                    and not(@subentrytype='other')
                    ]]"/>
            <xsl:if test="$hasei">
                <xsl:apply-templates mode="subentry"
                                     select="$hasei[wd:ref[@subentrytype='suru']]">
                    <xsl:sort select="./wd:form/wd:reading/wd:hira/text()"/>
                </xsl:apply-templates>
                <xsl:apply-templates mode="subentry"
                                     select="$hasei[wd:ref[@subentrytype='sa']]">
                    <xsl:sort select="./wd:form/wd:reading/wd:hira/text()"/>
                </xsl:apply-templates>
                <xsl:apply-templates mode="subentry"
                                     select="$hasei[wd:ref[not(@subentrytype='sa') and not(@subentrytype='suru')]]">
                    <xsl:sort select="./wd:form/wd:reading/wd:hira/text()"/>
                </xsl:apply-templates>
            </xsl:if>
            <!-- Komposita -->
            <xsl:if test="$subs[wd:ref[@subentrytype='head']]">
                <!-- Sichergehen, dass dieser Eintrag gemeint ist, bei evtl. Head- und tail-Kompositum -->
                <xsl:variable name="id" select="@id"/>
                <xsl:apply-templates mode="subentry"
                                     select="$subs[wd:ref[@subentrytype='head' and @id=$id]]">
                    <xsl:sort select="./wd:form/wd:reading/wd:hira/text()"/>
                </xsl:apply-templates>
            </xsl:if>
            <xsl:if test="$subs[wd:ref[@subentrytype='tail']]">
                <!-- Sichergehen, dass dieser Eintrag gemeint ist, bei evtl. Head- und tail-Kompositum -->
                <xsl:variable name="id" select="@id"/>
                <xsl:apply-templates mode="subentry"
                                     select="$subs[wd:ref[@subentrytype='tail' and @id=$id]]">
                    <xsl:sort select="./wd:form/wd:reading/wd:hira/text()"/>
                </xsl:apply-templates>
            </xsl:if>
            <!-- Rest -->
            <xsl:if test="(count($subs) - count($hasei) - count($subs[wd:ref[@subentrytype='head' or @subentrytype='tail']])) > 0">
                <xsl:apply-templates mode="subentry"
                                     select="$subs[wd:ref[@subentrytype='VwBsp']]">
                    <xsl:sort select="./wd:form/wd:reading/wd:hira/text()"/>
                </xsl:apply-templates>
                <xsl:apply-templates mode="subentry"
                                     select="$subs[wd:ref[@subentrytype='XSatz']]">
                    <xsl:sort select="./wd:form/wd:reading/wd:hira/text()"/>
                </xsl:apply-templates>
                <xsl:apply-templates mode="subentry"
                                     select="$subs[wd:ref[
                                         @subentrytype='WIdiom'
                                         or @subentrytype='ZSprW'
                                         or @subentrytype='other']]">
                    <xsl:sort select="./wd:form/wd:reading/wd:hira/text()"/>
                </xsl:apply-templates>
            </xsl:if>
        </xsl:if>
    </xsl:template>

    <xsl:function name="wd:get_accented_part" as="xs:string">
        <xsl:param name="str"/>
        <xsl:param name="accent"/>
        <xsl:choose>
            <xsl:when test="string-length(translate($str, $letters, '')) > $accent">
                <xsl:value-of select="wd:get_accented_part(substring($str, 1, string-length($str)-1), $accent)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="substring($str, 1, string-length($str)-1)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <xsl:template name="insert_divider">
        <!--
        ersetzt Pipe (|) durch span-Element mit divider class
        arbeitet auf Strings
        -->
        <xsl:param name="t"/>
        <xsl:analyze-string
                regex="￨"
                select="$t">
            <xsl:matching-substring>
                <span class="divider">￨</span>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:value-of select="."/>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template>

    <xsl:template name="reading_from_extended_yomi">
        <xsl:variable name="yomi">
            <!--
                  * entferne störende Symbole
                  * typographische Korrekturen/Vereinheitlichung
                  * behalte fullwidth space für differenzierte $accent_change_marker Konversion
                -->
            <xsl:value-of select="
                                    replace(
                                    translate(
                                    translate(
                                    replace(
                                    replace(./wd:form/wd:reading/wd:hatsuon,'\[Akz\]',$accent_change_marker),
                                    'DinSP','･'),
                                    '&lt;>/[]1234567890: GrJoDevNinSsuPWap_＿',''),
                                    &quot;・·'’&quot;, '･･￨￨'),
                                    'ゔ','う゛')
                                "/>
        </xsl:variable>

        <xsl:choose>
            <xsl:when test="./wd:form/wd:reading/wd:accent">
                <xsl:for-each select="./wd:form/wd:reading/wd:accent">
                    <xsl:if test="position() = 1">
                        <xsl:call-template name="call_mark_accent">
                            <xsl:with-param name="yomi" select="$yomi"/>
                        </xsl:call-template>
                    </xsl:if>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="insert_divider">
                    <!-- entferne nicht benötigtes full-width space -->
                    <xsl:with-param name="t"
                                    select="translate($yomi, '　', '')"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="call_mark_accent">
        <xsl:param name="yomi"/>
        <xsl:choose>
            <!-- Akzentangabe mit mehrfachem Akzentwechsel -->
            <xsl:when test="contains(., '—')">
                <!-- Auftrennen der Lesung am accent_change_marker -->
                <xsl:variable name="y" select="tokenize($yomi,$accent_change_marker)"/>
                <!--
                    Auftrennen Akzentangaben am 'em dash' und markiere den Akzent für
                    den korrespondierenden Lesungsteil.
                -->
                <xsl:for-each select="tokenize(.,'—')">
                    <xsl:variable name="pos" select="position()"/>
                    <xsl:variable name="yomi_part">
                        <xsl:value-of select="$y[$pos]"/>
                        <!-- middle dot nur für leerzeichenlose Teile -->
                        <xsl:if test="position() &lt; last() and not(ends-with($y[$pos], '　'))">
                            <xsl:text>･</xsl:text>
                        </xsl:if>
                    </xsl:variable>
                    <xsl:call-template name="mark_accent">
                        <xsl:with-param name="accent"
                                        select="number(.)"/>
                        <!-- entferne nicht mehr benötigtes full-width space -->
                        <xsl:with-param name="yomi"
                                        select="translate($yomi_part, '　', '')"/>
                    </xsl:call-template>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <!-- Akzentangabe mit einfachem Akzentwechsel -->
                <xsl:call-template name="mark_accent">
                    <xsl:with-param name="accent"
                                    select="number(.)"/>
                    <!-- konvertiere accent_change_marker in einfachen halfwidth middle dot -->
                    <!-- entferne nicht mehr benötigtes full-width space -->
                    <xsl:with-param name="yomi"
                                    select="translate(
                                    translate($yomi, $accent_change_marker,'･'),
                                    '　', '')"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="mark_accent">
        <xsl:param name="accent"/>
        <xsl:param name="yomi"/>
        <xsl:variable name="startsWithEllipsis" select="starts-with($yomi, '…')"/>
        <xsl:variable name="hiragana">
            <xsl:choose>
                <xsl:when test="$startsWithEllipsis">
                    <xsl:value-of select="substring($yomi, 2)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$yomi"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <!-- erste More aus zwei Kana, z.B. しゃ -->
        <xsl:variable name="firstMora"
                      select="string-length(translate(substring($hiragana,2,1),$letters,''))=0"/>
        <xsl:if test="$startsWithEllipsis">
            <xsl:text>…</xsl:text>
        </xsl:if>
        <!-- ⸢ ⸣ -->
        <xsl:choose>
            <xsl:when test="$accent=0">
                <xsl:choose>
                    <xsl:when test="$firstMora">
                        <xsl:call-template name="insert_divider">
                            <xsl:with-param name="t"
                                            select="substring($hiragana,1,2)"/>
                        </xsl:call-template>

                        <xsl:text>⸢</xsl:text>
                        <xsl:call-template name="insert_divider">
                            <xsl:with-param name="t"
                                            select="substring($hiragana,3)"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="insert_divider">
                            <xsl:with-param name="t"
                                            select="substring($hiragana,1,1)"/>
                        </xsl:call-template>
                        <xsl:text>⸢</xsl:text>
                        <xsl:call-template name="insert_divider">
                            <xsl:with-param name="t"
                                            select="substring($hiragana,2)"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$accent=1">
                <xsl:choose>
                    <xsl:when test="$firstMora">
                        <xsl:call-template name="insert_divider">
                            <xsl:with-param name="t"
                                            select="substring($hiragana,1,2)"/>
                        </xsl:call-template>
                        <xsl:text>⸣</xsl:text>
                        <xsl:call-template name="insert_divider">
                            <xsl:with-param name="t"
                                            select="substring($hiragana,3)"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="insert_divider">
                            <xsl:with-param name="t"
                                            select="substring($hiragana,1,1)"/>
                        </xsl:call-template>
                        <xsl:text>⸣</xsl:text>
                        <xsl:call-template name="insert_divider">
                            <xsl:with-param name="t"
                                            select="substring($hiragana,2)"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="$firstMora">
                        <xsl:call-template name="insert_divider">
                            <xsl:with-param name="t"
                                            select="substring($hiragana,1,2)"/>
                        </xsl:call-template>
                        <xsl:text>⸢</xsl:text>
                        <xsl:variable name="temp"
                                      select="wd:get_accented_part(substring($hiragana, 3, string-length($hiragana)), $accent)"/>
                        <xsl:variable name="count"
                                      select="string-length($temp)-string-length(translate($temp,$letters,''))"/>
                        <xsl:variable name="trail"
                                      select="string-length(translate(substring($hiragana,3 + $count + $accent - 1,1),$letters,''))"/>
                        <xsl:choose>
                            <xsl:when test="$trail=0">
                                <xsl:call-template name="insert_divider">
                                    <xsl:with-param name="t"
                                                    select="substring($hiragana,3,$count + $accent)"/>
                                </xsl:call-template>
                                <xsl:text>⸣</xsl:text>
                                <xsl:call-template name="insert_divider">
                                    <xsl:with-param name="t"
                                                    select="substring($hiragana,3 + $count + $accent)"/>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:call-template name="insert_divider">
                                    <xsl:with-param name="t"
                                                    select="substring($hiragana,3,$count + $accent - 1)"/>
                                </xsl:call-template>
                                <xsl:text>⸣</xsl:text>
                                <xsl:call-template name="insert_divider">
                                    <xsl:with-param name="t"
                                                    select="substring($hiragana,3 + $count + $accent - 1)"/>
                                </xsl:call-template>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="insert_divider">
                            <xsl:with-param name="t"
                                            select="substring($hiragana,1,1)"/>
                        </xsl:call-template>
                        <xsl:text>⸢</xsl:text>
                        <!-- String nach erstem Kana ohne Nicht-Kana-Zeichen bis Akzent - 1, da bei zweitem Kana beginnend-->
                        <xsl:variable name="str1"
                                      select="substring($hiragana,2,string-length($hiragana))"/>
                        <!-- String nach erstem Kana bis Akzent -->
                        <xsl:variable name="temp" select="wd:get_accented_part($str1, $accent)"/>
                        <!-- Anzahl der nicht als Mora zählenden Zeichen -->
                        <xsl:variable name="count"
                                      select="string-length($temp)-string-length(translate($temp,$letters,''))"/>
                        <!-- Länge des Strings nach der Akzentuierung -->
                        <xsl:variable name="trail"
                                      select="string-length(substring-after($str1, $temp))"/>
                        <xsl:choose>
                            <xsl:when test="$trail=0">
                                <xsl:call-template name="insert_divider">
                                    <xsl:with-param name="t"
                                                    select="substring($hiragana, 2, $count + $accent)"/>
                                </xsl:call-template>
                                <xsl:text>⸣</xsl:text>
                                <xsl:call-template name="insert_divider">
                                    <xsl:with-param name="t"
                                                    select="substring($hiragana, 2 + $count + $accent)"/>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:call-template name="insert_divider">
                                    <xsl:with-param name="t"
                                                    select="substring($hiragana, 2, $count + $accent - 1)"/>
                                </xsl:call-template>
                                <xsl:text>⸣</xsl:text>
                                <xsl:call-template name="insert_divider">
                                    <xsl:with-param name="t"
                                                    select="substring($hiragana, 2 + $count + $accent - 1)"/>
                                </xsl:call-template>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="wd:sense/wd:accent">
        <!-- Akzent nur verarbeiten durch explizites Aufrufen von sense_accent -->
    </xsl:template>

    <xsl:template name="sense_accent">
        <xsl:if test="./wd:accent">
            <sub>
                <xsl:text>[</xsl:text>
                <xsl:for-each select="./wd:accent">
                    <xsl:value-of select="."/>
                    <xsl:if test="position() lt last()">
                        <xsl:text>, </xsl:text>
                    </xsl:if>
                </xsl:for-each>
                <xsl:text>]</xsl:text>
            </sub>
            <xsl:text> </xsl:text>
        </xsl:if>
    </xsl:template>

    <!-- subentry -->
    <xsl:template mode="subentry" match="wd:entry">
        <xsl:variable name="title">
            <xsl:call-template name="get_subentry_title"/>
        </xsl:variable>
        <xsl:call-template name="get_subentry_type"/>
        <!-- Untereintrag hat Untereinträge? dann als Link -->
        <p>
            <ruby>
                <rb>
                    <xsl:choose>
                        <xsl:when test="key('refs', @id)">
                            <a href="#{@id}">
                                <xsl:copy-of select="$title"/>
                            </a>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:copy-of select="$title"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </rb>
                <rt>
                    <xsl:call-template name="reading_from_extended_yomi"/>
                </rt>
            </ruby>
            <xsl:apply-templates mode="subheadindex" select="."/>
            <xsl:text>｜</xsl:text>
            <xsl:choose>
                <xsl:when test="./wd:sense/wd:sense">
                    <xsl:for-each select="./wd:sense">
                        <xsl:text>[</xsl:text>
                        <xsl:number format="A" value="position()"/>
                        <xsl:text>] </xsl:text>
                        <xsl:call-template name="sense_accent"/>
                        <xsl:apply-templates mode="compact" select="."/>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="count(./wd:sense[not(@related='true')])>1">
                            <xsl:for-each select="./wd:sense">
                                <xsl:text>[</xsl:text>
                                <xsl:number value="position()"/>
                                <xsl:text>] </xsl:text>
                                <xsl:call-template name="sense_accent"/>
                                <xsl:apply-templates mode="compact" select="."/>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:for-each select="./wd:sense">
                                <xsl:apply-templates mode="compact" select="."/>
                            </xsl:for-each>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </p>
    </xsl:template>

    <xsl:template name="get_subentry_title">
        <xsl:choose>
            <xsl:when test="./wd:form/wd:orth[@midashigo]">
                <xsl:apply-templates mode="simple"
                                     select="./wd:form/wd:orth[@midashigo][1]"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:if test="./wd:form/wd:orth[not(@irr)]">
                    <xsl:apply-templates mode="simple"
                                         select="./wd:form/wd:orth[not(@irr) and not(@midashigo)][1]"/>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="get_subentry_type">
        <xsl:choose>
            <xsl:when test="wd:ref[@subentrytype='head']">
                <xsl:if test="position()=1">
                    <xsl:text>►</xsl:text>
                    <br/>
                </xsl:if>
                <xsl:text>　</xsl:text>
            </xsl:when>
            <xsl:when test="wd:ref[@subentrytype='tail']">
                <xsl:if test="position()=1">
                    <xsl:text>◀</xsl:text>
                </xsl:if>
                <xsl:text>　</xsl:text>
            </xsl:when>
            <xsl:when test="wd:ref[@subentrytype='VwBsp']">
                <xsl:if test="position()=1">
                    <xsl:text>◇</xsl:text>
                </xsl:if>
                <xsl:text>　</xsl:text>
            </xsl:when>
            <xsl:when
                    test="wd:ref[@subentrytype='WIdiom' or @subentrytype='ZSprW' or @subentrytype='other' or @subentrytype='XSatz']">
                <xsl:if test="position()=1">
                    <xsl:text> </xsl:text>
                </xsl:if>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template mode="simple" match="wd:form/wd:orth">
        <xsl:choose>
            <xsl:when test="@midashigo='true'">
                <xsl:for-each select="translate(.,'(){}・･','（）｛｝··')">
                    <xsl:value-of select="."/>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="translate(.,'・･','··')"/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="not(position()=last())">
            <xsl:copy-of select="$orthdivider"/>
        </xsl:if>
    </xsl:template>

    <!-- subentry indices -->
    <xsl:template mode="subheadindex" match="wd:entry">
        <xsl:variable name="yomi" select="./wd:form/wd:reading/wd:hira"/>
        <xsl:element name="key">
            <xsl:attribute name="type">かな</xsl:attribute>
            <xsl:value-of select="$yomi"/>
        </xsl:element>
        <xsl:for-each select="./wd:form/wd:orth[not(@midashigo='true') and . != $yomi]">
            <xsl:element name="key">
                <xsl:attribute name="type">表記</xsl:attribute>
                <xsl:value-of select="."/>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>


    <xsl:template match="wd:sense" mode="compact">
        <xsl:choose>
            <xsl:when test="./wd:sense">
                <xsl:call-template name="sense_accent"/>
                <xsl:apply-templates select="./wd:descr"/>
                <xsl:choose>
                    <xsl:when test="count(./wd:sense[not(@related)])>1">
                        <xsl:for-each select="./wd:sense">
                            <xsl:apply-templates mode="compact" select="."/>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates mode="compact" select="./wd:sense"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="../wd:usg"/>
            </xsl:otherwise>
        </xsl:choose>

        <xsl:call-template name="sense_content"/>
    </xsl:template>

    <xsl:template mode="compact" match="wd:sense[empty(./wd:sense) and not(@related)]">
        <xsl:call-template name="sense_accent"/>
        <xsl:choose>
            <xsl:when test="following-sibling::wd:sense[1][@related]">
                <xsl:variable name="this_sense" select="."/>
                <xsl:call-template name="sense_content"/>
                <xsl:for-each
                        select="following-sibling::wd:sense[@related and preceding-sibling::wd:sense=$this_sense]">
                    <xsl:call-template name="sense_content"/>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="sense_content"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <xsl:template mode="compact" match="wd:sense[empty(./wd:sense) and @related]"/>

    <xsl:template name="sense_content">
        <xsl:apply-templates select="wd:usg"/>
        <xsl:apply-templates select="wd:trans"/>
        <!--<xsl:apply-templates select = ".//wd:def"  />
   <xsl:apply-templates select = ".//def"  /-->
        <xsl:if test="./@season">
            <xsl:call-template name="season"/>
        </xsl:if>
        <xsl:if test="./wd:etym">
            <xsl:text> </xsl:text>
            <xsl:apply-templates select="./wd:etym"/>
        </xsl:if>
        <xsl:if test="./wd:ref">
            <xsl:text> </xsl:text>
            <xsl:apply-templates select="./wd:ref"/>
        </xsl:if>
    </xsl:template>

    <!-- Mastersense -->
    <xsl:template match="wd:sense[not(empty(./wd:sense))]">
        <xsl:text>[</xsl:text>
        <xsl:number format="A" value="position()"/>
        <xsl:text>] </xsl:text>
        <xsl:call-template name="sense_accent"/>
        <xsl:apply-templates select="./wd:descr"/>
        <p>
            <xsl:apply-templates select="./wd:sense"/>
        </p>
    </xsl:template>

    <!--
    Senses ohne Mastersense und nicht @related
    -->
    <xsl:template match="wd:sense[empty(./wd:sense) and not(@related)]">
        <xsl:if test="following-sibling::wd:sense[not(@related)] or preceding-sibling::wd:sense[not(@related)]">
            <xsl:number count="wd:sense[not(@related)]"/>
            <xsl:text>) </xsl:text>
        </xsl:if>
        <xsl:choose>
            <xsl:when test="following-sibling::wd:sense[1][@related]">
                <xsl:variable name="this_sense" select="."/>
                <xsl:call-template name="sense_accent"/>
                <xsl:apply-templates select="./wd:descr"/>
                <xsl:apply-templates mode="core" select="."/>
                <xsl:for-each
                        select="following-sibling::wd:sense[@related and preceding-sibling::wd:sense=$this_sense]">
                    <xsl:call-template name="sense_accent"/>
                    <xsl:apply-templates select="./wd:descr"/>
                    <xsl:apply-templates mode="core" select="."/>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="sense_accent"/>
                <xsl:apply-templates select="./wd:descr"/>
                <xsl:apply-templates mode="core" select="."/>
            </xsl:otherwise>
        </xsl:choose>
        <br/>
    </xsl:template>

    <xsl:template match="wd:sense[empty(./wd:sense) and @related]"/>

    <xsl:template match="wd:sense" mode="core">
        <xsl:if test="position()>1">
            <xsl:text> </xsl:text>
        </xsl:if>
        <xsl:if test="@related">
            <xsl:value-of select="$relationDivider"/>
        </xsl:if>

        <xsl:choose>
            <xsl:when test="not(empty(wd:bracket))">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:when test="not(empty(wd:def) and empty(wd:expl))">
                <!--
                 einträge ohne bracket
                -->
                <xsl:if test="wd:trans/preceding-sibling::*[not(self::wd:trans)]">
                    <xsl:for-each select="wd:trans/preceding-sibling::*[not(self::wd:trans)]">
                        <xsl:apply-templates select="."/>
                    </xsl:for-each>
                    <xsl:text> </xsl:text>
                </xsl:if>
                <xsl:apply-templates select="wd:trans"/>
                <xsl:if test="wd:trans[last()]/following-sibling::*[not(self::wd:trans)]">
                    <xsl:text> </xsl:text>
                    <span class="klammer">
                        <xsl:text>(</xsl:text>
                        <xsl:for-each select="wd:trans[last()]/following-sibling::*[not(self::wd:trans)]">
                            <xsl:apply-templates select="."/>
                            <xsl:if test="position()&lt;last()">;</xsl:if>
                        </xsl:for-each>
                        <xsl:text>)</xsl:text>
                    </span>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="wd:usg"/>
                <xsl:apply-templates select="wd:trans"/>
                <!--<xsl:apply-templates select = ".//wd:def"  />
               <xsl:apply-templates select = ".//def"  /-->
                <xsl:if test="@season">
                    <xsl:call-template name="season"/>
                </xsl:if>
                <xsl:if test="wd:etym">
                    <xsl:text> </xsl:text>
                    <xsl:apply-templates select="wd:etym"/>
                </xsl:if>
                <xsl:if test="./wd:ref">
                    <xsl:text> </xsl:text>
                    <xsl:apply-templates select="./wd:ref"/>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:apply-templates select="./wd:link[@type='picture']"/>
    </xsl:template>

    <xsl:template name="season">
        <xsl:text> </xsl:text>
        <xsl:choose>
            <xsl:when test="./@season='spring'">
                <xsl:call-template name="season-template">
                    <xsl:with-param name="de">Frühling</xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="./@season='summer'">
                <xsl:call-template name="season-template">
                    <xsl:with-param name="de">Sommer</xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="./@season='autumn'">
                <xsl:call-template name="season-template">
                    <xsl:with-param name="de">Herbst</xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="./@season='winter'">
                <xsl:call-template name="season-template">
                    <xsl:with-param name="de">Winter</xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="./@season='newyear'">
                <xsl:call-template name="season-template">
                    <xsl:with-param name="de">Neujahr</xsl:with-param>
                </xsl:call-template>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="season-template">
        <xsl:param name="de"/>
        <span class="season {@season}">Jahreszeitenw.:
            <xsl:value-of select="$de"/>
        </span>
    </xsl:template>

    <xsl:template match="wd:trans">
        <xsl:choose>
            <xsl:when test="@langdesc='scientific'">
                <span class="latin">
                    <xsl:apply-templates/>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:choose>
            <!--<xsl:when test="position()=last()"><xsl:text>.</xsl:text></xsl:when>-->
            <xsl:when test="not(following-sibling::wd:trans)">
                <!-- wenn Satzzeichen schon im letzten Trans, dann keinen Punkt einfügen-->
                <xsl:variable name="lastchild" select="child::wd:tr/*[position()=last()]"/>
                <xsl:choose>
                    <xsl:when test="$lastchild">
                        <xsl:choose>
                            <xsl:when
                                    test="contains(substring($lastchild, string-length($lastchild), 1), '.')"/>
                            <xsl:when
                                    test="contains(substring($lastchild, string-length($lastchild), 1), '!')"/>
                            <xsl:when
                                    test="contains(substring($lastchild, string-length($lastchild), 1), '?')"/>
                            <xsl:otherwise>
                                <xsl:text>.</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>.</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>; </xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="wd:token">
        <xsl:if test="position()>1 and string-length(.)>0 and not(preceding-sibling::wd:text)">
            <xsl:text> </xsl:text>
        </xsl:if>
        <xsl:if test="preceding-sibling::wd:iron">
            <xsl:text> </xsl:text>
        </xsl:if>
        <xsl:value-of select="."/>
        <xsl:call-template name="genusTemplate"/>
        <xsl:if test="following-sibling::wd:iron">
            <xsl:text> </xsl:text>
        </xsl:if>
    </xsl:template>

    <xsl:template name="genusTemplate">
        <i>
            <xsl:text> </xsl:text>
            <xsl:if test="@article='false' or @noArticleNecessary='true'">(</xsl:if>
            <xsl:value-of select="@genus"/>
            <xsl:value-of select="@numerus"/>
            <xsl:if test="not(@genus) and not(@numerus) and @article='false'">NAr</xsl:if>
            <xsl:if test="not(@genus) and not(@numerus) and @noArticleNecessary='true'">NArN</xsl:if>
            <xsl:if test="@article='false' or @noArticleNecessary='true'">)</xsl:if>
        </i>
    </xsl:template>


    <xsl:template match="wd:descr">
        <xsl:text>(</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>) </xsl:text>
    </xsl:template>

    <xsl:template match="wd:tr">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="wd:title">
        <xsl:if test="position()>1">
            <xsl:text> </xsl:text>
        </xsl:if>
        <xsl:text>„</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>”</xsl:text>
    </xsl:template>

    <xsl:template match="wd:usg[@type='dom']">
        <xsl:if test="not(preceding-sibling::wd:usg[@type=./@type])">
            <xsl:text>{</xsl:text>
        </xsl:if>
        <xsl:apply-templates/>
        <xsl:call-template name="usg_tail">
            <xsl:with-param name="closing" select="'}'"/>
            <xsl:with-param name="test" select="following-sibling::wd:usg[@type=./@type]"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="wd:usg[@type='time']">
        <xsl:if test="not(preceding-sibling::wd:usg[@type=./@type])">
            <xsl:text>(</xsl:text>
        </xsl:if>
        <xsl:apply-templates/>
        <xsl:call-template name="usg_tail">
            <xsl:with-param name="closing" select="')'"/>
            <xsl:with-param name="test" select="following-sibling::wd:usg[@type=./@type]"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="wd:usg[@type='hint']">
        <xsl:if test="not(preceding-sibling::wd:usg[@type=./@type])">
            <xsl:text>(</xsl:text>
        </xsl:if>
        <xsl:choose>
            <xsl:when test="text()='rel.'"/>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:call-template name="usg_tail">
            <xsl:with-param name="closing" select="')'"/>
            <xsl:with-param name="test" select="following-sibling::wd:usg[@type=./@type]"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template match="wd:usg[@reg]">
        <xsl:if test="not(preceding-sibling::wd:usg[@reg])">
            <xsl:text>(</xsl:text>
        </xsl:if>
        <xsl:choose>
            <xsl:when test="@reg='lit'">
                <xsl:text>schriftspr.</xsl:text>
            </xsl:when>
            <xsl:when test="@reg='coll'">
                <xsl:text>ugs.</xsl:text>
            </xsl:when>
            <xsl:when test="@reg='vulg'">
                <xsl:text>vulg.</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:call-template name="usg_tail">
            <xsl:with-param name="closing" select="')'"/>
            <xsl:with-param name="test" select="following-sibling::wd:usg[@reg]"/>
        </xsl:call-template>
    </xsl:template>

    <!--
    depending on condition $test append comma + space or $closing + space
    if $test = true append comma + space else append $closing + space
    -->
    <xsl:template name="usg_tail">
        <xsl:param name="test"/>
        <xsl:param name="closing"/>
        <xsl:choose>
            <xsl:when test="$test">
                <xsl:text>, </xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$closing"/>
                <xsl:text> </xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="wd:ref" mode="global">
        <xsl:variable name="id" select="@id"/>
        <xsl:variable name="entry" select="/entries/wd:entry[@id=$id]"/>
        <xsl:variable name="title">
            <xsl:choose>
                <xsl:when test="$entry/wd:form/wd:orth[@midashigo]">
                    <xsl:apply-templates mode="simple" select="$entry/wd:form/wd:orth[@midashigo]"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:if test="$entry/wd:form/wd:orth[not(@irr)]">
                        <xsl:apply-templates mode="simple"
                                             select="$entry/wd:form/wd:orth[not(@irr) and not(@midashigo)]"/>
                    </xsl:if>
                    <xsl:if test="$entry/wd:form/wd:orth[@irr]">
                        <xsl:apply-templates mode="simple" select="$entry/wd:form/wd:orth[@irr]"/>
                    </xsl:if>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <a href="{@id}" class="reflink parent">
            <xsl:copy-of select="$title"/>
        </a>
    </xsl:template>

    <xsl:template match="wd:ref">
        <xsl:if test="position()>1">
            <xsl:text> </xsl:text>
        </xsl:if>
        <a href="{@id}" title="{./wd:jap}">
            <xsl:choose>
                <xsl:when test="@type='syn'">
                    <xsl:text>⇒ </xsl:text>
                </xsl:when>
                <xsl:when test="@type='anto'">
                    <xsl:text>⇔ </xsl:text>
                </xsl:when>
                <xsl:when test="@type='main'">

                </xsl:when>
                <xsl:when test="@type='altread'">
                    <xsl:text>→ </xsl:text>
                </xsl:when>
                <xsl:when test="@type='alttranscr'">
                    <xsl:text>☞ </xsl:text>
                </xsl:when>
                <xsl:when test="@type='other'">

                </xsl:when>
            </xsl:choose>
            <xsl:apply-templates select="./wd:transcr"/>
            <xsl:text> </xsl:text>
            <xsl:apply-templates select="./wd:jap"/>
        </a>
    </xsl:template>

    <xsl:template match="wd:text">
        <xsl:if test="@hasPrecedingSpace='true'">
            <xsl:text> </xsl:text>
        </xsl:if>
        <xsl:apply-templates/>
        <xsl:if test="@hasFollowingSpace='true'">
            <xsl:text> </xsl:text>
        </xsl:if>
    </xsl:template>

    <xsl:template match="wd:bracket">
        <xsl:if test="preceding-sibling::*">
            <xsl:text> </xsl:text>
        </xsl:if>
        <xsl:text>(</xsl:text>
        <xsl:for-each select="./*">
            <xsl:apply-templates select="."/>
            <xsl:if test="not(position()=last())">
                <xsl:text>; </xsl:text>
            </xsl:if>
        </xsl:for-each>
        <!--  Scientific in Klammern
            <xsl:if test="exists(//wd:trans[@langdesc='scientific'])">
            <xsl:text>; </xsl:text>
            <xsl:apply-templates select="//wd:trans[@langdesc='scientific']"/>
            </xsl:if>-->
        <xsl:text>)</xsl:text>
        <xsl:if test="position()&lt;last()">
            <xsl:text> </xsl:text>
        </xsl:if>
    </xsl:template>

    <xsl:template match="wd:famn">
        <xsl:if test="position()>1">
            <xsl:text> </xsl:text>
        </xsl:if>
        <b>
            <xsl:apply-templates/>
        </b>
    </xsl:template>

    <xsl:template match="wd:emph">
        <u>
            <xsl:apply-templates/>
        </u>
    </xsl:template>

    <xsl:template match="wd:transcr">
        <em>
            <xsl:apply-templates/>
        </em>
    </xsl:template>

    <xsl:template match="wd:foreign">
        <xsl:if test="position()>1 and not(starts-with(text(), ','))">
            <xsl:text> </xsl:text>
        </xsl:if>
        <i>
            <xsl:apply-templates/>
        </i>
    </xsl:template>

    <xsl:template match="wd:link[@type='picture']">
        <img alt="{text()}" src="Images/{@url}.jpg"/>
        <div class="caption">
            <xsl:value-of select="text()"/>
        </div>
    </xsl:template>

    <xsl:template match="wd:link[@type='url']">
        <div class="url">
            <xsl:choose>
                <!-- current standard case
                <link type="url" url="http://www.foo.bar/"/>
                 -->
                <xsl:when test="@url">
                    <a href="{@url}">
                        <xsl:value-of select='@url'/>
                    </a>
                </xsl:when>
                <!-- legacy support
                 <link type="url">http://www.hoge.piyo/</link><
                -->
                <xsl:when test="string-length(.) > 0">
                    <a href="{.}">
                        <xsl:value-of select='.'/>
                    </a>
                </xsl:when>
                <xsl:otherwise>
                    <!-- safe guard -->
                </xsl:otherwise>
            </xsl:choose>
        </div>
    </xsl:template>


    <xsl:template match="wd:impli">
        <xsl:apply-templates/>
        <xsl:if test="position() != last()">
            <xsl:text>; </xsl:text>
        </xsl:if>
    </xsl:template>

    <!--
    typography
    -->

    <xsl:template match="wd:jap">
        <!-- always use HALFWIDTH KATAKANA MIDDLE DOT -->
        <xsl:value-of select="translate(., '・', '･')"/>
    </xsl:template>

    <xsl:template match="wd:transcr/wd:*">
        <!-- always use MIDDLE DOT -->
        <xsl:value-of select="translate(., '・･', '·')"/>
    </xsl:template>


    <xsl:template match="wd:*">
        <xsl:apply-templates/>
    </xsl:template>
</xsl:stylesheet>
