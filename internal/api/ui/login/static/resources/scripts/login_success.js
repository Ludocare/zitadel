document.addEventListener('DOMContentLoaded', function () {
    autoSubmit();
});

function autoSubmit() {
    let form = document.getElementsByTagName('form')[0];
    if (form) {
        form.submit();
    }
}

const countdownElement = document.getElementById('countdown');
let timeLeft = 10;

const countdownInterval = setInterval(() => {
  countdownElement.textContent = timeLeft;
  timeLeft--;

  if (timeLeft < 0) {
    clearInterval(countdownInterval);
    countdownElement.textContent = "0";
  }
}, 1000);