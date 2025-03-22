document.addEventListener('DOMContentLoaded', function () {
    // Gestion des accordéons
    const accordeons = document.querySelectorAll('.accordeon');

    accordeons.forEach(accordeon => {
        const p = accordeon.querySelector('p');
        const referencesAccordeon = accordeon.querySelector('.references-accordeon');

        p.addEventListener('click', function () {
            referencesAccordeon.style.display = referencesAccordeon.style.display === 'block' ? 'none' : 'block';
            p.classList.toggle('active');
        });
    });

    // Gestion des entités nommées
    const entityCheckboxes = document.querySelectorAll('.entity-filter input[type="checkbox"]');

    entityCheckboxes.forEach(checkbox => {
        checkbox.addEventListener('change', function () {
            const entityClass = this.getAttribute('data-entity-class');
            const entities = document.querySelectorAll('.' + entityClass);

            entities.forEach(entity => {
                if (this.checked) {
                    entity.classList.add('highlight');
                } else {
                    entity.classList.remove('highlight');
                }
            });
        });
    });

    // Afficher les informations d'entité au clic
    const allEntities = document.querySelectorAll('.person, .place, .org');
    const entityInfoPanel = document.getElementById('entity-info-panel');

    allEntities.forEach(entity => {
        entity.addEventListener('click', function (e) {
            e.preventDefault();
            const nom = this.getAttribute('data-name');
            const info = this.getAttribute('data-info');
            const entityId = this.getAttribute('data-entity-id');
            const entityType = this.classList.contains('person') ? 'person' :
                this.classList.contains('place') ? 'place' : 'org';

            entityInfoPanel.innerHTML = `
                    <h4>${nom}</h4>
                    <i>dans la lettre : <small>${this.textContent}</small></i>
                    <p>${info}</p>
                    <p><a href="index_${entityType === 'person' ? 'personnes' :
                    entityType === 'place' ? 'lieux' : 'organisations'}.html#${entityType}-${entityId}">
                        Voir la fiche complète
                    </a></p>
                `;
            entityInfoPanel.style.display = 'block';
        });
    });
});