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
      colors: {
        darkBlue: "rgb(48, 44, 81)",
        lightGreen: "#6DC13D",
        moodyBlue: "#666099",
        lightGray: "#F5F5F5",
      },
      fontFamily: {
        Paprika: ["Paprika", "sans-serif"],
        Outfit: ["Outfit", "sans-serif"],
      },
      width: {
        30: "30px",
      },
      height: {
        30: "30px",
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
