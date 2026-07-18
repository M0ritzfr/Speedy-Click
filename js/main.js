(function () {
  "use strict";

  /* ---------- Theme-Verwaltung ---------- */
  var root = document.documentElement;
  var buttons = document.querySelectorAll(".theme-switch [data-theme-choice]");
  var thumb = document.querySelector(".theme-thumb");
  var media = window.matchMedia("(prefers-color-scheme: dark)");

  // "system" | "light" | "dark"
  var choice = localStorage.getItem("mortz-theme") || "system";

  function applyTheme() {
    var effective = choice === "system"
      ? (media.matches ? "dark" : "light")
      : choice;
    root.setAttribute("data-theme", effective);
  }

  function moveThumb() {
    var idx = { light: 0, dark: 1, system: 2 }[choice];
    var btnWidth = 38; // muss zur CSS-Breite passen
    thumb.style.transform = "translateX(" + (idx * btnWidth) + "px)";
    buttons.forEach(function (b) {
      b.classList.toggle("active", b.dataset.themeChoice === choice);
    });
  }

  function setChoice(next) {
    choice = next;
    localStorage.setItem("mortz-theme", choice);
    applyTheme();
    moveThumb();
  }

  buttons.forEach(function (btn) {
    btn.addEventListener("click", function () {
      setChoice(btn.dataset.themeChoice);
    });
  });

  // Auf Systemwechsel reagieren, wenn "system" aktiv ist
  media.addEventListener("change", function () {
    if (choice === "system") applyTheme();
  });

  applyTheme();
  moveThumb();

  /* ---------- Sprache / i18n ---------- */
  var LANGS = ["de", "en"];
  var I18N = {
    de: {
      doc_title: "Speedclick — Schnell. Präzise. Kostenlos.",
      doc_desc: "Speedclick – ein schneller, präziser und leichtgewichtiger Autoclicker für Windows. Jetzt kostenlos herunterladen.",
      badge: "Windows · Kostenlos · Ohne Werbung",
      hero_h1: 'Klick schneller.<br><span class="grad">Ohne Anstrengung.</span>',
      lead: "Der Speedclick automatisiert deine Mausklicks mit millisekunden­genauem Timing. Leichtgewichtig, blitzschnell und in Sekunden eingerichtet.",
      btn_download: "Jetzt herunterladen",
      btn_github: "Auf GitHub ansehen",
      hero_meta: "Version 2.2.3 · Setup Speedclick.exe · 32,1 MB · Windows 10/11 (64-bit)",
      features_h2: "Warum Speedclick?",
      f1_h: "Ultraschnell",
      f1_p: "Bis zu tausende Klicks pro Sekunde mit präzisem Intervall-Timing – ohne spürbare Systemlast.",
      f2_h: "Präzise Steuerung",
      f2_p: "Feste Position, Links-/Rechtsklick, Einzel- oder Doppelklick und individuell einstellbare Intervalle.",
      f3_h: "Hotkeys",
      f3_p: "Start und Stopp per frei wählbarer Tastenkombination – auch während des Spielens.",
      f4_h: "Leichtgewichtig",
      f4_p: "Winzige Installation, kein Bloat, keine Werbung. Läuft sauber im Hintergrund.",
      f5_h: "Wiederholungen",
      f5_p: "Endlos klicken oder eine feste Anzahl festlegen – ganz wie du es brauchst.",
      f6_h: "Sicher & sauber",
      f6_p: "Keine versteckten Prozesse, keine Datensammlung. Einfach installieren und loslegen.",
      dl_h2: "Bereit loszulegen?",
      dl_p: "Lade Speedclick herunter und starte in unter einer Minute.",
      btn_setup: "Setup herunterladen",
      dl_meta: "Version 2.2.3 · für Windows 10 & 11",
      footer: '© <span id="year"></span> Speedclick · Erstellt für den privaten Gebrauch.'
    },
    en: {
      doc_title: "Speedclick — Fast. Precise. Free.",
      doc_desc: "Speedclick – a fast, precise and lightweight autoclicker for Windows. Download it for free.",
      badge: "Windows · Free · No ads",
      hero_h1: 'Click faster.<br><span class="grad">Effortlessly.</span>',
      lead: "Speedclick automates your mouse clicks with millisecond-precise timing. Lightweight, blazing fast and set up in seconds.",
      btn_download: "Download now",
      btn_github: "View on GitHub",
      hero_meta: "Version 2.2.3 · Setup Speedclick.exe · 32.1 MB · Windows 10/11 (64-bit)",
      features_h2: "Why Speedclick?",
      f1_h: "Ultra fast",
      f1_p: "Up to thousands of clicks per second with precise interval timing – without noticeable system load.",
      f2_h: "Precise control",
      f2_p: "Fixed position, left/right click, single or double click and freely adjustable intervals.",
      f3_h: "Hotkeys",
      f3_p: "Start and stop with a freely selectable hotkey – even while gaming.",
      f4_h: "Lightweight",
      f4_p: "Tiny install, no bloat, no ads. Runs cleanly in the background.",
      f5_h: "Repetitions",
      f5_p: "Click endlessly or set a fixed number – exactly as you need.",
      f6_h: "Safe & clean",
      f6_p: "No hidden processes, no data collection. Just install and go.",
      dl_h2: "Ready to get started?",
      dl_p: "Download Speedclick and get started in under a minute.",
      btn_setup: "Download setup",
      dl_meta: "Version 2.2.3 · for Windows 10 & 11",
      footer: '© <span id="year"></span> Speedclick · Created for private use.'
    }
  };

  var langButtons = document.querySelectorAll(".lang-switch [data-lang]");
  var langThumb = document.querySelector(".lang-thumb");

  var stored = localStorage.getItem("mortz-lang");
  var navLang = (navigator.language || "de").slice(0, 2).toLowerCase();
  var lang = stored || (LANGS.indexOf(navLang) !== -1 ? navLang : "de");
  if (LANGS.indexOf(lang) === -1) lang = "de";

  function setYear() {
    var y = document.getElementById("year");
    if (y) y.textContent = new Date().getFullYear();
  }

  function applyLang() {
    var dict = I18N[lang];
    root.setAttribute("lang", lang);
    Object.keys(dict).forEach(function (key) {
      if (key === "doc_title") { document.title = dict[key]; return; }
      if (key === "doc_desc") {
        var m = document.querySelector('meta[name="description"]');
        if (m) m.setAttribute("content", dict[key]);
        return;
      }
      var el = document.querySelector('[data-i18n="' + key + '"]');
      if (el) el.innerHTML = dict[key];
    });
    setYear(); // Footer wurde evtl. neu geschrieben -> Jahr erneut setzen
  }

  function moveLangThumb() {
    var idx = LANGS.indexOf(lang);
    if (idx < 0) idx = 0;
    var btnWidth = 44; // muss zur CSS-Breite passen
    langThumb.style.transform = "translateX(" + (idx * btnWidth) + "px)";
    langButtons.forEach(function (b) {
      b.classList.toggle("active", b.dataset.lang === lang);
    });
  }

  function setLang(next) {
    if (LANGS.indexOf(next) === -1 || next === lang) return;
    lang = next;
    localStorage.setItem("mortz-lang", lang);
    applyLang();
    moveLangThumb();
  }

  langButtons.forEach(function (btn) {
    btn.addEventListener("click", function () {
      setLang(btn.dataset.lang);
    });
  });

  applyLang();
  moveLangThumb();

  /* ---------- Cursor-Glow ---------- */
  var glow = document.getElementById("cursorGlow");
  var tx = 0, ty = 0, cx = 0, cy = 0, active = false, raf = null;

  function render() {
    // sanftes Nachziehen
    cx += (tx - cx) * 0.18;
    cy += (ty - cy) * 0.18;
    glow.style.transform = "translate3d(" + cx + "px," + cy + "px,0) translate(-50%,-50%)";
    if (Math.abs(tx - cx) > 0.4 || Math.abs(ty - cy) > 0.4) {
      raf = requestAnimationFrame(render);
    } else {
      raf = null;
    }
  }

  window.addEventListener("pointermove", function (e) {
    if (e.pointerType === "touch") return;
    tx = e.clientX;
    ty = e.clientY;
    if (!active) {
      active = true;
      cx = tx; cy = ty;
      glow.classList.add("is-visible");
    }
    if (!raf) raf = requestAnimationFrame(render);
  }, { passive: true });

  window.addEventListener("mouseleave", function () {
    glow.classList.remove("is-visible");
    active = false;
  });
  window.addEventListener("blur", function () {
    glow.classList.remove("is-visible");
    active = false;
  });

  /* ---------- Jahr im Footer ---------- */
  var yearEl = document.getElementById("year");
  if (yearEl) yearEl.textContent = new Date().getFullYear();
})();
