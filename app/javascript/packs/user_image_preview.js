document.addEventListener("DOMContentLoaded", () => {
  const fileInput = document.querySelector('#user_user_image');
  const preview = document.createElement('img');
  preview.style.maxHeight = '200px';
  preview.classList.add("img-thumbnail", "mt-2");

  if (fileInput) {
    fileInput.parentNode.appendChild(preview);

    fileInput.addEventListener('change', e => {
      const file = e.target.files[0];
      if (file) {
        const reader = new FileReader();
        reader.onload = e => {
          preview.src = e.target.result;
        };
        reader.readAsDataURL(file);
      } else {
        preview.src = "";
      }
    });
  }
});
