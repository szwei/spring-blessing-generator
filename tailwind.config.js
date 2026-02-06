/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{vue,js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        'spring-red': '#C41E3A',
        'spring-gold': '#FFD700',
        'spring-pink': '#FF69B4',
      },
    },
  },
  plugins: [],
}