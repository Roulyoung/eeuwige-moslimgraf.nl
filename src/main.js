import './styles/main.css';

const toggle = document.querySelector('[data-nav-toggle]');
const navLinks = document.querySelector('.nav-links');

if (toggle && navLinks) {
  toggle.addEventListener('click', () => {
    navLinks.classList.toggle('open');
    toggle.setAttribute('aria-expanded', navLinks.classList.contains('open'));
  });
}

document.querySelectorAll('a[href^="#"]').forEach((anchor) => {
  anchor.addEventListener('click', (event) => {
    const targetId = anchor.getAttribute('href')?.substring(1);
    const target = targetId ? document.getElementById(targetId) : null;
    if (target) {
      event.preventDefault();
      target.scrollIntoView({ behavior: 'smooth', block: 'start' });
      if (navLinks?.classList.contains('open')) {
        navLinks.classList.remove('open');
        toggle?.setAttribute('aria-expanded', 'false');
      }
    }
  });
});
