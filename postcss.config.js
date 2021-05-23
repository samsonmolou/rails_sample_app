const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  plugins: [
    require('tailwindcss')("./app/javascript/stylesheets/tailwind.config.js"),
    require('postcss-import'),
    require('postcss-flexbugs-fixes'),
    require('postcss-preset-env')({
      autoprefixer: {
        flexbox: 'no-2009'
      },
      stage: 3
    })
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans],
      },
    },
  },
}
