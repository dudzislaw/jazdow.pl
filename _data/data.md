---
imports:
    -
        "/elements/oj-app.html"

styles:
    screen: /lib/css/screen.css

scripts:
    vendor: /lib/js/vendor.min.js
    polyfill: https://cdn.jsdelivr.net/polyfills/polyfill.js-clsls,mtchs
    main: /lib/js/main.min.js


# This is sitewide data accessible with data.<attr>
home_url: /

site_title: Otwarty Jazdów

home_logo:
    title: Otwary Jazdów – Strona Główna
    href: /#/

main_menu:
    pl:
        -
            title: wydarzenia
            href: /#/wydarzenia/
        -
            title: mapa
            href: /#/mapa/
        -
            title: historia
            href: /#/historia/
        -
            title: model
            href: /#/model/
        -
            title: partnerstwo
            href: /#/partnerstwo/
        -
            title: kontakt
            href: "#page-footer"
    en:
        -
            title: events
            href: /#/events/
        -
            title: map
            href: /#/map/
        -
            title: history
            href: /#/history/
        -
            title: model
            href: /#/model-en/
        -
            title: partnership
            href: /#/partnership/
        -
            title: contact
            href: "#page-footer"

contacts:
    -
        title:
            pl: "Kontakt:"
            en: "Contact:"
        details: >
            <p>Otwarty Jazdów<br>ul. Jazdów 3/11<br> 00-122 Warszawa</p>
            <p>otwarty@jazdow.pl</p>
social:
    -
        type: facebook
        href: https://facebook.com/jazdow/
    -
        type: instagram
        href: https://www.instagram.com/jazdow/
---
