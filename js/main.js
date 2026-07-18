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
