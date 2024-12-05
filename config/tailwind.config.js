const defaultTheme = require("tailwindcss/defaultTheme");

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
      fontSize: {
        "xxs": "10px",
        "1xxs": "11px",
        "xmxs": "15px",
        "3.5xl":"32px",
        "3.8xl":"40px",
      },
      screens: {
        'sm': '640px',
        'md': '768px',
        'lg': '1024px',
        'xl': '1280px',
        '2xl': '1536px',
        '3xl': '1920px',
      },
      spacing: {
        '16.5': '4.5rem', 
      },
      colors: {
        primary: {"50":"#eff6ff","100":"#dbeafe","200":"#bfdbfe","300":"#93c5fd","400":"#60a5fa","500":"#3b82f6","600":"#2563eb","700":"#1d4ed8","800":"#1e40af","900":"#1e3a8a","950":"#172554"},
        darkBlue: "rgb(48, 44, 81)",
        lightGreen: "#6DC13D",
        moodyBlue: "#666099",
        lightGray: "#F5F5F5",
        deepGray: "#53545C",
        mutedIndigo: "#5a607a",
      },
      borderRadius: {
        '4xl': '20px',
      },
      fontFamily: {
        Paprika: ["Paprika", "sans-serif"],
        Outfit: ["Outfit", "sans-serif"],
      },
      width: {
        30: "30px",
        48: "192px",
      },
      height: {
        30: "30px",
      },
      backgroundImage: {
        "users-image": "url('/assets/users-image.svg')",
        "users-show": "url('/assets/users-show.svg')",
        'login-bg': "url('/assets/Shape.svg')",
      },
      screens: {
        ssm: "200px",
        mmd: "510px",
        xxl: "1440px",
        xxxl: "2560px",
      },
    },
  },
  plugins: [
    require("flowbite/plugin"),
    require("@tailwindcss/typography"),
    require("@tailwindcss/forms"),
    require("@tailwindcss/container-queries"),
    require('tailwind-scrollbar'),
    
  ],
};
