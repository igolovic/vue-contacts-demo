export function sanitizeContact(contact) {
  return {
    ...contact,
    email: contact.email?.trim() === '' ? null : contact.email,
  }
}

export function validateContact(contact, t) {
  const { name, lastName, email } = contact
  const messages = []

  if (!name) messages.push(t('messages.nameRequired'))
  if (!lastName) messages.push(t('messages.lastNameRequired'))
  if (email && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
    messages.push(t('messages.invalidEmail'))
  }

  if (messages.length > 0) {
    alert(messages.join('\n'))
    return false
  }
  return true
}
