<template>
  <td>
    <input v-if="editIndex === index" v-model="localName" class="form-control" />
    <span v-else>{{ name }}</span>
  </td>
  <td>
    <input v-if="editIndex === index" v-model="localLastName" class="form-control" />
    <span v-else>{{ lastName }}</span>
  </td>
  <td>
    <input v-if="editIndex === index" v-model="localEmail" class="form-control" />
    <span v-else>{{ email }}</span>
  </td>
  <td>{{ formatDate(created) }}</td>
  <td>{{ modified ? formatDate(modified) : '-' }}</td>
  <td>
    <button
      v-if="editIndex !== index"
      class="btn btn-sm btn-primary"
      @click="startEdit(index)"
      :disabled="editIndex !== null"
    >
      {{ $t('labels.edit') }}
    </button>
    <button v-if="editIndex === index" class="btn btn-sm btn-success me-1" @click="saveEdit">
      {{ $t('labels.save') }}
    </button>
    <button v-if="editIndex === index" class="btn btn-sm btn-secondary" @click="cancelEdit">
      {{ $t('labels.cancel') }}
    </button>
    <button
      class="btn btn-sm btn-danger ms-1"
      @click="confirmDelete"
      :disabled="editIndex !== null"
    >
      {{ $t('labels.delete') }}
    </button>
  </td>
</template>

<script>
import { validateContact, sanitizeContact } from '@/contactUtils'
import { BASE_URL } from '@/config'

export default {
  data() {
    return {
      localName: this.name,
      localLastName: this.lastName,
      localEmail: this.email,
    }
  },
  props: {
    id: { type: [String, Number], required: true },
    index: { type: Number, required: true },
    editIndex: { type: Number, default: null },
    name: { type: String, required: true },
    lastName: { type: String, required: true },
    email: { type: String },
    created: { type: String, required: true },
    modified: { type: String, default: null },
  },
  methods: {
    formatDate(dateString) {
      const date = new Date(dateString)
      return date.toLocaleDateString() + ' ' + date.toLocaleTimeString()
    },
    startEdit(index) {
      this.$emit('start-edit', index)
    },
    cancelEdit() {
      this.localName = this.name
      this.localLastName = this.lastName
      this.localEmail = this.email
      this.$emit('cancel-edit')
    },
    async saveEdit() {
      try {
        const updatedContact = sanitizeContact({
          id: this.id,
          name: this.localName,
          lastName: this.localLastName,
          email: this.localEmail,
        })
        if (!validateContact(updatedContact, this.$t)) return

        const response = await fetch(`${BASE_URL}/api/contacts/${this.id}`, {
          method: 'PUT',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify(updatedContact),
        })

        // Only try to parse JSON if response is NOT 204 ("No content")
        let data = null
        if (response.status !== 204) {
          try {
            data = await response.json()
          } catch (err) {
            console.warn('Response body is not valid JSON:', err)
          }
        }

        if (!response.ok) {
          if (data?.errors) {
            const messages = Object.values(data.errors).flat()
            alert(messages.join('\n'))
          } else {
            alert(this.$t('messages.unexpectedError'))
          }
          return
        }

        this.$emit('save-edit')
      } catch (err) {
        console.error('Save edit error:', err)
        alert(this.$t('messages.unexpectedError'))
      }
    },
    async deleteContact() {
      try {
        const confirmed = confirm(this.$t('messages.deleteConfirmation'))
        if (!confirmed) return

        const response = await fetch(`${BASE_URL}/api/contacts/${this.id}`, {
          method: 'DELETE',
        })
        if (!response.ok) throw new Error(this.$t('messages.unexpectedError'))

        this.$emit('confirm-delete')
      } catch (err) {
        console.error(err)
        alert(this.$t('messages.unexpectedError'))
      }
    },
    confirmDelete(id) {
      this.deleteContact(id)
    },
  },
}
</script>
