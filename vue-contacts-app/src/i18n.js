// filepath: c:\work\repos\contacts-demo\vue-contacts-app\src\i18n.js
import { createI18n } from 'vue-i18n'
import en from './locales/en.json'
import hr from './locales/hr.json'

const messages = {
  en,
  hr,
}

const i18n = createI18n({
  locale: 'hr', // Default locale
  fallbackLocale: 'en', // Fallback locale
  messages,
})

export default i18n
