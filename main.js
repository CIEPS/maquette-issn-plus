const addListenerForModal = function (fieldName) {
  document.querySelectorAll(`a.button.${fieldName}`).forEach(element => {
    element.addEventListener('click', function (event) {
      event.preventDefault();
      const modal = document.querySelector(`.modal.${fieldName}`);
      const html = document.querySelector('html');
      modal.classList.add('is-active');
      html.classList.add('is-clipped');
      const closeModal = (event) => {
        event.preventDefault();
        modal.classList.remove('is-active');
        html.classList.remove('is-clipped');
      };

      modal.querySelector(`.modal.${fieldName} .modal-background`).addEventListener('click', closeModal);
      modal.querySelector(`.modal.${fieldName} .delete`).addEventListener('click', closeModal);
      modal.querySelector(`.modal.${fieldName} .button.is-danger`).addEventListener('click', closeModal);
    });
  });
};
addListenerForModal('field-008');