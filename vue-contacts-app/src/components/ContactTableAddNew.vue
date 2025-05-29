<template>
  <td>
    <input maxlength="100" v-model="name" class="form-control" :disabled="editIndex !== null" />
  </td>
  <td>
    <input maxlength="100" v-model="lastName" class="form-control" :disabled="editIndex !== null" />
  </td>
  <td>
    <input maxlength="254" v-model="email" class="form-control" :disabled="editIndex !== null" />
  </td>
  <td colspan="2"></td>
  <td>
    <button class="btn btn-sm btn-success" @click="addContact" :disabled="editIndex !== null">
      {{ $t('labels.add') }}
    </button>
  </td>
</template>

<script>
import { validateContact, sanitizeContact } from '@/contactUtils'
import { BASE_URL } from '@/config'

export default {
  data() {
    return {
      name: '',
      lastName: '',
      email: '',
    }
  },
  props: {
    editIndex: {
      type: Number,
      default: null,
    },
  },
  methods: {
    async addContact() {
      const newContact = { name: this.name, lastName: this.lastName, email: this.email }
      if (!validateContact(newContact, this.$t)) return

      const contact = sanitizeContact(newContact)
      const response = await fetch(`${BASE_URL}/api/contacts`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(contact),
      })

      if (response.ok) {
        // Reset fields after successful add
        this.name = ''
        this.lastName = ''
        this.email = ''

        this.$emit('add-contact')
      } else {
        console.error('Failed to add contact:', response.statusText)
      }
    },
  },
}
</script>
