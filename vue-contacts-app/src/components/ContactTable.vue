<template>
  <div>
    <div class="filters mb-3">
      <input
        v-model="nameFilter"
        @input="onFilterChange"
        class="form-control d-inline-block w-auto me-2"
        :placeholder="$t('labels.firstNameFilter')"
        :disabled="editIndex !== null"
      />
      <input
        v-model="lastNameFilter"
        @input="onFilterChange"
        class="form-control d-inline-block w-auto"
        :placeholder="$t('labels.lastNameFilter')"
        :disabled="editIndex !== null"
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
          <ContactEdit
            :id="contact.id"
            :name="contact.name"
            :last-name="contact.lastName"
            :email="contact.email"
            :created="contact.created"
            :modified="contact.modified"
            :edit-index="editIndex"
            :index="index"
            @start-edit="startEditEmitted(index)"
            @save-edit="saveEditEmitted"
            @cancel-edit="cancelContactEmitted"
            @confirm-delete="deleteContactEmitted"
          />
        </tr>
        <tr>
          <ContactTableAddNew :editIndex="editIndex" @add-contact="addContactEmitted" />
        </tr>
      </tbody>
    </table>

    <ContactPagination
      :pageIndex="pageIndex"
      :totalPages="totalPages"
      :totalCount="totalCount"
      :editIndex="editIndex"
      @go-to-previous-page="goToPreviousPage"
      @go-to-next-page="goToNextPage"
    />
  </div>
</template>

<script>
import { BASE_URL } from '@/config'
import ContactTableAddNew from './ContactTableAddNew.vue'
import ContactPagination from './ContactPagination.vue'
import ContactEdit from './ContactEdit.vue'

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
    ContactPagination,
    ContactEdit,
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
    async startEditEmitted(index) {
      this.editIndex = index
    },
    async cancelContactEmitted() {
      this.editIndex = null
    },
    async saveEditEmitted() {
      this.editIndex = null
      this.fetchContacts()
    },
    async deleteContactEmitted() {
      this.fetchContacts()
    },
  },
  mounted() {
    this.fetchContacts()
  },
}
</script>
