<!-- src/App.vue -->
<template>
  <div id="app">
    <h1>Contacts</h1>
    <ContactTable />
  </div>
</template>

<script>
import ContactTable from './components/ContactTable.vue'

export default {
  components: {
    ContactTable,
  },
}
</script>
