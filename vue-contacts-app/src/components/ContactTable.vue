<template>
  <div>
    <div class="filters mb-3">
      <input
        v-model="nameFilter"
        @input="onFilterChange"
        class="form-control d-inline-block w-auto me-2"
        :placeholder="$t('labels.firstNameFilter')"
      />
      <input
        v-model="lastNameFilter"
        @input="onFilterChange"
        class="form-control d-inline-block w-auto"
        :placeholder="$t('labels.lastNameFilter')"
      />
    </div>

    <table class="table table-bordered">
      <thead>
        <tr>
          <th
            @click="editIndex === null && sortBy('Name')"
            :class="{ sortable: editIndex === null }"
          >
            {{ $t('labels.name') }}
            <span v-if="sortColumn === 'Name'">{{ getSortIndicator() }}</span>
          </th>
          <th
            @click="editIndex === null && sortBy('LastName')"
            :class="{ sortable: editIndex === null }"
          >
            {{ $t('labels.lastName') }}
            <span v-if="sortColumn === 'LastName'">{{ getSortIndicator() }}</span>
          </th>
          <th
            @click="editIndex === null && sortBy('Email')"
            :class="{ sortable: editIndex === null }"
          >
            {{ $t('labels.email') }}
            <span v-if="sortColumn === 'Email'">{{ getSortIndicator() }}</span>
          </th>
          <th
            @click="editIndex === null && sortBy('Created')"
            :class="{ sortable: editIndex === null }"
          >
            {{ $t('labels.created') }}
            <span v-if="sortColumn === 'Created'">{{ getSortIndicator() }}</span>
          </th>
          <th
            @click="editIndex === null && sortBy('Modified')"
            :class="{ sortable: editIndex === null }"
          >
            {{ $t('labels.modified') }}
            <span v-if="sortColumn === 'Modified'">{{ getSortIndicator() }}</span>
          </th>
          <th>{{ $t('labels.actions') }}</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="(contact, index) in contacts" :key="contact.id">
          <td>
            <input v-if="editIndex === index" v-model="editContact.name" class="form-control" />
            <span v-else>{{ contact.name }}</span>
          </td>
          <td>
            <input v-if="editIndex === index" v-model="editContact.lastName" class="form-control" />
            <span v-else>{{ contact.lastName }}</span>
          </td>
          <td>
            <input v-if="editIndex === index" v-model="editContact.email" class="form-control" />
            <span v-else>{{ contact.email }}</span>
          </td>
          <td>{{ formatDate(contact.created) }}</td>
          <td>{{ contact.modified ? formatDate(contact.modified) : '-' }}</td>
          <td>
            <button
              v-if="editIndex !== index"
              class="btn btn-sm btn-primary"
              @click="startEdit(index)"
              :disabled="editIndex !== null"
            >
              {{ $t('labels.edit') }}
            </button>
            <button
              v-if="editIndex === index"
              class="btn btn-sm btn-success me-1"
              @click="saveEdit(contact.id)"
            >
              {{ $t('labels.save') }}
            </button>
            <button v-if="editIndex === index" class="btn btn-sm btn-secondary" @click="cancelEdit">
              {{ $t('labels.cancel') }}
            </button>
            <button
              class="btn btn-sm btn-danger ms-1"
              @click="confirmDelete(contact.id)"
              :disabled="editIndex !== null"
            >
              {{ $t('labels.delete') }}
            </button>
          </td>
        </tr>
        <tr>
          <ContactTableAddNew :editIndex="editIndex" @add-contact="addContactEmitted" />
        </tr>
      </tbody>
    </table>

    <div class="pagination d-flex justify-content-between align-items-center mt-3">
      <button
        :disabled="pageIndex === 0 || editIndex !== null"
        @click="goToPreviousPage"
        class="btn btn-primary"
      >
        {{ $t('labels.previous') }}
      </button>
      <span>
        {{ this.$t('messages.page') }} {{ pageIndex + 1 }} / {{ totalPages }} ({{ totalCount }}
        {{ this.$t('messages.records') }})
      </span>
      <button
        :disabled="pageIndex + 1 >= totalPages || editIndex !== null"
        @click="goToNextPage"
        class="btn btn-primary"
      >
        {{ $t('labels.next') }}
      </button>
    </div>
  </div>
</template>

<script>
import ContactTableAddNew from './ContactTableAddNew.vue'
import { validateContact, sanitizeContact } from '@/contactUtils'
import { BASE_URL } from '@/config'

export default {
  data() {
    return {
      contacts: [],
      totalCount: 0,
      pageIndex: 0,
      pageSize: 3,
      nameFilter: '',
      lastNameFilter: '',
      sortColumn: 'LastName',
      sortDirection: 'ASC',
      editIndex: null,
      editContact: {
        name: '',
        lastName: '',
        email: '',
      },
    }
  },
  components: {
    ContactTableAddNew,
  },
  computed: {
    totalPages() {
      return Math.ceil(this.totalCount / this.pageSize)
    },
  },
  methods: {
    async fetchContacts() {
      const params = new URLSearchParams({
        pageIndex: this.pageIndex,
        pageSize: this.pageSize,
        nameFilter: this.nameFilter || '',
        lastNameFilter: this.lastNameFilter || '',
        sortColumn: this.sortColumn,
        sortDirection: this.sortDirection,
      })

      try {
        const response = await fetch(`${BASE_URL}/api/contacts/paged?${params}`)
        const data = await response.json()

        if (!response.ok) throw new Error('Failed to retrieve contacts.')

        this.contacts = data.items
        this.totalCount = data.totalCount
      } catch (error) {
        console.error('Error:', error)
      }
    },
    onFilterChange() {
      this.pageIndex = 0
      this.fetchContacts()
    },
    formatDate(dateString) {
      const date = new Date(dateString)
      return date.toLocaleDateString() + ' ' + date.toLocaleTimeString()
    },
    goToPreviousPage() {
      this.pageIndex--
      this.fetchContacts()
    },
    goToNextPage() {
      this.pageIndex++
      this.fetchContacts()
    },
    sortBy(column) {
      if (this.sortColumn === column) {
        this.sortDirection = this.sortDirection === 'ASC' ? 'DESC' : 'ASC'
      } else {
        this.sortColumn = column
        this.sortDirection = 'ASC'
      }
      this.pageIndex = 0
      this.fetchContacts()
    },
    getSortIndicator() {
      return this.sortDirection === 'ASC' ? '↑' : '↓'
    },
    startEdit(index) {
      this.editIndex = index
      this.editContact = { ...this.contacts[index] }
    },
    cancelEdit() {
      this.editIndex = null
      this.editContact = {}
    },
    async addContactEmitted() {
      try {
        this.newContact = {}

        // Refresh list
        this.fetchContacts()
      } catch (err) {
        console.error('Add contact error:', err)
        alert(this.$t('messages.unexpectedError'))
      }
    },
    async saveEdit(id) {
      try {
        if (!validateContact(this.editContact)) return

        let contact = sanitizeContact(this.editContact)
        const response = await fetch(`${BASE_URL}/api/contacts/${id}`, {
          method: 'PUT',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify(contact),
        })

        // Only try to parse JSON if response is NOT 204
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
          } else if (typeof data === 'string') {
            alert(data) // Handle string error message like "Contact ID mismatch."
          } else {
            alert(this.$t('messages.unexpectedError'))
          }
          return
        }

        // Success — no content returned, so proceed
        this.editIndex = null
        this.editContact = {}
        this.fetchContacts()
      } catch (err) {
        console.error('Save edit error:', err)
        alert(this.$t('messages.unexpectedError'))
      }
    },
    async deleteContact(id) {
      try {
        const confirmed = confirm(this.$t('messages.deleteConfirmation'))
        if (!confirmed) return

        const response = await fetch(`${BASE_URL}/api/contacts/${id}`, {
          method: 'DELETE',
        })
        if (!response.ok) throw new Error(this.$t('messages.unexpectedError'))

        // Refresh list
        this.fetchContacts()
      } catch (err) {
        console.error(err)
        alert(this.$t('messages.unexpectedError'))
      }
    },
    confirmDelete(id) {
      this.deleteContact(id)
    },
  },
  mounted() {
    this.fetchContacts()
  },
}
</script>
