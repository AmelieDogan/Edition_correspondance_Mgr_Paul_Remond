<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="tei"
    version="2.0">
    
    <!-- Configuration de sortie -->
    <xsl:output method="html" encoding="UTF-8" indent="yes" doctype-public="-//W3C//DTD HTML 4.01//EN" doctype-system="http://www.w3.org/TR/html4/strict.dtd"/>
    
    <!-- Variable pour l'accès aux personnes, lieux et organisations -->
    <xsl:variable name="persons" select="//tei:listPerson/tei:person"/>
    <xsl:variable name="places" select="//tei:listPlace/tei:place"/>
    <xsl:variable name="orgs" select="//tei:listOrg/tei:org"/>
    <xsl:variable name="main-title" select="//tei:titleStmt/tei:title"/>
    <xsl:variable name="license" select="//tei:publicationStmt/tei:availability/tei:licence"/>
    <xsl:variable name="availability" select="//tei:publicationStmt/tei:availability/@status"/>
    
    <xsl:template match="/">
        <!-- Création du fichier index.html -->
        <xsl:result-document href="output/index.html" method="html">
            <html lang="fr">
                <xsl:call-template name="html-head">
                    <xsl:with-param name="page-title" select="$main-title"/>
                </xsl:call-template>
                <body>
                    <xsl:call-template name="header">
                        <xsl:with-param name="title" select="$main-title"/>
                        <xsl:with-param name="subtitle">Édition numérique</xsl:with-param>
                    </xsl:call-template>
                    
                    <xsl:call-template name="main-navigation"/>
                    
                    <section id="biographie">
                        <h2>Qui est M<sup>gr</sup> Paul Rémond ?</h2>
                        <p>Né dans une famille bourgeoise et religieuse du Jura, Paul Rémond se destine à la prêtrise après une licence en Lettres et un séjour en Allemagne. Ordonné en 1899, il exerce d’abord à Belfort et Besançon, où il se distingue comme un brillant orateur.</p>
                        
                        <p>Mobilisé en 1914, il se distingue au front et devient l’ecclésiastique le plus haut gradé de l’armée française. En 1921, il est nommé évêque et chargé de l’aumônerie de l’armée du Rhin, jouant un rôle diplomatique essentiel auprès de l’Allemagne.</p>
                        
                        <p>Nommé évêque de Nice en 1930, il développe l’Action catholique et condamne dès 1933 l’antisémitisme nazi. Pendant la Seconde Guerre mondiale, après un soutien initial à Vichy, il s’engage dans la Résistance et met en place un réseau qui sauve 527 enfants juifs. Son refus de se plier aux exigences allemandes lui vaut une grande popularité à la Libération.</p>
                        
                        <p>Après la guerre, il fonde le journal <i>La Liberté</i>, critique le communisme et le capitalisme, et soutient brièvement les prêtres ouvriers. Affaibli avec l’âge, il s’éteint en 1963. Ses funérailles à Nice rassemblent une foule nombreuse, témoignant de son influence et de son prestige.</p>
                    </section>
                    
                    <section id="correspondances">
                        <h2>Correspondances</h2>
                        <ul class="letter-list">
                            <xsl:for-each select="//tei:body/tei:div[@type='correspondence']">
                                <xsl:variable name="letter-id" select="@corresp"/>
                                <xsl:variable name="metadata" select="//tei:correspDesc[@xml:id=substring-after($letter-id, '#')]"/>
                                <xsl:variable name="letter-filename">lettre_<xsl:value-of select="position()"/>.html</xsl:variable>
                                <xsl:variable name="letter-title" select="tei:head/node()[not(self::tei:expan)]"/>
                                
                                <li>
                                    <a href="{$letter-filename}">
                                        <strong><xsl:value-of select="$letter-title"/></strong>
                                    </a>
                                    <p class="letter-brief">
                                        <xsl:text>De </xsl:text>
                                        <xsl:value-of select="$metadata/tei:correspAction[@type='sent']/tei:persName"/>
                                        <xsl:text> à </xsl:text>
                                        <xsl:value-of select="$metadata/tei:correspAction[@type='received']/tei:persName"/>
                                        <xsl:text> (</xsl:text>
                                        <xsl:value-of select="$metadata/tei:correspAction[@type='sent']/tei:date"/>
                                        <xsl:text>)</xsl:text>
                                    </p>
                                </li>
                            </xsl:for-each>
                        </ul>
                    </section>
                    
                    <xsl:call-template name="footer"/>
                </body>
            </html>
        </xsl:result-document>
        
        <!-- Création des pages pour chaque lettre -->
        <xsl:for-each select="//tei:body/tei:div[@type='correspondence']">
            <xsl:variable name="letter-id" select="@corresp"/>
            <xsl:variable name="metadata" select="//tei:correspDesc[@xml:id=substring-after($letter-id, '#')]"/>
            <xsl:variable name="letter-filename">lettre_<xsl:value-of select="position()"/>.html</xsl:variable>
            <xsl:variable name="letter-title" select="tei:head/node()[not(self::tei:expan)]"/>
            
            <xsl:result-document href="output/{$letter-filename}" method="html">
                <html lang="fr">
                    <xsl:call-template name="html-head">
                        <xsl:with-param name="page-title" select="$letter-title"/>
                    </xsl:call-template>
                    <body>
                        <xsl:call-template name="header">
                            <xsl:with-param name="title" select="$main-title"/>
                            <xsl:with-param name="subtitle">Édition numérique</xsl:with-param>
                        </xsl:call-template>
                        
                        <xsl:call-template name="main-navigation"/>
                        
                        <article class="letter">
                            <div class="letter-heading">
                                <h2><xsl:value-of select="$letter-title"/></h2>
                            </div>
                            
                            <div class="letter-metadata">
                                <p>
                                    <strong>De : </strong>
                                    <xsl:apply-templates select="$metadata/tei:correspAction[@type='sent']/tei:persName"/>
                                    <xsl:text> (</xsl:text>
                                    <xsl:value-of select="$metadata/tei:correspAction[@type='sent']/tei:placeName/tei:settlement"/>
                                    <xsl:text>, </xsl:text>
                                    <xsl:value-of select="$metadata/tei:correspAction[@type='sent']/tei:date"/>
                                    <xsl:text>)</xsl:text>
                                </p>
                                <p>
                                    <strong>À : </strong>
                                    <xsl:apply-templates select="$metadata/tei:correspAction[@type='received']/tei:persName"/>
                                    <xsl:text> (</xsl:text>
                                    <xsl:choose>
                                        <xsl:when test="$metadata/tei:correspAction[@type='received']/tei:placeName/tei:address/tei:settlement">
                                            <xsl:value-of select="$metadata/tei:correspAction[@type='received']/tei:placeName/tei:address/tei:settlement"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="$metadata/tei:correspAction[@type='received']/tei:placeName/tei:settlement"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                    <xsl:text>)</xsl:text>
                                </p>
                                <xsl:if test="$metadata/tei:correspContext">
                                    <p>
                                        <strong>Contexte : </strong>
                                        <xsl:value-of select="$metadata/tei:correspContext/tei:ref/text()"/>
                                    </p>
                                </xsl:if>
                            </div>
                            
                            <div class="letter-content">
                                <div class="letter-opener">
                                    <xsl:apply-templates select="tei:opener"/>
                                </div>
                                
                                <div class="letter-body">
                                    <xsl:apply-templates select="tei:p"/>
                                </div>
                                
                                <div class="letter-closer">
                                    <xsl:apply-templates select="tei:closer"/>
                                </div>
                            </div>
                        </article>
                        
                        <a href="index.html" class="back-link">Retour à la liste des correspondances</a>
                        
                        <xsl:call-template name="footer"/>
                    </body>
                </html>
            </xsl:result-document>
        </xsl:for-each>
        
        <!-- Création de la page pour l'index des personnes -->
        <xsl:result-document href="output/index_personnes.html" method="html">
            <html lang="fr">
                <xsl:call-template name="html-head">
                    <xsl:with-param name="page-title" select="concat('Index des personnes - ', $main-title)"/>
                </xsl:call-template>
                <body>
                    <xsl:call-template name="header">
                        <xsl:with-param name="title">Index des personnes</xsl:with-param>
                        <xsl:with-param name="subtitle" select="concat($main-title, ' - Édition numérique')"/>
                    </xsl:call-template>
                    
                    <xsl:call-template name="main-navigation"/>
                    
                    <section class="index">
                        <xsl:apply-templates select="//tei:listPerson/tei:person"/>
                    </section>
                    
                    <a href="index.html" class="back-link">Retour à l'accueil</a>
                    
                    <xsl:call-template name="footer"/>
                </body>
            </html>
        </xsl:result-document>
        
        <!-- Création de la page pour l'index des lieux -->
        <xsl:result-document href="output/index_lieux.html" method="html">
            <html lang="fr">
                <xsl:call-template name="html-head">
                    <xsl:with-param name="page-title" select="concat('Index des lieux - ', $main-title)"/>
                </xsl:call-template>
                <body>
                    <xsl:call-template name="header">
                        <xsl:with-param name="title">Index des lieux</xsl:with-param>
                        <xsl:with-param name="subtitle" select="concat($main-title, ' - Édition numérique')"/>
                    </xsl:call-template>
                    
                    <xsl:call-template name="main-navigation"/>
                    
                    <section class="index">
                        <xsl:apply-templates select="//tei:listPlace/tei:place"/>
                    </section>
                    
                    <a href="index.html" class="back-link">Retour à l'accueil</a>
                    
                    <xsl:call-template name="footer"/>
                </body>
            </html>
        </xsl:result-document>
        
        <!-- Création de la page pour l'index des organisations -->
        <xsl:result-document href="output/index_organisations.html" method="html">
            <html lang="fr">
                <xsl:call-template name="html-head">
                    <xsl:with-param name="page-title" select="concat('Index des organisations - ', $main-title)"/>
                </xsl:call-template>
                <body>
                    <xsl:call-template name="header">
                        <xsl:with-param name="title">Index des organisations</xsl:with-param>
                        <xsl:with-param name="subtitle" select="concat($main-title, ' - Édition numérique')"/>
                    </xsl:call-template>
                    
                    <xsl:call-template name="main-navigation"/>
                    
                    <section class="index">
                        <xsl:apply-templates select="//tei:listOrg/tei:org"/>
                    </section>
                    
                    <a href="index.html" class="back-link">Retour à l'accueil</a>
                    
                    <xsl:call-template name="footer"/>
                </body>
            </html>
        </xsl:result-document>
    </xsl:template>
    
    <!-- Template pour l'entête HTML -->
    <xsl:template name="html-head">
        <xsl:param name="page-title"/>
        <head>
            <meta charset="UTF-8"/>
            <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
            <title><xsl:value-of select="$page-title"/></title>
            <link rel="stylesheet" href="css/styles.css"/>
            <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Libre+Baskerville:ital,wght@0,400;0,700;1,400&amp;display=swap"/>
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
            <script>
                document.addEventListener('DOMContentLoaded', function () {
                    const accordeons = document.querySelectorAll('.accordeon');
                
                    accordeons.forEach(accordeon => {
                        const p = accordeon.querySelector('p');
                        const referencesAccordeon = accordeon.querySelector('.references-accordeon');
                    
                        p.addEventListener('click', function () {
                            referencesAccordeon.style.display = referencesAccordeon.style.display === 'block' ? 'none' : 'block';
                            p.classList.toggle('active');
                        });
                    });
                });
            </script>
        </head>
    </xsl:template>
    
    <!-- Template pour l'en-tête de page -->
    <xsl:template name="header">
        <xsl:param name="title"/>
        <xsl:param name="subtitle"/>
        <header>
            <div class="container">
                <h1><xsl:value-of select="$title"/></h1>
                <p><xsl:value-of select="$subtitle"/></p>
            </div>
        </header>
    </xsl:template>
    
    <!-- Template pour la navigation principale -->
    <xsl:template name="main-navigation">
        <nav>
            <div class="container">
                <ul>
                    <li><a href="index.html"><i class="fas fa-home"></i> Accueil</a></li>
                    <li><a href="index_personnes.html"><i class="fas fa-users"></i> Index des personnes</a></li>
                    <li><a href="index_lieux.html"><i class="fas fa-map-marker-alt"></i> Index des lieux</a></li>
                    <li><a href="index_organisations.html"><i class="fas fa-building"></i> Index des organisations</a></li>
                </ul>
            </div>
        </nav>
    </xsl:template>
    
    <!-- Template pour le pied de page -->
    <xsl:template name="footer">
        <footer>
            <div class="container">
                <div class="footer-logo">Archives historiques du diocèse de Nice</div>
                <p>Édition numérique réalisée à partir du document conservé aux Archives historiques du diocèse de Nice (FR AEC / 06 - SC2 2R6, 2)</p>
                <p>
                    <xsl:text>Disponibilité : </xsl:text>
                    <xsl:value-of select="$availability"/>
                    <xsl:text> - </xsl:text>
                    <xsl:value-of select="$license"/>
                </p>
                <p><i class="far fa-copyright"></i> <xsl:value-of select="format-date(current-date(), '[Y]')"/> - Tous droits réservés</p>
            </div>
        </footer>
    </xsl:template>
    
    <!-- Templates pour les composants de la lettre -->
    <xsl:template match="tei:opener">
        <xsl:if test="tei:dateline">
            <div class="place-date">
                <xsl:apply-templates select="tei:dateline"/>
            </div>
        </xsl:if>
        <xsl:if test="tei:salute">
            <div class="salutation">
                <xsl:apply-templates select="tei:salute"/>
            </div>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="tei:closer">
        <div class="closing">
            <xsl:apply-templates select="tei:salute"/>
            <xsl:if test="tei:signed">
                <div class="signed">
                    <xsl:apply-templates select="tei:signed"/>
                </div>
            </xsl:if>
            <xsl:if test="tei:address">
                <div class="address">
                    <xsl:apply-templates select="tei:address"/>
                </div>
            </xsl:if>
        </div>
    </xsl:template>
    
    <!-- Template pour les paragraphes -->
    <xsl:template match="tei:p">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    
    <!-- Templates pour l'index des personnes -->
    <xsl:template match="tei:person">
        <div class="index-entry" id="person-{@xml:id}">
            <h3>
                <xsl:value-of select="tei:persName/tei:forename"/>
                <xsl:text> </xsl:text>
                <xsl:value-of select="tei:persName/tei:surname"/>
            </h3>
            <xsl:if test="tei:persName/tei:roleName">
                <p><strong>Fonction : </strong><xsl:value-of select="tei:persName/tei:roleName"/></p>
            </xsl:if>
            <xsl:if test="tei:birth/tei:date">
                <p><strong>Naissance : </strong><xsl:value-of select="tei:birth/tei:date"/></p>
            </xsl:if>
            <xsl:if test="tei:death/tei:date">
                <p><strong>Décès : </strong><xsl:value-of select="tei:death/tei:date"/></p>
            </xsl:if>
            
            <!-- Ajout des références aux lettres dans lesquelles cette personne apparaît -->
            <xsl:variable name="person-id" select="@xml:id"/>
            <xsl:if test="//tei:body/tei:div[@type='correspondence']/descendant::tei:persName[@ref=concat('#', $person-id)]">
                <div class="accordeon"> 
                    <p>
                        <strong>Apparaît dans</strong>
                    </p>
                    <ul class="references-accordeon">
                        <xsl:for-each select="//tei:body/tei:div[@type='correspondence'][descendant::tei:persName[@ref=concat('#', $person-id)]]">
                            <xsl:variable name="letter-pos" select="position()"/>
                            <xsl:variable name="letter-title" select="tei:head/node()[not(self::tei:expan)]"/>
                            <li>
                                <a href="lettre_{$letter-pos}.html">
                                    <xsl:value-of select="$letter-title"/>
                                </a>
                            </li>
                        </xsl:for-each>
                    </ul>
                </div>
            </xsl:if>
        </div>
    </xsl:template>
    
    <!-- Templates pour l'index des lieux -->
    <xsl:template match="tei:place">
        <div class="index-entry" id="place-{@xml:id}">
            <h3><xsl:value-of select="tei:placeName"/></h3>
            
            <!-- Ajout des références aux lettres dans lesquelles ce lieu apparaît -->
            <xsl:variable name="place-id" select="@xml:id"/>
            <xsl:if test="//tei:body/tei:div[@type='correspondence']/descendant::tei:placeName[@ref=concat('#', $place-id)]">
                <div class="accordeon">
                    <p>
                        <strong>Apparaît dans</strong>
                    </p>
                    <ul class="references-accordeon">
                        <xsl:for-each select="//tei:body/tei:div[@type='correspondence'][descendant::tei:placeName[@ref=concat('#', $place-id)]]">
                            <xsl:variable name="letter-pos" select="position()"/>
                            <xsl:variable name="letter-title" select="tei:head/node()[not(self::tei:expan)]"/>
                            <li>
                                <a href="lettre_{$letter-pos}.html">
                                    <xsl:value-of select="$letter-title"/>
                                </a>
                            </li>
                        </xsl:for-each>
                    </ul>
                </div>
            </xsl:if>
        </div>
    </xsl:template>
    
    <!-- Templates pour l'index des organisations -->
    <xsl:template match="tei:org">
        <div class="index-entry" id="org-{@xml:id}">
            <h3><xsl:value-of select="tei:orgName"/></h3>
            <xsl:if test="tei:desc">
                <p><xsl:value-of select="tei:desc"/></p>
            </xsl:if>
            
            <!-- Ajout des références aux lettres dans lesquelles cette organisation apparaît -->
            <xsl:variable name="org-id" select="@xml:id"/>
            <xsl:if test="//tei:body/tei:div[@type='correspondence']/descendant::tei:orgName[@ref=concat('#', $org-id)]">
                <div class="accordeon">
                    <p>
                        <strong>Apparaît dans</strong>
                    </p>
                    <ul class="references-accordeon">
                        <xsl:for-each select="//tei:body/tei:div[@type='correspondence'][descendant::tei:orgName[@ref=concat('#', $org-id)]]">
                            <xsl:variable name="letter-pos" select="position()"/>
                            <xsl:variable name="letter-title" select="tei:head/node()[not(self::tei:expan)]"/>
                            <li>
                                <a href="lettre_{$letter-pos}.html">
                                    <xsl:value-of select="$letter-title"/>
                                </a>
                            </li>
                        </xsl:for-each>
                    </ul>
                </div>
            </xsl:if>
        </div>
    </xsl:template>
    
    <!-- Templates pour les références aux entités -->
    <xsl:template match="tei:persName[@ref]">
        <xsl:variable name="person-id" select="substring-after(@ref, '#')"/>
        <span class="person" title="{$persons[@xml:id=$person-id]/tei:persName/tei:forename} {$persons[@xml:id=$person-id]/tei:persName/tei:surname}, {$persons[@xml:id=$person-id]/tei:persName/tei:roleName}">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    <xsl:template match="tei:placeName[@ref]">
        <xsl:variable name="place-id" select="substring-after(@ref, '#')"/>
        <span class="place" title="{$places[@xml:id=$place-id]/tei:placeName}">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    <xsl:template match="tei:orgName[@ref]">
        <xsl:variable name="org-id" select="substring-after(@ref, '#')"/>
        <span class="org" title="{$orgs[@xml:id=$org-id]/tei:orgName}">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    <!-- Templates pour les abréviations -->
    <xsl:template match="tei:abbr">
        <abbr title="{following-sibling::tei:expan[1]}">
            <xsl:apply-templates/>
        </abbr>
    </xsl:template>
    
    <!-- Ignorer les éléments expan car leur contenu est déjà utilisé dans les attributs title -->
    <xsl:template match="tei:expan"/>
    
    <!-- Conserver les sauts de ligne -->
    <xsl:template match="tei:lb">
        <br/>
    </xsl:template>
    
    <!-- Conserver les sauts de page -->
    <xsl:template match="tei:pb">
        <hr/>
        <div class="page-break">
            <small>Page <xsl:value-of select="@n"/></small>
        </div>
    </xsl:template>
    
</xsl:stylesheet>