<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl">

	<xsl:output method="xml" indent="yes"/>

	<xsl:template match="/">
		<xsl:for-each select="//ReisDB">
			<!-- 7. Sorteeri kõik reisid vastavalt hinnangule (nt kliendihinnang, kui selline väli on olemas XML-is, kui ei ole kasuta teine numbriline väli).-->
			<xsl:sort select="Total_value" order="ascending" data-type="number"/>
			<h1>
				<xsl:value-of select="info/sihtkoht"/>
				<!-- 1. Kuvada iga reisi sihtkoht pealkirjana, kasutades.-->
			</h1>

			<ul>
				<!-- 2. Komponendid peavad olema kuvatud täpploeteluna -->
				<li>
					<strong>Lennujaam</strong>:
					<span class="third-level">
						<xsl:value-of select="terminal"/>
						(<xsl:value-of select="terminal/@transport"/>)
					</span>
				</li>

				<li>
					<strong>Hinnad</strong>:
					<!-- Kui hind on suurem kui 10 siis värvime punaseks -->
					<xsl:if test="Total_value > 10">
						<span class="suurem">
							<xsl:value-of select="Total_value"/> €
						</span>
					</xsl:if>
					<xsl:if test="Total_value &lt; 10">
						<span class="third-level">
							<xsl:value-of select="Total_value"/> €
						</span>
					</xsl:if>
				</li>

				<li>
					<strong>Aeg</strong>:
					<span class="third-level">
						<!-- Kolmanda taseme struktuuri andmed tuleb kuvada kollasel taustal.-->
						<xsl:value-of select="info/algus"/>—<xsl:value-of select="info/lopp"/>
					</span>
				</li>
			</ul>

			<hr/>
		</xsl:for-each>

		<!-- Hinna summa -->
		<h2>Kogu hind</h2>
		<strong>
			<xsl:value-of select="sum(//ReisDB/Total_value)"/> €
		</strong>

		<!-- Filtreeri ja kuva ainult need reisid, mille sihtkoht on USA.-->
		<h2>Ainult USA sihtkohad</h2>
		<xsl:for-each select="//ReisDB[info/sihtkoht='USA']">
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
					<xsl:if test="Total_value > 10">
						<span class="suurem">
							<xsl:value-of select="Total_value"/> €
						</span>
					</xsl:if>
					<xsl:if test="Total_value &lt; 10">
						<span class="third-level">
							<xsl:value-of select="Total_value"/> €
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
		</xsl:for-each>

		<!-- 8. Kuva kõik xml andmed tabelina, kus read on üle rea erineva värviga.-->
		<h2>Kõik reisid tabelina</h2>
		<table>
			<thead>
				<tr>
					<th>ID</th>
					<th>Sihtkoht</th>
					<th>Lennujaam (transport)</th>
					<th>Hinnad</th>
					<th>Algus</th>
					<th>Lopp</th>
				</tr>
			</thead>
			<tbody>
				<xsl:for-each select="//ReisDB">
					<tr>
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
							<xsl:value-of select="Total_value"/> €
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
