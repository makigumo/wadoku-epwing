#!/usr/bin/ruby -W0

require 'set'

default = <<-EOS
<?xml version="1.0" encoding="Shift_JIS"?>
<gaijiSet>

  <!-- zenkaku -->
  <gaijiMap name="39630"	unicode="9127" ebcode="B021"/>
  <gaijiMap name="aelig"	unicode="#x00E6" ebcode="B024" alt="ae" />
  <gaijiMap unicode="#xE001" ebcode="B025"/>
  <gaijiMap unicode="#x01FD" ebcode="B026"/>
  
  <!-- hankaku -->
  
  <gaijiMap name="nbsp"	unicode="#x00A0" ebcode="A121" />
  <gaijiMap name="iexcl"	unicode="#x00A1" ebcode="A122" alt="i" />
  <gaijiMap name="cent"	unicode="#x00A2" ebcode="A123"/>
  <gaijiMap name="pound"	unicode="#x00A3" ebcode="A124"/>
  <gaijiMap name="curren"	unicode="#x00A4" ebcode="A125"/>
  <gaijiMap name="yen"	unicode="#x00A5" ebcode="A126"/>
  <gaijiMap name="brvbar"	unicode="#x00A6" ebcode="A127"/>
  <gaijiMap name="sect"	unicode="#x00A7" ebcode="A128"/>
  <gaijiMap name="uml"	unicode="#x00A8" ebcode="A129"/>
  <gaijiMap name="copy"	unicode="#x00A9" ebcode="A12A"/>
  <gaijiMap name="ordf"	unicode="#x00AA" ebcode="A12B"/>
  <gaijiMap name="laquo"	unicode="#x00AB" ebcode="A12C"/>
  <gaijiMap name="not"	unicode="#x00AC" ebcode="A12D"/>
  <gaijiMap name="shy"	unicode="#x00AD" ebcode="A12E"/>
  <gaijiMap name="reg"	unicode="#x00AE" ebcode="A12F"/>
  <gaijiMap name="macr"	unicode="#x00AF" ebcode="A130"/>
  
  <gaijiMap name="deg"	unicode="#x00B0" ebcode="A131"/>
  <gaijiMap name="plusmn"	unicode="#x00B1" ebcode="A132"/>
  <gaijiMap name="sup2"	unicode="#x00B2" ebcode="A133" alt="2" />
  <gaijiMap name="sup3"	unicode="#x00B3" ebcode="A134" alt="3" />
  <gaijiMap name="acute"	unicode="#x00B4" ebcode="A135"/>
  <gaijiMap name="micro"	unicode="#x00B5" ebcode="A136"/>
  <gaijiMap name="para"	unicode="#x00B6" ebcode="A137"/>
  <gaijiMap name="middot"	unicode="#x00B7" ebcode="A138"/>
  <gaijiMap name="cedil"	unicode="#x00B8" ebcode="A139"/>
  <gaijiMap name="sup1"	unicode="#x00B9" ebcode="A13A" alt="1" />
  <gaijiMap name="ordm"	unicode="#x00BA" ebcode="A13B"/>
  <gaijiMap name="raquo"	unicode="#x00BB" ebcode="A13C"/>
  <gaijiMap name="frac14"	unicode="#x00BC" ebcode="A13D"/>
  <gaijiMap name="frac12"	unicode="#x00BD" ebcode="A13E"/>
  <gaijiMap name="frac34"	unicode="#x00BE" ebcode="A13F"/>
  <gaijiMap name="iquest"	unicode="#x00BF" ebcode="A140"/>
  
  <gaijiMap name="Agrave"	unicode="#x00C0" ebcode="A141" alt="A" />
  <gaijiMap name="Aacute"	unicode="#x00C1" ebcode="A142" alt="A" />
  <gaijiMap name="Acirc"	unicode="#x00C2" ebcode="A143" alt="A" />
  <gaijiMap name="Atilde"	unicode="#x00C3" ebcode="A144" alt="A" />
  <gaijiMap name="Auml"	unicode="#x00C4" ebcode="A145" alt="A" />
  <gaijiMap name="Aring"	unicode="#x00C5" ebcode="A146" alt="A" />
  <gaijiMap name="AElig"	unicode="#x00C6" ebcode="A147" alt="AE" />
  <gaijiMap name="Ccedil"	unicode="#x00C7" ebcode="A148" alt="C" />
  <gaijiMap name="Egrave"	unicode="#x00C8" ebcode="A149" alt="E" />
  <gaijiMap name="Eacute"	unicode="#x00C9" ebcode="A14A" alt="E" />
  <gaijiMap name="Ecirc"	unicode="#x00CA" ebcode="A14B" alt="E" />
  <gaijiMap name="Euml"	unicode="#x00CB" ebcode="A14C" alt="E" />
  <gaijiMap name="Igrave"	unicode="#x00CC" ebcode="A14D" alt="I" />
  <gaijiMap name="Iacute"	unicode="#x00CD" ebcode="A14E" alt="I" />
  <gaijiMap name="Icirc"	unicode="#x00CE" ebcode="A14F" alt="I" />
  <gaijiMap name="Iuml"	unicode="#x00CF" ebcode="A150" alt="I" />
  
  <gaijiMap name="ETH"	unicode="#x00D0" ebcode="A151"/>
  <gaijiMap name="Ntilde"	unicode="#x00D1" ebcode="A152" alt="N" />
  <gaijiMap name="Ograve"	unicode="#x00D2" ebcode="A153" alt="O" />
  <gaijiMap name="Oacute"	unicode="#x00D3" ebcode="A154" alt="O" />
  <gaijiMap name="Ocirc"	unicode="#x00D4" ebcode="A155" alt="O" />
  <gaijiMap name="Otilde"	unicode="#x00D5" ebcode="A156" alt="O" />
  <gaijiMap name="Ouml"	unicode="#x00D6" ebcode="A157" alt="O" />
  <gaijiMap name="times"	unicode="#x00D7" ebcode="A158"/>
  <gaijiMap name="Oslash"	unicode="#x00D8" ebcode="A159" alt="O" />
  <gaijiMap name="Ugrave"	unicode="#x00D9" ebcode="A15A" alt="U" />
  <gaijiMap name="Uacute"	unicode="#x00DA" ebcode="A15B" alt="U" />
  <gaijiMap name="Ucirc"	unicode="#x00DB" ebcode="A15C" alt="U" />
  <gaijiMap name="Uuml"	unicode="#x00DC" ebcode="A15D" alt="U" />
  <gaijiMap name="Yacute"	unicode="#x00DD" ebcode="A15E" alt="Y" />
  <gaijiMap name="THORN"	unicode="#x00DE" ebcode="A15F"/>
  <gaijiMap name="szlig"	unicode="#x00DF" ebcode="A160"/>
  
  <gaijiMap name="agrave"	unicode="#x00E0" ebcode="A161" alt="a" />
  <gaijiMap name="aacute"	unicode="#x00E1" ebcode="A162" alt="a" />
  <gaijiMap name="acirc"	unicode="#x00E2" ebcode="A163" alt="a" />
  <gaijiMap name="atilde"	unicode="#x00E3" ebcode="A164" alt="a" />
  <gaijiMap name="auml"	unicode="#x00E4" ebcode="A165" alt="a" />
  <gaijiMap name="aring"	unicode="#x00E5" ebcode="A166" alt="a" />
  <gaijiMap name="aelig"	unicode="#x00E6" ebcode="A167" alt="ae"/>
  <gaijiMap name="ccedil"	unicode="#x00E7" ebcode="A168" alt="c" />
  <gaijiMap name="egrave"	unicode="#x00E8" ebcode="A169" alt="e" />
  <gaijiMap name="eacute"	unicode="#x00E9" ebcode="A16A" alt="e" />
  <gaijiMap name="ecirc"	unicode="#x00EA" ebcode="A16B" alt="e" />
  <gaijiMap name="euml"	unicode="#x00EB" ebcode="A16C" alt="e" />
  <gaijiMap name="igrave"	unicode="#x00EC" ebcode="A16D" alt="i" />
  <gaijiMap name="iacute"	unicode="#x00ED" ebcode="A16E" alt="i" />
  <gaijiMap name="icirc"	unicode="#x00EE" ebcode="A16F" alt="i" />
  <gaijiMap name="iuml"	unicode="#x00EF" ebcode="A170" alt="i" />
  
  <gaijiMap name="eth"	unicode="#x00F0" ebcode="A171"/>
  <gaijiMap name="ntilde"	unicode="#x00F1" ebcode="A172" alt="n" />
  <gaijiMap name="ograve"	unicode="#x00F2" ebcode="A173" alt="o" />
  <gaijiMap name="oacute"	unicode="#x00F3" ebcode="A174" alt="o" />
  <gaijiMap name="ocirc"	unicode="#x00F4" ebcode="A175" alt="o" />
  <gaijiMap name="otilde"	unicode="#x00F5" ebcode="A176" alt="o" />
  <gaijiMap name="ouml"	unicode="#x00F6" ebcode="A177" alt="o" />
  <gaijiMap name="divide"	unicode="#x00F7" ebcode="A178"/>
  <gaijiMap name="oslash"	unicode="#x00F8" ebcode="A179"/>
  <gaijiMap name="ugrave"	unicode="#x00F9" ebcode="A17A" alt="u" />
  <gaijiMap name="uacute"	unicode="#x00FA" ebcode="A17B" alt="u" />
  <gaijiMap name="ucirc"	unicode="#x00FB" ebcode="A17C" alt="u" />
  <gaijiMap name="uuml"	unicode="#x00FC" ebcode="A17D" alt="u" />
  <gaijiMap name="yacute"	unicode="#x00FD" ebcode="A17E" alt="y" />
  <gaijiMap name="thorn"	unicode="#x00FE" ebcode="A221"/>
  <gaijiMap name="yuml"	unicode="#x00FF" ebcode="A222" alt="y" />
  
  <gaijiMap name="Amacr"	unicode="#x0100" ebcode="A223" alt="A" />
  <gaijiMap name="amacr"	unicode="#x0101" ebcode="A224" alt="a" />
  <gaijiMap name="Abreve"	unicode="#x0102" ebcode="A225" alt="A" />
  <gaijiMap name="abreve"	unicode="#x0103" ebcode="A226" alt="a" />
  <gaijiMap name="Aogon"	unicode="#x0104" ebcode="A227" alt="A" />
  <gaijiMap name="aogon"	unicode="#x0105" ebcode="A228" alt="a" />
  <gaijiMap name="Cacute"	unicode="#x0106" ebcode="A229" alt="C" />
  <gaijiMap name="cacute"	unicode="#x0107" ebcode="A22A" alt="c" />
  <gaijiMap name="Ccirc"	unicode="#x0108" ebcode="A22B" alt="C" />
  <gaijiMap name="ccirc"	unicode="#x0109" ebcode="A22C" alt="c" />
  <gaijiMap name="Cdot"	unicode="#x010A" ebcode="A22D" alt="C" />
  <gaijiMap name="cdot"	unicode="#x010B" ebcode="A22E" alt="c" />
  <gaijiMap name="Ccaron"	unicode="#x010C" ebcode="A22F" alt="C" />
  <gaijiMap name="ccaron"	unicode="#x010D" ebcode="A230" alt="c" />
  <gaijiMap name="Dcaron"	unicode="#x010E" ebcode="A231" alt="D" />
  <gaijiMap name="dcaron"	unicode="#x010F" ebcode="A232" alt="d" />
  
  <gaijiMap name="Dstrok"	unicode="#x0110" ebcode="A233" alt="D" />
  <gaijiMap name="dstrok"	unicode="#x0111" ebcode="A234" alt="d" />
  <gaijiMap name="Emacr"	unicode="#x0112" ebcode="A235" alt="E" />
  <gaijiMap name="emacr"	unicode="#x0113" ebcode="A236" alt="e" />
  <gaijiMap name="Ebreve"	unicode="#x0114" ebcode="A237" alt="E" />
  <gaijiMap name="ebreve"	unicode="#x0115" ebcode="A238" alt="e" />
  <gaijiMap name="Edot"	unicode="#x0116" ebcode="A239" alt="E" />
  <gaijiMap name="edot"	unicode="#x0117" ebcode="A23A" alt="e" />
  <gaijiMap name="Eogon"	unicode="#x0118" ebcode="A23B" alt="E" />
  <gaijiMap name="eogon"	unicode="#x0119" ebcode="A23C" alt="e" />
  <gaijiMap name="Ecaron"	unicode="#x011A" ebcode="A23D" alt="E" />
  <gaijiMap name="ecaron"	unicode="#x011B" ebcode="A23E" alt="e" />
  <gaijiMap name="Gcirc"	unicode="#x011C" ebcode="A23F" alt="G" />
  <gaijiMap name="gcirc"	unicode="#x011D" ebcode="A240" alt="g" />
  <gaijiMap name="Gbreve"	unicode="#x011E" ebcode="A241" alt="G" />
  <gaijiMap name="gbreve"	unicode="#x011F" ebcode="A242" alt="g" />
  
  <gaijiMap name="Gdot"	unicode="#x0120" ebcode="A243" alt="G" />
  <gaijiMap name="gdot"	unicode="#x0121" ebcode="A244" alt="g" />
  <gaijiMap name="Gcedil"	unicode="#x0122" ebcode="A245" alt="G" />
  <gaijiMap name="gcedil"	unicode="#x0123" ebcode="A246" alt="g" />
  <gaijiMap name="Hcirc"	unicode="#x0124" ebcode="A247" alt="H" />
  <gaijiMap name="hcirc"	unicode="#x0125" ebcode="A248" alt="h" />
  <gaijiMap name="Hstrok"	unicode="#x0126" ebcode="A249" alt="H" />
  <gaijiMap name="hstrok"	unicode="#x0127" ebcode="A24A" alt="h" />
  <gaijiMap name="Itilde"	unicode="#x0128" ebcode="A24B" alt="I" />
  <gaijiMap name="itilde"	unicode="#x0129" ebcode="A24C" alt="i" />
  <gaijiMap name="Imacr"	unicode="#x012A" ebcode="A24D" alt="I" />
  <gaijiMap name="imacr"	unicode="#x012B" ebcode="A24E" alt="i" />
  <gaijiMap name="Ibreve"	unicode="#x012C" ebcode="A24F" alt="I" />
  <gaijiMap name="ibreve"	unicode="#x012D" ebcode="A250" alt="i" />
  <gaijiMap name="Iogon"	unicode="#x012E" ebcode="A251" alt="I" />
  <gaijiMap name="iogon"	unicode="#x012F" ebcode="A252" alt="i" />
  
  <gaijiMap name="Idot"	unicode="#x0130" ebcode="A253" alt="I" />
  <gaijiMap name="inodot"	unicode="#x0131" ebcode="A254" alt="i" />
  <gaijiMap name="IJlig"	unicode="#x0132" ebcode="A255" alt="I" />
  <gaijiMap name="ijlig"	unicode="#x0133" ebcode="A256" alt="i" />
  <gaijiMap name="Jcirc"	unicode="#x0134" ebcode="A257" alt="J" />
  <gaijiMap name="jcirc"	unicode="#x0135" ebcode="A258" alt="j" />
  <gaijiMap name="Kcedil"	unicode="#x0136" ebcode="A259" alt="K" />
  <gaijiMap name="kcedil"	unicode="#x0137" ebcode="A25A" alt="k" />
  <gaijiMap name="kgreen"	unicode="#x0138" ebcode="A25B" alt="k" />
  <gaijiMap name="Lacute"	unicode="#x0139" ebcode="A25C" alt="L" />
  <gaijiMap name="lacute"	unicode="#x013A" ebcode="A25D" alt="l" />
  <gaijiMap name="Lcedil"	unicode="#x013B" ebcode="A25E" alt="L" />
  <gaijiMap name="lcedil"	unicode="#x013C" ebcode="A25F" alt="l" />
  <gaijiMap name="Lcaron"	unicode="#x013D" ebcode="A260" alt="L" />
  <gaijiMap name="lcaron"	unicode="#x013E" ebcode="A261" alt="l" />
  <gaijiMap name="Lmidot"	unicode="#x013F" ebcode="A262" alt="L" />
  
  <gaijiMap name="lmidot"	unicode="#x0140" ebcode="A263" alt="l" />
  <gaijiMap name="Lstrok"	unicode="#x0141" ebcode="A264" alt="L" />
  <gaijiMap name="lstrok"	unicode="#x0142" ebcode="A265" alt="l" />
  <gaijiMap name="Nacute"	unicode="#x0143" ebcode="A266" alt="N" />
  <gaijiMap name="nacute"	unicode="#x0144" ebcode="A267" alt="n" />
  <gaijiMap name="Ncedil"	unicode="#x0145" ebcode="A268" alt="N" />
  <gaijiMap name="ncedil"	unicode="#x0146" ebcode="A269" alt="n" />
  <gaijiMap name="Ncaron"	unicode="#x0147" ebcode="A26A" alt="N" />
  <gaijiMap name="ncaron"	unicode="#x0148" ebcode="A26B" alt="n" />
  <gaijiMap name="napos"	unicode="#x0149" ebcode="A26C" alt="n" />
  <gaijiMap name="ENG"	unicode="#x014A" ebcode="A26D" alt="" />
  <gaijiMap name="eng"	unicode="#x014B" ebcode="A26E" alt="" />
  <gaijiMap name="Omacr"	unicode="#x014C" ebcode="A26F" alt="O" />
  <gaijiMap name="omacr"	unicode="#x014D" ebcode="A270" alt="o" />
  <gaijiMap name="Obreve"	unicode="#x014E" ebcode="A271" alt="O" />
  <gaijiMap name="obreve"	unicode="#x014F" ebcode="A272" alt="o" />
  
  <gaijiMap name="Odblac"	unicode="#x0150" ebcode="A273" alt="O" />
  <gaijiMap name="odblac"	unicode="#x0151" ebcode="A274" alt="o" />
  <gaijiMap name="OElig"	unicode="#x0152" ebcode="A275" alt="OE" />
  <gaijiMap name="oelig"	unicode="#x0153" ebcode="A276" alt="oe" />
  <gaijiMap name="Racute"	unicode="#x0154" ebcode="A277" alt="R" />
  <gaijiMap name="racute"	unicode="#x0155" ebcode="A278" alt="r" />
  <gaijiMap name="Rcedil"	unicode="#x0156" ebcode="A279" alt="R" />
  <gaijiMap name="rcedil"	unicode="#x0157" ebcode="A27A" alt="r" />
  <gaijiMap name="Rcaron"	unicode="#x0158" ebcode="A27B" alt="R" />
  <gaijiMap name="rcaron"	unicode="#x0159" ebcode="A27C" alt="r" />
  <gaijiMap name="Sacute"	unicode="#x015A" ebcode="A27D" alt="S" />
  <gaijiMap name="sacute"	unicode="#x015B" ebcode="A27E" alt="s" />
  <gaijiMap name="Scirc"	unicode="#x015C" ebcode="A321" alt="S" />
  <gaijiMap name="scirc"	unicode="#x015D" ebcode="A322" alt="s" />
  <gaijiMap name="Scedil"	unicode="#x015E" ebcode="A323" alt="S" />
  <gaijiMap name="scedil"	unicode="#x015F" ebcode="A324" alt="s" />
  
  <gaijiMap name="Scaron"	unicode="#x0160" ebcode="A325" alt="S" />
  <gaijiMap name="scaron"	unicode="#x0161" ebcode="A326" alt="s" />
  <gaijiMap name="Tcedil"	unicode="#x0162" ebcode="A327" alt="T" />
  <gaijiMap name="tcedil"	unicode="#x0163" ebcode="A328" alt="t" />
  <gaijiMap name="Tcaron"	unicode="#x0164" ebcode="A329" alt="T" />
  <gaijiMap name="tcaron"	unicode="#x0165" ebcode="A32A" alt="t" />
  <gaijiMap name="Tstrok"	unicode="#x0166" ebcode="A32B" alt="T" />
  <gaijiMap name="tstrok"	unicode="#x0167" ebcode="A32C" alt="t" />
  <gaijiMap name="Utilde"	unicode="#x0168" ebcode="A32D" alt="U" />
  <gaijiMap name="utilde"	unicode="#x0169" ebcode="A32E" alt="u" />
  <gaijiMap name="Umacr"	unicode="#x016A" ebcode="A32F" alt="U" />
  <gaijiMap name="umacr"	unicode="#x016B" ebcode="A330" alt="u" />
  <gaijiMap name="Ubreve"	unicode="#x016C" ebcode="A331" alt="U" />
  <gaijiMap name="ubreve"	unicode="#x016D" ebcode="A332" alt="u" />
  <gaijiMap name="Uring"	unicode="#x016E" ebcode="A333" alt="U" />
  <gaijiMap name="uring"	unicode="#x016F" ebcode="A334" alt="u" />
  
  <gaijiMap name="Udblac"	unicode="#x0170" ebcode="A335" alt="U" />
  <gaijiMap name="udblac"	unicode="#x0171" ebcode="A336" alt="u" />
  <gaijiMap name="Uogon"	unicode="#x0172" ebcode="A337" alt="U" />
  <gaijiMap name="uogon"	unicode="#x0173" ebcode="A338" alt="u" />
  <gaijiMap name="Wcirc"	unicode="#x0174" ebcode="A339" alt="W" />
  <gaijiMap name="wcirc"	unicode="#x0175" ebcode="A33A" alt="w" />
  <gaijiMap name="Ycirc"	unicode="#x0176" ebcode="A33B" alt="Y" />
  <gaijiMap name="ycirc"	unicode="#x0177" ebcode="A33C" alt="y" />
  <gaijiMap name="Yuml"	unicode="#x0178" ebcode="A33D" alt="Y" />
  <gaijiMap name="Zacute"	unicode="#x0179" ebcode="A33E" alt="Z" />
  <gaijiMap name="zacute"	unicode="#x017A" ebcode="A33F" alt="z" />
  <gaijiMap name="Zdot"	unicode="#x017B" ebcode="A340" alt="Z" />
  <gaijiMap name="zdot"	unicode="#x017C" ebcode="A341" alt="z" />
  <gaijiMap name="Zcaron"	unicode="#x017D" ebcode="A342" alt="Z" />
  <gaijiMap name="zcaron"	unicode="#x017E" ebcode="A343" alt="z" />
  <gaijiMap name=""	unicode="#x017F" ebcode="A344" alt="" />
  
  <gaijiMap name="Acaron"	unicode="#x01CD" ebcode="A345" alt="A" />
  <gaijiMap name="acaron"	unicode="#x01CE" ebcode="A346" alt="a" />
  <gaijiMap name="Icaron"	unicode="#x01CF" ebcode="A347" alt="I" />
  <gaijiMap name="icaron"	unicode="#x01D0" ebcode="A348" alt="i" />
  <gaijiMap name="Ocaron"	unicode="#x01D1" ebcode="A349" alt="O" />
  <gaijiMap name="ocaron"	unicode="#x01D2" ebcode="A34A" alt="o" />
  <gaijiMap name="Ucaron"	unicode="#x01D3" ebcode="A34B" alt="U" />
  <gaijiMap name="ucaron"	unicode="#x01D4" ebcode="A34C" alt="u" />
  
  
  <gaijiMap name="fnof"	unicode="#x0192" ebcode="A34D"/>
  <gaijiMap name="circ"	unicode="#x02C6" ebcode="A34E" alt="^" />
  <gaijiMap name="tilde"	unicode="#x02DC" ebcode="A34F" alt="~" />
  
  <gaijiMap unicode="#x0254" ebcode="A350"/>
  <gaijiMap unicode="#xE002" ebcode="A351"/>
  <gaijiMap unicode="#xE003" ebcode="A352"/>
  <gaijiMap unicode="#x0259" ebcode="A353"/>
  <gaijiMap unicode="#xE004" ebcode="A354"/>
  <gaijiMap unicode="#xE005" ebcode="A355"/>
  <gaijiMap unicode="#x028C" ebcode="A356"/>
  <gaijiMap unicode="#xE006" ebcode="A357"/>
  <gaijiMap unicode="#xE007" ebcode="A358"/>
  <gaijiMap unicode="#x02D0" ebcode="A359"/>
  <gaijiMap unicode="#x0251" ebcode="A35A"/>
  <gaijiMap unicode="#xE008" ebcode="A35B"/>
  <gaijiMap unicode="#xE009" ebcode="A35C"/>
  <gaijiMap unicode="#x0283" ebcode="A35D"/>
  <gaijiMap unicode="#x028A" ebcode="A35E"/>
  <gaijiMap unicode="#x03B8" ebcode="A35F"/>
  <gaijiMap unicode="#x0292" ebcode="A360"/>
  <gaijiMap unicode="#x0252" ebcode="A361"/>
  <gaijiMap unicode="#x025B" ebcode="A362"/>
  <gaijiMap unicode="#x025C" ebcode="A363"/>
  <gaijiMap unicode="#x028E" ebcode="A364"/>
  <gaijiMap unicode="#x2011" ebcode="A365" alt="-"/>
  <gaijiMap unicode="#x2013" ebcode="A366" alt="-"/>
  <gaijiMap unicode="#x2e23" ebcode="A367" alt="`"/>
  <gaijiMap unicode="#x2e22" ebcode="A368" alt="´"/>
  
  <gaijiMap unicode="#x27a1" ebcode="B000" alt="->"/>
  <gaijiMap unicode="#x25b7" ebcode="B001"/>
  <gaijiMap unicode="#x25b7" ebcode="B002"/>
  
EOS


entities = SortedSet.new
default_entities = Set.new

default.scan(/#x([0-9A-Fa-f]+)/) do |m|
  integer = Integer("0x#{m[0]}")
  default_entities.add integer
end

f = File.open('wadoku-ebs-sjis.html', 'r:SJIS:UTF-8')
r = f.read
r.each_line do |line|
  line.scan(/&#x([0-9A-Fa-f]+)/) do |m|
    integer = Integer("0x#{m[0]}")
    entities.add integer unless default_entities.include?(integer)
  end
end
f.close


print default

start_ebcode = Integer('0xA370')

entities.each_with_index do |e, i|
  print "  <gaijiMap unicode=\"#x#{'%04x' % e}\" ebcode=\"#{'%04x' % (start_ebcode + i)}\"/>\n"
end

print '</gaijiSet>'
