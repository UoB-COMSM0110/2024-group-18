document.addEventListener('DOMContentLoaded', function() {
    document.querySelectorAll("h1").forEach(function(h1) {
        if (h1.textContent === "Oiram") {
            h1.id = 'oiram';
        }
    });
});
