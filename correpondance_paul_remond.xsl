<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="tei"
    version="2.0">
    
    <xsl:output method="html" encoding="UTF-8" indent="yes" doctype-public="-//W3C//DTD HTML 4.01//EN" doctype-system="http://www.w3.org/TR/html4/strict.dtd"/>
    
    <xsl:variable name="main-title" select="//titleStmt/title"/>
    <xsl:variable name="license" select="//publicationStmt/availability/licence"/>
    <xsl:variable name="availability" select="//publicationStmt/availability/@status"/>
    
    <!-- Variable pour l'accès aux personnes, lieux et organisations -->
    <xsl:variable name="persons" select="//listPerson/person"/>
    <xsl:variable name="places" select="//listPlace/place"/>
    <xsl:variable name="orgs" select="//listOrg/org"/>
    
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
                        
                        <!-- Regrouper par année -->
                        <xsl:for-each-group select="//body/div[@type='correspondence']" 
                            group-by="substring(//correspDesc[@xml:id=substring-after(current()/@corresp, '#')]/correspAction[@type='sent']/date/@when, 1, 4)">
                            <xsl:sort select="current-grouping-key()" data-type="text" order="ascending"/>
                            
                            <h3>Année <xsl:value-of select="current-grouping-key()"/></h3>
                            <ul class="letter-list">
                                <!-- Trier les lettres par date dans chaque groupe -->
                                <xsl:for-each select="current-group()">
                                    <xsl:sort select="//correspDesc[@xml:id=substring-after(current()/@corresp, '#')]/correspAction[@type='sent']/date/@when" 
                                        data-type="text" order="ascending"/>
                                    
                                    <xsl:variable name="letter-id" select="@corresp"/>
                                    <xsl:variable name="letter-id-clean" select="substring-after($letter-id, '#')"/>
                                    <xsl:variable name="metadata" select="//correspDesc[@xml:id=$letter-id-clean]"/>
                                    <xsl:variable name="letter-filename">lettre_<xsl:value-of select="$letter-id-clean"/>.html</xsl:variable>
                                    <xsl:variable name="letter-title" select="head/node()[not(self::expan)]"/>
                                    <xsl:variable name="letter-date" select="$metadata/correspAction[@type='sent']/date/@when"/>
                                    
                                    <li>
                                        <a href="{$letter-filename}">
                                            <strong><xsl:value-of select="$letter-title"/></strong>
                                        </a>
                                        <p class="letter-brief">
                                            <xsl:text>De </xsl:text>
                                            <xsl:value-of select="$metadata/correspAction[@type='sent']/persName"/>
                                            <xsl:text> à </xsl:text>
                                            <xsl:value-of select="$metadata/correspAction[@type='received']/persName"/>
                                            <xsl:text> (</xsl:text>
                                            <xsl:value-of select="$metadata/correspAction[@type='sent']/date"/>
                                            <xsl:text>)</xsl:text>
                                        </p>
                                    </li>
                                </xsl:for-each>
                            </ul>
                        </xsl:for-each-group>
                    </section>
                    
                    <xsl:call-template name="footer"/>
                </body>
            </html>
        </xsl:result-document>
        
        <!-- Création des pages pour chaque lettre -->
        <xsl:for-each select="//body/div[@type='correspondence']">
            <xsl:variable name="letter-id" select="@corresp"/>
            <xsl:variable name="letter-id-clean" select="substring-after(@corresp, '#')"/>
            <xsl:variable name="letter-filename">lettre_<xsl:value-of select="$letter-id-clean"/>.html</xsl:variable>
            <xsl:variable name="metadata" select="//correspDesc[@xml:id=substring-after($letter-id, '#')]"/>
            <xsl:variable name="letter-title" select="head/node()[not(self::expan)]"/>
            <xsl:variable name="current-letter" select="."/>
            
            <!-- Variables pour stocker les références aux entités dans la lettre courante -->
            <xsl:variable name="letter-persons" select="distinct-values(.//persName/@ref[.!=''])"/>
            <xsl:variable name="letter-places" select="distinct-values(.//placeName/@ref[.!=''])"/>
            <xsl:variable name="letter-orgs" select="distinct-values(.//orgName/@ref[.!=''])"/>
            
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
                        
                        <div class="content-with-sidebar">
                            <aside class="sidebar">
                                <div class="entity-filter">
                                    <h3>Surligner des entités</h3>
                                    
                                    <!-- Section pour les personnes -->
                                    <xsl:if test="count($letter-persons) > 0">
                                        <div class="filter-group">
                                            <h4>Personnes</h4>
                                            <xsl:for-each select="$persons">
                                                <xsl:sort select="concat(persName/surname, ', ', persName/forename)" data-type="text" order="ascending"/>
                                                <xsl:variable name="person-ref" select="concat('#', @xml:id)"/>
                                                <xsl:if test="$person-ref = $letter-persons">
                                                    <div class="filter-item">
                                                        <input type="checkbox" id="person-{@xml:id}-filter" data-entity-class="person-{@xml:id}" />
                                                        <label for="person-{@xml:id}-filter">
                                                            <xsl:value-of select="persName/surname/node()[not(self::expan)]"/>
                                                            <xsl:text>, </xsl:text>
                                                            <xsl:value-of select="persName/forename/node()[not(self::expan)]"/>
                                                        </label>
                                                    </div>
                                                </xsl:if>
                                            </xsl:for-each>
                                        </div>
                                    </xsl:if>
                                    
                                    <!-- Section pour les lieux -->
                                    <xsl:if test="count($letter-places) > 0">
                                        <div class="filter-group">
                                            <h4>Lieux</h4>
                                            <xsl:for-each select="$places">
                                                <xsl:sort select="placeName" data-type="text" order="ascending"/>
                                                <xsl:variable name="place-ref" select="concat('#', @xml:id)"/>
                                                <xsl:if test="$place-ref = $letter-places">
                                                    <div class="filter-item">
                                                        <input type="checkbox" id="place-{@xml:id}-filter" data-entity-class="place-{@xml:id}" />
                                                        <label for="place-{@xml:id}-filter">
                                                            <xsl:value-of select="placeName/node()[not(self::expan)]"/>
                                                        </label>
                                                    </div>
                                                </xsl:if>
                                            </xsl:for-each>
                                        </div>
                                    </xsl:if>
                                    
                                    <!-- Section pour les organisations -->
                                    <xsl:if test="count($letter-orgs) > 0">
                                        <div class="filter-group">
                                            <h4>Organisations</h4>
                                            <xsl:for-each select="$orgs">
                                                <xsl:sort select="orgName" data-type="text" order="ascending"/>
                                                <xsl:variable name="org-ref" select="concat('#', @xml:id)"/>
                                                <xsl:if test="$org-ref = $letter-orgs">
                                                    <div class="filter-item">
                                                        <input type="checkbox" id="org-{@xml:id}-filter" data-entity-class="org-{@xml:id}" />
                                                        <label for="org-{@xml:id}-filter">
                                                            <xsl:value-of select="orgName/node()[not(self::expan)]"/>
                                                        </label>
                                                    </div>
                                                </xsl:if>
                                            </xsl:for-each>
                                        </div>
                                        
                                        <h3>Informations sur une entité</h3>
                                        
                                        <div id="entity-info-panel" class="entity-info">
                                            <p>Cliquez sur entité nommée pour afficher ses informations</p>
                                            <!-- Les informations sur l'entité sélectionnée s'afficheront ici grâce au Javascript -->
                                        </div>
                                    </xsl:if>
                                    
                                    <!-- Message si aucune entité n'est présente -->
                                    <xsl:if test="count($letter-persons) = 0 and count($letter-places) = 0 and count($letter-orgs) = 0">
                                        <p>Aucune entité nommée n'est présente dans cette lettre.</p>
                                    </xsl:if>
                                </div>
                            </aside>
                            
                            <main class="main-content">
                                <article class="letter">
                                    <div class="letter-heading">
                                        <h2><xsl:value-of select="$letter-title"/></h2>
                                    </div>
                                    
                                    <div class="letter-metadata">
                                        <p>
                                            <strong>De : </strong>
                                            <xsl:apply-templates select="$metadata/correspAction[@type='sent']/persName"/>
                                            <xsl:text> (</xsl:text>
                                            <xsl:value-of select="$metadata/correspAction[@type='sent']/placeName/settlement"/>
                                            <xsl:text>, </xsl:text>
                                            <xsl:value-of select="$metadata/correspAction[@type='sent']/date"/>
                                            <xsl:text>)</xsl:text>
                                        </p>
                                        <p>
                                            <strong>À : </strong>
                                            <xsl:apply-templates select="$metadata/correspAction[@type='received']/persName"/>
                                            <xsl:text> (</xsl:text>
                                            <xsl:choose>
                                                <xsl:when test="$metadata/correspAction[@type='received']/placeName/address/settlement">
                                                    <xsl:value-of select="$metadata/correspAction[@type='received']/placeName/address/settlement"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="$metadata/correspAction[@type='received']/placeName/settlement"/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                            <xsl:text>)</xsl:text>
                                        </p>
                                        <xsl:if test="$metadata/correspContext">
                                            <p>
                                                <strong>Contexte : </strong>
                                                <xsl:value-of select="$metadata/correspContext/ref/text()"/>
                                            </p>
                                        </xsl:if>
                                    </div>
                                    
                                    <div class="letter-content">
                                        <div class="letter-opener">
                                            <xsl:apply-templates select="opener"/>
                                        </div>
                                        
                                        <div class="letter-body">
                                            <xsl:apply-templates select="p"/>
                                        </div>
                                        
                                        <div class="letter-closer">
                                            <xsl:apply-templates select="closer"/>
                                        </div>
                                    </div>
                                </article>
                                
                                <a href="index.html" class="back-link">Retour à la liste des correspondances</a>
                            </main>
                        </div>
                        
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
                        <xsl:apply-templates select="//listPerson/person">
                            <xsl:sort select="persName/surname" data-type="text" order="ascending"/>
                            <xsl:sort select="persName/forename" data-type="text" order="ascending"/>
                        </xsl:apply-templates>
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
                        <xsl:apply-templates select="//listPlace/place">
                            <xsl:sort select="placeName" data-type="text" order="ascending"/>
                        </xsl:apply-templates>
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
                        <xsl:apply-templates select="//listOrg/org">
                            <xsl:sort select="orgName" data-type="text" order="ascending"/>
                        </xsl:apply-templates>
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
            <link rel="stylesheet" href="static/css/styles.css"/>
            <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Libre+Baskerville:ital,wght@0,400;0,700;1,400&amp;display=swap"/>
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
            <script src="static/js/main.js"></script>
        </head>
    </xsl:template>
    
    <!-- Template pour l'en-tête de page -->
    <xsl:template name="header">
        <xsl:param name="title"/>
        <xsl:param name="subtitle"/>
        <header>
            <div class="container">
                <div class="header-content">
                    <div class="header-logo left">
                        <img src="static/images/Blason_Paul_Remond.png" alt="Blason de Mgr Rémond" />
                    </div>
                    <div class="header-text">
                        <h1><xsl:value-of select="$title"/></h1>
                        <p><xsl:value-of select="$subtitle"/></p>
                    </div>
                    <div class="header-logo right">
                        <img src="static/images/Blason_Paul_Remond.png" alt="Blason de Mgr Rémond" />
                    </div>
                </div>
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
    <xsl:template match="opener">
        <xsl:if test="dateline">
            <div class="place-date">
                <xsl:apply-templates select="dateline"/>
            </div>
        </xsl:if>
        <xsl:if test="salute">
            <div class="salutation">
                <xsl:apply-templates select="salute"/>
            </div>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="closer">
        <div class="closing">
            <xsl:apply-templates select="salute"/>
            <xsl:if test="signed">
                <div class="signed">
                    <xsl:apply-templates select="signed"/>
                </div>
            </xsl:if>
            <xsl:if test="address">
                <div class="address">
                    <xsl:apply-templates select="address"/>
                </div>
            </xsl:if>
        </div>
    </xsl:template>
    
    <!-- Template pour les paragraphes -->
    <xsl:template match="p">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    
    <!-- Templates pour l'index des personnes -->
    <xsl:template match="person">
        <div class="index-entry" id="person-{@xml:id}">
            <h3>
                <xsl:value-of select="persName/surname/node()[not(self::expan)]"/>
                <xsl:text>, </xsl:text>
                <xsl:value-of select="persName/forename/node()[not(self::expan)]"/>
            </h3>
            <xsl:if test="persName/roleName">
                <p><strong>Fonction : </strong><xsl:value-of select="persName/roleName"/></p>
            </xsl:if>
            <xsl:if test="birth/date">
                <p><strong>Naissance : </strong><xsl:value-of select="birth/date"/></p>
            </xsl:if>
            <xsl:if test="death/date">
                <p><strong>Décès : </strong><xsl:value-of select="death/date"/></p>
            </xsl:if>
            <xsl:if test="note">
                <p><xsl:value-of select="note"/></p>
            </xsl:if>
            
            <!-- Ajout des références aux lettres dans lesquelles cette personne apparaît -->
            <xsl:variable name="person-id" select="@xml:id"/>
            <xsl:if test="//body/div[@type='correspondence']/descendant::persName[@ref=concat('#', $person-id)]">
                <div class="accordeon"> 
                    <p>
                        <strong>Apparaît dans</strong>
                    </p>
                    <ul class="references-accordeon">
                        <xsl:for-each select="//body/div[@type='correspondence'][descendant::persName[@ref=concat('#', $person-id)]]">
                            <xsl:sort select="//correspDesc[@xml:id=substring-after(current()/@corresp, '#')]/correspAction[@type='sent']/date/@when" 
                                data-type="text" order="ascending"/>
                            <xsl:variable name="letter-id-clean" select="substring-after(@corresp, '#')"/>
                            <xsl:variable name="letter-title" select="head/node()[not(self::expan)]"/>
                            <li>
                                <a href="lettre_{$letter-id-clean}.html">
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
    <xsl:template match="place">
        <div class="index-entry" id="place-{@xml:id}">
            <h3><xsl:value-of select="placeName/node()[not(self::expan)]"/></h3>
            <xsl:if test="desc">
                <p><xsl:value-of select="desc"/></p>
            </xsl:if>
            
            <!-- Ajout des références aux lettres dans lesquelles ce lieu apparaît -->
            <xsl:variable name="place-id" select="@xml:id"/>
            <xsl:if test="//body/div[@type='correspondence']/descendant::placeName[@ref=concat('#', $place-id)]">
                <div class="accordeon">
                    <p>
                        <strong>Apparaît dans</strong>
                    </p>
                    <ul class="references-accordeon">
                        <xsl:for-each select="//body/div[@type='correspondence'][descendant::placeName[@ref=concat('#', $place-id)]]">
                            <xsl:sort select="//correspDesc[@xml:id=substring-after(current()/@corresp, '#')]/correspAction[@type='sent']/date/@when" 
                                data-type="text" order="ascending"/>
                            <xsl:variable name="letter-id-clean" select="substring-after(@corresp, '#')"/>
                            <xsl:variable name="letter-title" select="head/node()[not(self::expan)]"/>
                            <li>
                                <a href="lettre_{$letter-id-clean}.html">
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
    <xsl:template match="org">
        <div class="index-entry" id="org-{@xml:id}">
            <h3><xsl:value-of select="orgName/node()[not(self::expan)]"/></h3>
            <xsl:if test="desc">
                <p><xsl:value-of select="desc"/></p>
            </xsl:if>
            
            <!-- Ajout des références aux lettres dans lesquelles cette organisation apparaît -->
            <xsl:variable name="org-id" select="@xml:id"/>
            <xsl:if test="//body/div[@type='correspondence']/descendant::orgName[@ref=concat('#', $org-id)]">
                <div class="accordeon">
                    <p>
                        <strong>Apparaît dans</strong>
                    </p>
                    <ul class="references-accordeon">
                        <xsl:for-each select="//body/div[@type='correspondence'][descendant::orgName[@ref=concat('#', $org-id)]]">
                            <xsl:sort select="//correspDesc[@xml:id=substring-after(current()/@corresp, '#')]/correspAction[@type='sent']/date/@when" 
                                data-type="text" order="ascending"/>
                            <xsl:variable name="letter-id-clean" select="substring-after(@corresp, '#')"/>
                            <xsl:variable name="letter-title" select="head/node()[not(self::expan)]"/>
                            <li>
                                <a href="lettre_{$letter-id-clean}.html">
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
    <xsl:template match="persName[@ref]">
        <xsl:variable name="person-id" select="substring-after(@ref, '#')"/>
        <xsl:variable name="person" select="$persons[@xml:id=$person-id]"/>
        <xsl:variable name="person-name" select="concat($person/persName/forename/node()[not(self::expan)], ' ', $person/persName/surname/node()[not(self::expan)])"/>
        <span class="person person-{$person-id}" 
            data-entity-id="{$person-id}"
            data-name="{$person-name}"
            data-info="{$person/persName/roleName}">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    <xsl:template match="placeName[@ref]">
        <xsl:variable name="place-id" select="substring-after(@ref, '#')"/>
        <xsl:variable name="place" select="$places[@xml:id=$place-id]"/>
        <span class="place place-{$place-id}" 
            data-entity-id="{$place-id}"
            data-name="{$place/placeName/node()[not(self::expan)]}"
            data-info="{$place/desc}">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    <xsl:template match="orgName[@ref]">
        <xsl:variable name="org-id" select="substring-after(@ref, '#')"/>
        <xsl:variable name="org" select="$orgs[@xml:id=$org-id]"/>
        <span class="org org-{$org-id}" 
            data-entity-id="{$org-id}"
            data-name="{$org/orgName/node()[not(self::expan)]}"
            data-info="{$org/desc}">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    <!-- Templates pour les abréviations -->
    <xsl:template match="abbr">
        <abbr title="{following-sibling::expan[1]}">
            <xsl:apply-templates/>
        </abbr>
    </xsl:template>
    
    <!-- Ignorer les éléments expan car leur contenu est déjà utilisé dans les attributs title -->
    <xsl:template match="expan"/>
    
    <!-- Conserver les sauts de ligne -->
    <xsl:template match="lb">
        <br/>
    </xsl:template>
    
    <!-- Conserver les sauts de page -->
    <xsl:template match="pb">
        <hr/>
        <div class="page-break">
            <small>Page <xsl:value-of select="@n"/></small>
        </div>
    </xsl:template>
    
</xsl:stylesheet>