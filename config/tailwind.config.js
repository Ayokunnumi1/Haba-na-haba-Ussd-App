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
      backgroundImage: {
        'login-bg': "url('/assets/Shape.svg')",
      },
      colors: {
        darkBlue: "#302C51",
        lightGreen: "#6DC13D",
        moodyBlue: "#666099",
        lightGray: "#F5F5F5",
      },
      fontFamily: {
        Paprika: ["Paprika", "sans-serif"],
        Outfit: ["Outfit", "sans-serif"],
      },
    },
  },
  plugins: [
    require("@tailwindcss/forms"),
    require("@tailwindcss/typography"),
    require("@tailwindcss/container-queries"),
    require("flowbite/plugin"),
  ],
};
