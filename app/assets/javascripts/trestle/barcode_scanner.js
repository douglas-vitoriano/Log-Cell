document.addEventListener("turbo:load", initBarcodeScanner);
document.addEventListener("DOMContentLoaded", initBarcodeScanner);

function initBarcodeScanner() {
  const toggleBtn = document.getElementById("toggle-camera-btn");
  const cameraDiv = document.getElementById("camera-preview");
  const searchInput = document.getElementById("product-search-input");
  const resultsDiv = document.getElementById("product-search-results");

  if (!toggleBtn || !searchInput) return;

  // ── Busca por texto/código ──────────────────────────────
  let searchTimeout;
  searchInput.addEventListener("input", () => {
    clearTimeout(searchTimeout);
    const q = searchInput.value.trim();
    if (q.length < 2) { resultsDiv.style.display = "none"; return; }

    searchTimeout = setTimeout(() => {
      fetch(`/admin/products.json?search=${encodeURIComponent(q)}`)
        .then(r => r.json())
        .then(products => renderResults(products))
        .catch(() => {});
    }, 300);
  });

  // ── Câmera / Quagga ────────────────────────────────────
  let cameraActive = false;

  toggleBtn.addEventListener("click", () => {
    cameraActive = !cameraActive;
    cameraDiv.style.display = cameraActive ? "block" : "none";
    toggleBtn.textContent = cameraActive ? "⛔ Parar câmera" : "📷 Câmera";

    if (cameraActive) startQuagga();
    else stopQuagga();
  });

  function startQuagga() {
    if (typeof Quagga === "undefined") {
      loadScript("https://cdnjs.cloudflare.com/ajax/libs/quagga/0.12.1/quagga.min.js", () => {
        initQuagga();
      });
    } else {
      initQuagga();
    }
  }

  function initQuagga() {
    Quagga.init({
      inputStream: {
        name: "Live",
        type: "LiveStream",
        target: document.querySelector("#interactive"),
        constraints: { facingMode: "environment" }
      },
      decoder: {
        readers: ["code_128_reader", "ean_reader", "ean_8_reader", "code_39_reader"]
      }
    }, err => {
      if (err) { console.error("Quagga init error:", err); return; }
      Quagga.start();
    });

    Quagga.onDetected(data => {
      const code = data.codeResult.code;
      searchInput.value = code;
      stopQuagga();
      cameraActive = false;
      cameraDiv.style.display = "none";
      toggleBtn.textContent = "📷 Câmera";

      // Busca o produto pelo barcode detectado
      fetch(`/admin/products.json?search=${encodeURIComponent(code)}`)
        .then(r => r.json())
        .then(products => {
          if (products.length === 1) addProductToSale(products[0]);
          else renderResults(products);
        });
    });
  }

  function stopQuagga() {
    if (typeof Quagga !== "undefined") {
      try { Quagga.stop(); } catch(e) {}
    }
  }

  // ── Renderiza resultados de busca ──────────────────────
  function renderResults(products) {
    if (!products || products.length === 0) {
      resultsDiv.innerHTML = '<p style="padding:10px; color:#999; margin:0;">Nenhum produto encontrado.</p>';
      resultsDiv.style.display = "block";
      return;
    }
    resultsDiv.innerHTML = products.map(p => `
      <div class="product-result-item"
           style="padding:10px 12px; cursor:pointer; border-bottom:1px solid #eee; display:flex; justify-content:space-between; align-items:center;"
           data-id="${p.id}" data-name="${p.name}" data-price="${p.price_cents}" data-code="${p.code}">
        <div>
          <strong>${p.name}</strong>
          <small style="color:#888; display:block;">${p.code} · Estoque: ${p.stock_quantity}</small>
        </div>
        <strong style="color:#2d7a2d;">R$ ${(p.price_cents / 100).toFixed(2).replace(".", ",")}</strong>
      </div>
    `).join("");
    resultsDiv.style.display = "block";

    resultsDiv.querySelectorAll(".product-result-item").forEach(item => {
      item.addEventListener("click", () => addProductToSale({
        id: item.dataset.id,
        name: item.dataset.name,
        price_cents: parseInt(item.dataset.price),
        code: item.dataset.code
      }));
    });
  }

  function addProductToSale(product) {
    resultsDiv.style.display = "none";
    searchInput.value = "";

    // Dispara um evento customizado que o Rails form pode ouvir
    document.dispatchEvent(new CustomEvent("product:selected", { detail: product }));

    // Feedback visual
    searchInput.placeholder = `✅ ${product.name} adicionado!`;
    setTimeout(() => {
      searchInput.placeholder = "Digite nome, código ou escaneie código de barras…";
    }, 2000);
  }

  function loadScript(src, callback) {
    const s = document.createElement("script");
    s.src = src;
    s.onload = callback;
    document.head.appendChild(s);
  }
}
