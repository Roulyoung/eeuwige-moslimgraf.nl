const { defineConfig } = require('vite');
const { resolve } = require('path');

module.exports = defineConfig({
  build: {
    rollupOptions: {
      input: {
        main: resolve(__dirname, 'index.html'),
        contact: resolve(__dirname, 'contact/index.html'),
        services: resolve(__dirname, 'services/index.html'),
        overOns: resolve(__dirname, 'over-ons/index.html'),
        nlHome: resolve(__dirname, 'nl/home-nl/index.html'),
        nlServices: resolve(__dirname, 'nl/servicesnl/index.html'),
        nlContact: resolve(__dirname, 'nl/contactnl/index.html'),
        nlOverons: resolve(__dirname, 'nl/overons-nl/index.html'),
        arabic: resolve(
          __dirname,
          '%d8%a8%d8%b4%d8%b1%d9%8a-%d9%84%d9%85%d8%b3%d9%84%d9%85%d9%8a-%d9%87%d9%88%d9%84%d9%86%d8%af%d8%a7/index.html'
        ),
      },
    },
  },
});
