<template>
  <div>
    <div class="filters mb-3">
      <input
        v-model="nameFilter"
        @input="onFilterChange"
        class="form-control d-inline-block w-auto me-2"
        placeholder="First Name Filter"
      />
      <input
        v-model="lastNameFilter"
        @input="onFilterChange"
        class="form-control d-inline-block w-auto"
        placeholder="Last Name Filter"
      />
    </div>

    <table class="table table-bordered">
      <thead>
        <tr>
          <th
            @click="editIndex === null && sortBy('Name')"
            :class="{ sortable: editIndex === null }"
          >
            Name <span v-if="sortColumn === 'Name'">{{ getSortIndicator() }}</span>
          </th>
          <th
            @click="editIndex === null && sortBy('LastName')"
            :class="{ sortable: editIndex === null }"
          >
            Last name <span v-if="sortColumn === 'LastName'">{{ getSortIndicator() }}</span>
          </th>
          <th
            @click="editIndex === null && sortBy('Email')"
            :class="{ sortable: editIndex === null }"
          >
            Email <span v-if="sortColumn === 'Email'">{{ getSortIndicator() }}</span>
          </th>
          <th
            @click="editIndex === null && sortBy('Created')"
            :class="{ sortable: editIndex === null }"
          >
            Created <span v-if="sortColumn === 'Created'">{{ getSortIndicator() }}</span>
          </th>
          <th
            @click="editIndex === null && sortBy('Modified')"
            :class="{ sortable: editIndex === null }"
          >
            Modified <span v-if="sortColumn === 'Modified'">{{ getSortIndicator() }}</span>
          </th>
          <th>Actions</th>
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
              Edit
            </button>
            <button
              v-if="editIndex === index"
              class="btn btn-sm btn-success me-1"
              @click="saveEdit(contact.id)"
            >
              Save
            </button>
            <button v-if="editIndex === index" class="btn btn-sm btn-secondary" @click="cancelEdit">
              Cancel
            </button>
            <button
              class="btn btn-sm btn-danger ms-1"
              @click="confirmDelete(contact.id)"
              :disabled="editIndex !== null"
            >
              Delete
            </button>
          </td>
        </tr>
      </tbody>
    </table>

    <div class="pagination d-flex justify-content-between align-items-center mt-3">
      <button
        :disabled="pageIndex === 0 || editIndex !== null"
        @click="goToPreviousPage"
        class="btn btn-primary"
      >
        Previous
      </button>
      <span> Page {{ pageIndex + 1 }} of {{ totalPages }} ({{ totalCount }} records) </span>
      <button
        :disabled="pageIndex + 1 >= totalPages || editIndex !== null"
        @click="goToNextPage"
        class="btn btn-primary"
      >
        Next
      </button>
    </div>
  </div>
</template>

<script>
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
        const response = await fetch(`https://localhost:7108/api/contacts/paged?${params}`)
        if (!response.ok) {
          throw new Error('Failed to fetch contacts')
        }
        const data = await response.json()
        this.contacts = data.items
        this.totalCount = data.totalCount
      } catch (error) {
        console.error('Fetch error:', error)
      }
    },
    onFilterChange() {
      this.pageIndex = 0 // reset page on filter change
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
      console.log(`sortBy called with column: ${column}`) // Debugging log
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
    async saveEdit(id) {
      try {
        const response = await fetch(`https://localhost:7108/api/contacts/${id}`, {
          method: 'PUT',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify(this.editContact),
        })
        if (!response.ok) throw new Error('Failed to update contact.')

        // Refresh list
        this.editIndex = null
        this.editContact = {}
        this.fetchContacts()
      } catch (err) {
        console.error(err)
      }
    },
    async deleteContact(id) {
      try {
        const confirmed = confirm('Are you sure you want to delete this contact?')
        if (!confirmed) return

        const response = await fetch(`https://localhost:7108/api/contacts/${id}`, {
          method: 'DELETE',
        })
        if (!response.ok) throw new Error('Failed to delete contact.')

        // Refresh list
        this.fetchContacts()
      } catch (err) {
        console.error(err)
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

<style scoped>
/* Removed custom CSS */
</style>
