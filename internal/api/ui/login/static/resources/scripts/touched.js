let inputs = document.getElementsByTagName("input");

if (inputs?.length) {
  for (let input of inputs) {
    if (input.getAttribute("autocomplete") === "one-time-code") continue; // Skip inputs with autocomplete="one-time-code"

    input.addEventListener("focus", () => {
      input.classList.add("lgn-focused");
    });

    input.addEventListener("blur", () => {
      input.classList.add("lgn-touched");
      input.classList.remove("lgn-focused");
    });
  }
}

const input = document.querySelector('[autocomplete=one-time-code');
input.addEventListener('input', () => input.style.setProperty('--_otp-digit', input.selectionStart));