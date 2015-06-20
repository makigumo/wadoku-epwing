# Merkzettel zur Formatierung der Einträge

## Basiselemente

### Überschriften

Explizit angegebens Title-Attribut wird zur Anzeige im Suchergebnis genutzt.

```html
<h1 title="…">…</h1>
```

### Absätze

```html
<p>…</p>
```

### Zitate (Darstellung mit Einrückung)

```html
<blockquote>…</blockquote>
```

### Kommentare

```html
<!-- … -->
```

## Dekoratorelemente

```html
<br>
<sub>…</sub>
<sup>…</sup>
<nobr>…</nobr>
<b>…</b> = <strong>…</strong>
<i>…</i> = <em>…</em>
```

## Verlinkung

Verlinkung über Element-ID oder Anchor-Element.

### Link

```html
<a href="#element_id">…</a>
```

### Anchor setzen.

```html
<a name="anchor_name">…</a>
```

### Verlinkung zu anderer Datei.

```html
<a href="datei_name#element_id">…</a>
```

## Listen

### Definitionslisten

```<dl/>``` Liste mit Einträgen.

```<dt title="…"/>``` Stichwort, kommt automatisch in den Suchindex, explizites ```title```-Attribut wird zur Anzeige im Suchergebnis genutzt.

```<dd/>``` Erklärung.

```html
<dl>
  <dt>…</dt>
  <dd>…</dd>
</dl>
```

## (un)nummerierte Listen

### Nummerierte Liste
 
Ein explizites ```start```-Attribut bestimmt Startindex.

```html
<ol start="…">
  <li>…</li>
</ol>
```

### Unnummerierte Liste.

```html
<ul>
  <li>…</li>
</ul>
```

## Wortdefinition

Zur Kennzeichnung von Wörtern im Erklärungstext, die in den Suchindex aufgenommen werden.
Ein explizites ```title```-Attribut wird zur Anzeige im Suchergebnis genutzt.
Muss explizit aktiviert werden: 「<dfn> を副見出しにする」.

```html
<dfn title="…">…</dfn>
```

## Ruby/Furigana

```html
<ruby>
  <rb>…</rb>
  <rt>…</rt>
</ruby>
```

## Abbildungen

Aktivierung in den Multimedia-Optionen: 「図版・動画・音声を作成する」.

Unterstützte Formate: JPEG, BMP.

Bei monochromen BMP-Bildern muss die Bildbreite ein Vielfaches von 32 sein.
Die Aktivierung der Option zur *Anzeige monochromer BMP-Bilder als farbige Abbildung* (白黒BMPをカラー図版として出力) umgeht die Beschränkung.

```
optMono=0
```

### Abbildungslink

Explizite Inline-Darstellung durch ```class="inline"``` oder Option「<img>はインライン画像に変換」.
```
inlineImg=0
```

* ```src="…"``` Dateiname.
* ```alt="…"``` (optional) Abbildungsname.
```html
<img src="image.bmp" alt="アイガー" >
```

Explizite Link-Darstellung durch ```<a href="…">…</a>``` oder ```<object data="…"/>```.

## Gaiji

Angabe als HTML-Entity mit Unicodewert.

```html
&#x9127;
```

## Erweiterungen

### ```title```-Attribut

Wird zur Anzeige im Suchergebnis genutzt.

### ```noindex```-Attribut in ```<Hn>```- und  ```<dt>```-Elementen

```html
<H3 noindex="true">
<dt noindex="1">
```

### ```<indent>```-Element zur Einrückung

```html
<indent val="2">
```

### ```<key>```-Element zur Erweiterung des Suchindexes

Linkt auf den vorhergehenden Absatz. Um

```html
<key type="…" title="…" name="…">…</key>
```

* Indextyp: ```type="…"```
    * "かな", "カナ" oder "仮名"
    * "表記"
    * "前方表記"
    * "後方表記"
    * "前方かな"
    * "後方かな"
    * "条件"
    * "クロス"
    * "複合"
* expliziter Anzeigewert im Suchergebnis: ```title="…"```
* in der Datei für die Komplexsuche definierter Kategorienname:  ```name="…"```
    * wenn Indextyp "複合" ist.

