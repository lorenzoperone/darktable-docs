(function () {
  function getScheme() {
    return document.documentElement.getAttribute("data-md-color-scheme");
  }

  function getMermaidConfig(scheme) {
    if (scheme === "slate") {
      return {
        theme: "dark",
        themeVariables: {
          fontFamily: "Inter, sans-serif",
          fontSize: "15px"
        }
      };
    }
    return {
      theme: "base",
      themeVariables: {
        primaryColor: "#fff3e0",
        primaryTextColor: "#212121",
        primaryBorderColor: "#e65100",
        lineColor: "#e65100",
        secondaryColor: "#fafafa",
        tertiaryColor: "#fff8f3",
        fontFamily: "Inter, sans-serif",
        fontSize: "15px"
      }
    };
  }

  function initMermaid() {
    if (typeof mermaid === "undefined") return;
    var config = getMermaidConfig(getScheme());
    mermaid.initialize(Object.assign(
      { startOnLoad: false, flowchart: { curve: "basis", htmlLabels: true } },
      config
    ));

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

  var observer = new MutationObserver(function () {
    var scheme = getScheme();
    if (scheme !== (window._lastMermaidScheme || null)) {
      window._lastMermaidScheme = scheme;
      if (typeof mermaid !== "undefined") {
        var config = getMermaidConfig(scheme);
        mermaid.initialize(Object.assign(
          { flowchart: { curve: "basis", htmlLabels: true } },
          config
        ));
        mermaid.run();
      }
    }
  });
  observer.observe(document.documentElement, {
    attributes: true,
    attributeFilter: ["data-md-color-scheme"]
  });
})();
