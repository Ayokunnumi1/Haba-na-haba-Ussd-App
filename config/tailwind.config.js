const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    "./public/*.html",
    "./app/helpers/**/*.rb",
    "./app/javascript/**/*.js",
    "./app/views/**/*.{erb,haml,html,slim}",
    "./node_modules/flowbite/**/*.js",
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ["Inter var", ...defaultTheme.fontFamily.sans],
      },
      fontSize: {},
      colors: {
        darkBlue: "#302C51",
        lightGreen: "#6DC13D",
      },
      fontFamily: {
        Paprika: ["Paprika", "sans-serif"],
        Roboto: ["Roboto, sans-serif"],
      },
    },
  },
  plugins: [
    require("flowbite/plugin"),
    require("@tailwindcss/forms"),
    require("@tailwindcss/typography"),
    require("@tailwindcss/container-queries"),
  ],
};
