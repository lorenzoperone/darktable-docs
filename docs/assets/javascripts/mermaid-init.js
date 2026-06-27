(function () {
  function getTheme() {
    var scheme = document.documentElement.getAttribute("data-md-color-scheme");
    return scheme === "slate" ? "dark" : "default";
  }

  function initMermaid() {
    if (typeof mermaid === "undefined") return;
    mermaid.initialize({
      startOnLoad: false,
      theme: getTheme(),
      flowchart: { curve: "basis", htmlLabels: true },
      themeVariables: {
        fontFamily: "Inter, sans-serif"
      }
    });

    // Material custom fence outputs <pre class="mermaid"><code>...</code></pre>
    // Replace with <div class="mermaid"> containing unescaped text
    document.querySelectorAll("pre.mermaid").forEach(function (pre) {
      if (pre.dataset.mermaidReady) return;
      pre.dataset.mermaidReady = "true";

      var code = pre.querySelector("code");
      var text = code ? code.textContent : pre.textContent;

      var div = document.createElement("div");
      div.className = "mermaid";
      div.textContent = text;
      pre.replaceWith(div);
    });

    if (typeof mermaid.run === "function") {
      mermaid.run();
    }
  }

  document.addEventListener("DOMContentLoaded", initMermaid);

  // Re-render on theme toggle
  var observer = new MutationObserver(function () {
    var scheme = document.documentElement.getAttribute("data-md-color-scheme");
    if (scheme !== (window._lastMermaidScheme || null)) {
      window._lastMermaidScheme = scheme;
      // Re-init with new theme on next tick (after mermaid.js reloads aren't needed — 
      // just re-run with the new theme)
      if (typeof mermaid !== "undefined") {
        mermaid.initialize({
          theme: scheme === "slate" ? "dark" : "default",
          flowchart: { curve: "basis", htmlLabels: true },
          themeVariables: { fontFamily: "Inter, sans-serif" }
        });
        mermaid.run();
      }
    }
  });
  observer.observe(document.documentElement, {
    attributes: true,
    attributeFilter: ["data-md-color-scheme"]
  });
})();
