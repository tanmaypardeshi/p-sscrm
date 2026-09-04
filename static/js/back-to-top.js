(function () {
  var btn = document.getElementById("back-to-top");
  if (!btn) return;

  function toggle() {
    btn.classList.toggle("is-visible", window.scrollY > 400);
  }

  window.addEventListener("scroll", toggle, { passive: true });
  btn.addEventListener("click", function () {
    window.scrollTo({ top: 0, behavior: "smooth" });
  });
  toggle();
})();
