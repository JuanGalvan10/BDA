document.addEventListener("DOMContentLoaded", function () {
    const hamBurger = document.querySelector(".toggle-btn");
    const sidebar = document.querySelector("#sidebar");

    if (hamBurger && sidebar) {
        hamBurger.addEventListener("click", function () {
            sidebar.classList.toggle("expand");
        });
    } else {
        console.error("Elementos no encontrados: revisa las clases o IDs.");
    }
});