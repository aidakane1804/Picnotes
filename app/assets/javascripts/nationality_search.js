document.addEventListener("DOMContentLoaded", function() {
    const searchInput = document.getElementById("nationalitySearch");
    const selectElement = document.getElementById("nationalitySelect");
  
    if (searchInput && selectElement) {
      searchInput.addEventListener("input", function() {
        const query = searchInput.value.toLowerCase();
        const options = selectElement.options;
  
        for (let i = 0; i < options.length; i++) {
          const option = options[i];
          const text = option.text.toLowerCase();
  
          option.style.display = text.includes(query) ? "block" : "none";
        }
      });
    }
  });
  