<!-- src/App.vue -->
<template>
  <div id="app">
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
