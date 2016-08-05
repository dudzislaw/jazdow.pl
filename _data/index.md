---
imports:
    -
        "lib/elements/oj-video.html"
    -
        "lib/elements/oj-expander.html"
    -
        "lib/elements/oj-menu.html"
    -
        "lib/elements/oj-calendar.html"

styles:
    screen: lib/css/screen.css

scripts:
    vendor: lib/js/vendor.min.js
    main: lib/js/main.min.js
#bluebird, jquery, lodash, velocity

lang: "pl"

cards:
    -
        title: historia
        href: /historia.html
        content: <img src="/lib/ui/oj-history.svg">
        caption: Zobacz na osi czasu historię Jazdowa i Domków Fińskich od 1653 roku.
    -
        title: Model
        href: /model.html
        content: <img src="/lib/ui/oj-model.svg">
        caption: Tworzymy społeczny model zarządzania and something and stuff.
    -
        title: Partnerstwo
        href: /partnerstwo.html
        content: 35
        caption: organizacji i osób prywatnych tworzy partnerstwo dla osiedla Jazdów.

events:
    title: Wydarzenia
    intro: "W domkach fińskich działa 16 organizacji, oferujących wiele ciekawych wydarzeń. Zobacz co dzieje się na Jazdowie w najbliższych dniach:"
    page: /wydarzenia.html
    image: /assets/images/arch-duo.png
    limit: 7
    labels:
        when: Kiedy
        where: Gdzie
        what: Co
        button: cały kalendarz
---
Osiedle Jazdów w Warszawie to kolonia parterowych drewnianych domków jednorodzinnych powstała w 1945 roku i znajdująca się na tyłach Parku Ujazdowskiego w Warszawie.

Uses include accessing computed style information, and adding document-level event listeners. (If you use declarative event handling, such as annotated event listeners or the listeners object, Polymer automatically adds listeners on attach and removes them on detach.)
