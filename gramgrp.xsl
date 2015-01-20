<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:wd="http://www.wadoku.de/xml/entry"
    xmlns:ebs="http://ebstudio.info"
    exclude-result-prefixes="xs wd ebs"
    version="2.0">

    <xsl:template match="wd:gramGrp">
        <xsl:for-each select="*">
            <xsl:apply-templates select="."/>
            <xsl:if test="position() != last()">
                <xsl:text>; </xsl:text>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="wd:meishi">
        <xsl:text>N.</xsl:text>
        <xsl:call-template name="meishi_fukushi_suru"/>
    </xsl:template>

    <xsl:template name="meishi_fukushi_suru">
        <xsl:if test="@suru">
            <xsl:text>, mit </xsl:text>
            <em>suru</em>
            <xsl:choose>
                <xsl:when test="@suru='trans'">
                    <xsl:text> trans. V.</xsl:text>
                </xsl:when>
                <xsl:when test="@suru='intrans'">
                    <xsl:text> intrans. V.</xsl:text>
                </xsl:when>
                <xsl:when test="@suru='both'">
                    <xsl:text> intrans. od. trans. V.</xsl:text>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
    </xsl:template>

    <xsl:template match="wd:doushi[@level='kuru']">
        <xsl:text>unregelm. intrans. V. auf </xsl:text>
        <em>ka</em>
    </xsl:template>

    <xsl:template match="wd:doushi[@level='suru']">
        <xsl:choose>
            <xsl:when test="@transitivity='trans'">trans. V.</xsl:when>
            <xsl:when test="@transitivity='intrans'">intrans. V.</xsl:when>
            <xsl:when test="@transitivity='both'">intrans. od. trans. V.</xsl:when>
        </xsl:choose>
        <xsl:text> auf </xsl:text>
        <em>‑suru</em>
    </xsl:template>

    <xsl:template match="wd:doushi[@level='ra']">
        <xsl:choose>
            <xsl:when test="@transitivity='trans'">trans. V.</xsl:when>
            <xsl:when test="@transitivity='intrans'">intrans. V.</xsl:when>
            <xsl:when test="@transitivity='both'">intrans. od. trans. V.</xsl:when>
        </xsl:choose>
        <xsl:text> auf &lt;Transcr.: ‑ra&gt;</xsl:text>
    </xsl:template>

    <xsl:template match="wd:doushi">
        <!-- <doushi level="5" transitivity="intrans" godanrow="ra" onbin="true"/> -->
        <xsl:choose>
            <xsl:when test="@level='1e' or @level='1i'">1</xsl:when>
            <xsl:when test="@level='2e' or @level='2i'">2</xsl:when>
            <xsl:when test="@level='4'">4</xsl:when>
            <xsl:when test="@level='4'">4</xsl:when>
            <xsl:when test="@level='5'">5</xsl:when>
        </xsl:choose>
        <xsl:text>‑st. </xsl:text>
        <xsl:choose>
            <xsl:when test="@transitivity='trans'">trans. V.</xsl:when>
            <xsl:when test="@transitivity='intrans'">intrans. V.</xsl:when>
            <xsl:when test="@transitivity='both'">intrans. od. trans. V.</xsl:when>
        </xsl:choose>
        <xsl:choose>
            <xsl:when test="@level='1i'">
                <xsl:text> auf </xsl:text>
                <em>‑i</em>
            </xsl:when>
            <xsl:when test="@level='1e'">
                <xsl:text> auf </xsl:text>
                <em>‑e</em>
            </xsl:when>
            <xsl:when test="@level='2i'">
                <xsl:text> auf </xsl:text>
                <em>‑i</em>
                <xsl:text> bzw. </xsl:text>
                <em>‑u</em>
            </xsl:when>
            <xsl:when test="@level='2e'">
                <xsl:text> auf </xsl:text>
                <em>‑e</em>
                <xsl:text> bzw. </xsl:text>
                <em>‑u</em>
            </xsl:when>
            <xsl:when test="@level='5' and @godanrow">
                <xsl:text> auf </xsl:text>
                <em>‑<xsl:choose>
                    <xsl:when test="@godanrow='ra_i'">ra</xsl:when>
                    <xsl:when test="@godanrow='ka_i_yu'">ka</xsl:when>
                    <xsl:when test="@godanrow='wa' or @godanrow='wa_o'">[w]a</xsl:when>
                    <xsl:otherwise><xsl:value-of select="@godanrow"/></xsl:otherwise>
                </xsl:choose></em>
                <xsl:choose>
                    <xsl:when test="@onbin='true'">
                        <xsl:choose>
                            <xsl:when test="@godanrow='na' or @godanrow='ba' or @godanrow='ma'">
                                <span class="expl"> mit regelm. Nasal-Onbin = <em>‑nde></em></span>
                            </xsl:when>
                            <xsl:when test="@godanrow='ka'">
                                <span class="expl"> mit i-Onbin = <em>‑ite></em></span>
                            </xsl:when>
                            <xsl:when test="@godanrow='ka_i_yu'">
                                <span class="expl"> mit Geminaten-Onbin = <em>‑tte></em></span>
                            </xsl:when>
                            <xsl:when test="@godanrow='ga'">
                                <span class="expl"> mit regelm. i-Onbin = <em>‑ide></em></span>
                            </xsl:when>
                            <xsl:when test="@godanrow='wa'">
                                <span class="expl"> mit Geminaten-Onbin = <em>‑tte></em></span>
                            </xsl:when>
                            <xsl:when test="@godanrow='wa_o'">
                                <span class="expl"> mit u-Onbin = <em>‑ō/ūte></em></span>
                            </xsl:when>
                            <xsl:when test="@godanrow='ra' or @godanrow='ta'">
                                <span class="expl"> mit regelm. Geminaten-Onbin = <em>‑tte></em></span>
                            </xsl:when>
                            <xsl:when test="@godanrow='ra_i'">
                                <xsl:text>, Sonderform mit Renyō·kei </xsl:text>
                                <em>‑i</em>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
        </xsl:choose>
        <xsl:if test="following-sibling::wd:doushi">
            <xsl:text>; </xsl:text>
        </xsl:if>
    </xsl:template>

    <xsl:template match="wd:keiyoudoushi">
        <!-- Na.‑Adj. mit <Transcr.: na> bzw. präd. mit <Transcr.: da> etc. -->
        <!-- Na.‑Adj. mit <Transcr.: na> od. <Transcr.: no> -->
        <xsl:text>Na.‑Adj. mit </xsl:text>
        <xsl:choose>
            <xsl:when test="@nari and @nari='true'">
                <em>nari</em>
            </xsl:when>
            <xsl:otherwise>
                <em>na</em>
                <xsl:if test="@no and @no='true'">
                    <xsl:text> od. </xsl:text>
                    <em>no</em>
                </xsl:if>
                <xsl:text> bzw. präd. mit </xsl:text>
                <em>da</em>
                <xsl:text> etc.</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="wd:keiyoushi">
        <xsl:text>Adj.</xsl:text>
        <xsl:if test="@ku and @ku='true'">
            <xsl:text> auf </xsl:text>
            <em>‑ku</em>
        </xsl:if>
    </xsl:template>

    <xsl:template match="wd:specialcharacter">
        <xsl:text>Sonderzeichen</xsl:text>
    </xsl:template>

    <xsl:template match="wd:suffix">
        <xsl:text>Suff.</xsl:text>
    </xsl:template>

    <xsl:template match="wd:prefix">
        <xsl:text>Präf.</xsl:text>
    </xsl:template>

    <xsl:template match="wd:jodoushi">
        <xsl:text>Hilfsv.</xsl:text>
    </xsl:template>

    <xsl:template match="wd:kandoushi">
        <xsl:text>Interj.</xsl:text>
    </xsl:template>

    <xsl:template match="wd:kanji">
        <xsl:text>Kanji</xsl:text>
    </xsl:template>

    <xsl:template match="wd:setsuzokushi">
        <xsl:text>Konj.</xsl:text>
    </xsl:template>

    <xsl:template match="wd:kakarijoshi">
        <xsl:text>Themenpart.</xsl:text>
    </xsl:template>

    <xsl:template match="wd:wordcomponent">
        <xsl:text>Wortkomp.</xsl:text>
    </xsl:template>

    <xsl:template match="wd:joshi">
        <xsl:text>Part.</xsl:text>
    </xsl:template>

    <xsl:template match="wd:daimeishi">
        <xsl:text>Pron.</xsl:text>
    </xsl:template>

    <xsl:template match="wd:shuujoshi">
        <xsl:text>satzbeendende Part.</xsl:text>
    </xsl:template>

    <xsl:template match="wd:fukujoshi">
        <xsl:text>adv. Part.</xsl:text>
    </xsl:template>

    <xsl:template match="wd:rengo">
        <xsl:text>Zus.</xsl:text>
    </xsl:template>

    <xsl:template match="wd:rentaishi">
        <xsl:text>Adn.</xsl:text>
    </xsl:template>

    <xsl:template match="wd:fukushi">
        <xsl:text>Adv.</xsl:text>
        <xsl:choose>
            <xsl:when test="@ni and @ni='true'">
                <xsl:text> mit </xsl:text>
                <em>ni</em>
                <xsl:text> und Adn. mit </xsl:text>
                <em>naru</em>
            </xsl:when>
            <xsl:when test="@taru and @taru='true'">
                <xsl:text> mit </xsl:text>
                <em>to</em>
                <xsl:text> und Adn. mit </xsl:text>
                <em>taru</em>
            </xsl:when>
            <xsl:when test="@to and @to='true'">
                <xsl:text> mit </xsl:text>
                <em>to</em>
            </xsl:when>
        </xsl:choose>
        <xsl:call-template name="meishi_fukushi_suru"/>
    </xsl:template>

</xsl:stylesheet>
