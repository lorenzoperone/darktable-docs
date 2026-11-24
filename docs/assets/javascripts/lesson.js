/* Lezioni interattive (Ondata I.6).
 * Arricchisce <div class="dt-lesson" data-steps='[{title,img},…]'>:
 * pulsanti dei passi + confronto prima/dopo con cursore trascinabile.
 * Il contenuto statico della pagina resta leggibile anche senza JS.
 */
(function () {
  function build(root) {
    if (root.dataset.ready) return;
    let steps;
    try { steps = JSON.parse(root.dataset.steps); } catch (e) { return; }
    if (!steps || steps.length < 2) return;
    root.dataset.ready = "1";

    let current = 1;
    let ref = "prev"; // "prev" = passo precedente, "first" = apertura

    root.innerHTML = `
      <div class="dt-lesson__bar" role="tablist" aria-label="Passi della lezione"></div>
      <div class="dt-lesson__ref">
        Confronta con:
        <label><input type="radio" name="ref-${Math.random().toString(36).slice(2)}" value="prev" checked> passo precedente</label>
        <label><input type="radio" name="ref" value="first"> apertura</label>
      </div>
      <div class="dt-lesson__stage">
        <img class="dt-lesson__after" alt="">
        <img class="dt-lesson__before" alt="">
        <div class="dt-lesson__handle" aria-hidden="true"></div>
        <span class="dt-lesson__label dt-lesson__label--l"></span>
        <span class="dt-lesson__label dt-lesson__label--r"></span>
        <input class="dt-lesson__range" type="range" min="0" max="100" value="50"
               aria-label="Posizione del confronto prima/dopo">
      </div>`;

    // i due radio devono condividere lo stesso name
    const radios = root.querySelectorAll(".dt-lesson__ref input");
    radios.forEach((r) => (r.name = radios[0].name));

    const bar = root.querySelector(".dt-lesson__bar");
    const before = root.querySelector(".dt-lesson__before");
    const after = root.querySelector(".dt-lesson__after");
    const handle = root.querySelector(".dt-lesson__handle");
    const range = root.querySelector(".dt-lesson__range");
    const labL = root.querySelector(".dt-lesson__label--l");
    const labR = root.querySelector(".dt-lesson__label--r");

    steps.forEach((s, i) => {
      if (i === 0) return; // il passo 0 è il riferimento, non un traguardo
      const b = document.createElement("button");
      b.type = "button";
      b.className = "dt-lesson__step";
      b.setAttribute("role", "tab");
      b.textContent = `${i}. ${s.title}`;
      b.addEventListener("click", () => { current = i; render(); });
      bar.appendChild(b);
    });

    // precarica tutte le immagini: il cambio passo è istantaneo
    steps.forEach((s) => { const im = new Image(); im.src = s.img; });

    function setPos(v) {
      before.style.clipPath = `inset(0 ${100 - v}% 0 0)`;
      handle.style.left = `${v}%`;
    }

    function render() {
      const r = ref === "first" ? 0 : current - 1;
      before.src = steps[r].img;
      after.src = steps[current].img;
      before.alt = `Prima: ${steps[r].title}`;
      after.alt = `Dopo: ${steps[current].title}`;
      labL.textContent = `${r}. ${steps[r].title}`;
      labR.textContent = `${current}. ${steps[current].title}`;
      bar.querySelectorAll("button").forEach((b, i) => {
        const on = i + 1 === current;
        b.classList.toggle("is-active", on);
        b.setAttribute("aria-selected", on);
      });
    }

    range.addEventListener("input", () => setPos(+range.value));
    radios.forEach((r) => r.addEventListener("change", () => { ref = r.value; render(); }));
    setPos(50);
    render();
  }

  /* Esploratore di parametro (I.7):
   * <div class="dt-sweep" data-param="contrast" data-default="3"
   *      data-images='[{label,img},…]'> → cursore che scorre i render. */
  function buildSweep(root) {
    if (root.dataset.ready) return;
    let imgs;
    try { imgs = JSON.parse(root.dataset.images); } catch (e) { return; }
    if (!imgs || !imgs.length) return;
    root.dataset.ready = "1";
    const def = Math.min(+root.dataset.default || 0, imgs.length - 1);
    root.innerHTML = `
      <img class="dt-sweep__img" alt="">
      <div class="dt-sweep__ctrl">
        <span class="dt-sweep__value"></span>
        <input type="range" min="0" max="${imgs.length - 1}" step="1" value="${def}"
               aria-label="Valore di ${root.dataset.param || "parametro"}">
        <button type="button" class="dt-sweep__reset">default</button>
      </div>`;
    const img = root.querySelector(".dt-sweep__img");
    const val = root.querySelector(".dt-sweep__value");
    const range = root.querySelector("input");
    imgs.forEach((s) => { const im = new Image(); im.src = s.img; });
    function show(i) {
      img.src = imgs[i].img;
      img.alt = imgs[i].label;
      val.textContent = imgs[i].label + (i === def ? " (default)" : "");
    }
    range.addEventListener("input", () => show(+range.value));
    root.querySelector(".dt-sweep__reset").addEventListener("click", () => {
      range.value = def; show(def);
    });
    show(def);
  }

  function init() {
    document.querySelectorAll(".dt-lesson").forEach(build);
    document.querySelectorAll(".dt-sweep").forEach(buildSweep);
  }

  // Material "instant navigation": ricostruire a ogni cambio pagina
  if (typeof document$ !== "undefined") document$.subscribe(init);
  else document.addEventListener("DOMContentLoaded", init);
})();
