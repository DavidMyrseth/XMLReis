<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl">

	<xsl:output method="xml" indent="yes"/>

	<xsl:template match="/">
		<!-- 6. Filtreeri ja kuva ainult need reisid, mille transport sisaldab lennureisi -->
		<h2>Ainult lennureisid (sisaldavad "Airport")</h2>
		<xsl:for-each select="//ReisDB[contains(terminal, 'Airport')]">
			<xsl:sort select="Total_value" order="ascending" data-type="number"/>
			<h1>
				<xsl:value-of select="info/sihtkoht"/>
			</h1>
			<link rel="stylesheet" type="text/css" href="style.css"/>
			<ul>
				<li>
					<strong>Lennujaam</strong>:
					<span class="third-level">
						<xsl:value-of select="terminal"/>
						(<xsl:value-of select="terminal/@transport"/>)
					</span>
				</li>

				<li>
					<strong>Hinnad</strong>:
					<!-- 5. Kuva iga reisi kogumaksumuse, liites transport, majutuse, ekskursioonide ja muude kulude hinnad kokku -->
					<xsl:variable name="transport_hind" select="Total_value * 0.4"/>
					<xsl:variable name="majutus_hind" select="Total_value * 0.3"/>
					<xsl:variable name="ekskursioonid_hind" select="Total_value * 0.2"/>
					<xsl:variable name="muud_kulud" select="Total_value * 0.1"/>
					<xsl:variable name="kogu_maksumus" select="$transport_hind + $majutus_hind + $ekskursioonid_hind + $muud_kulud"/>

					<xsl:if test="Total_value > 10">
						<span class="suurem">
							Kogu maksumus: <xsl:value-of select="format-number($kogu_maksumus, '#.##')"/> €
							<br/>
							(Transport: <xsl:value-of select="format-number($transport_hind, '#.##')"/> €,
							Majutus: <xsl:value-of select="format-number($majutus_hind, '#.##')"/> €,
							Ekskursioonid: <xsl:value-of select="format-number($ekskursioonid_hind, '#.##')"/> €,
							Muud: <xsl:value-of select="format-number($muud_kulud, '#.##')"/> €)
						</span>
					</xsl:if>
					<xsl:if test="Total_value &lt;= 10">
						<span class="third-level">
							Kogu maksumus: <xsl:value-of select="format-number($kogu_maksumus, '#.##')"/> €
							<br/>
							(Transport: <xsl:value-of select="format-number($transport_hind, '#.##')"/> €,
							Majutus: <xsl:value-of select="format-number($majutus_hind, '#.##')"/> €,
							Ekskursioonid: <xsl:value-of select="format-number($ekskursioonid_hind, '#.##')"/> €,
							Muud: <xsl:value-of select="format-number($muud_kulud, '#.##')"/> €)
						</span>
					</xsl:if>
				</li>

				<li>
					<strong>Aeg</strong>:
					<span class="third-level">
						<xsl:value-of select="info/algus"/>—<xsl:value-of select="info/lopp"/>
					</span>
				</li>
			</ul>

			<hr/>
		</xsl:for-each>

		<!-- Kõikide reiside kogu hind -->
		<h2>Kõikide reiside kogu hind</h2>
		<strong>
			<xsl:value-of select="sum(//ReisDB/Total_value)"/> €
		</strong>

		<!-- Tabel kõikide reisidega -->
		<h2>Kõik reisid tabelina (üle rea erineva värviga)</h2>
		<table border="1">
			<thead>
				<tr style="background-color: #ddd;">
					<th>ID</th>
					<th>Sihtkoht</th>
					<th>Lennujaam (transport)</th>
					<th>Kogu maksumus</th>
					<th>Transport</th>
					<th>Majutus</th>
					<th>Ekskursioonid</th>
					<th>Muud kulud</th>
					<th>Algus</th>
					<th>Lopp</th>
				</tr>
			</thead>
			<tbody>
				<xsl:for-each select="//ReisDB">
					<!-- 8. Kuva kõik xml andmed tabelina, kus read on üle rea erineva värviga -->
					<xsl:variable name="rowColor">
						<xsl:choose>
							<xsl:when test="position() mod 2 = 0">#f0f0f0</xsl:when>
							<xsl:otherwise>#ffffff</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>

					<!-- 5. Arvuta kogumaksumus iga reisi jaoks -->
					<xsl:variable name="transport_hind" select="Total_value * 0.4"/>
					<xsl:variable name="majutus_hind" select="Total_value * 0.3"/>
					<xsl:variable name="ekskursioonid_hind" select="Total_value * 0.2"/>
					<xsl:variable name="muud_kulud" select="Total_value * 0.1"/>
					<xsl:variable name="kogu_maksumus" select="$transport_hind + $majutus_hind + $ekskursioonid_hind + $muud_kulud"/>

					<tr style="background-color: {$rowColor};">
						<td>
							<xsl:value-of select="@id"/>
						</td>
						<td>
							<xsl:value-of select="info/sihtkoht"/>
						</td>
						<td>
							<xsl:value-of select="terminal"/>
							(<xsl:value-of select="terminal/@transport"/>)
						</td>
						<td>
							<strong>
								<xsl:value-of select="format-number($kogu_maksumus, '#.##')"/> €
							</strong>
						</td>
						<td>
							<xsl:value-of select="format-number($transport_hind, '#.##')"/> €
						</td>
						<td>
							<xsl:value-of select="format-number($majutus_hind, '#.##')"/> €
						</td>
						<td>
							<xsl:value-of select="format-number($ekskursioonid_hind, '#.##')"/> €
						</td>
						<td>
							<xsl:value-of select="format-number($muud_kulud, '#.##')"/> €
						</td>
						<td>
							<xsl:value-of select="info/algus"/>
						</td>
						<td>
							<xsl:value-of select="info/lopp"/>
						</td>
					</tr>
				</xsl:for-each>
			</tbody>
		</table>

	</xsl:template>
</xsl:stylesheet>