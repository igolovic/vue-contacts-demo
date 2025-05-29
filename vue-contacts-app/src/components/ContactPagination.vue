<template>
  <div class="pagination d-flex justify-content-between align-items-center mt-3">
    <button
      :disabled="pageIndex === 0 || editIndex !== null"
      @click="$emit('go-to-previous-page')"
      class="btn btn-primary"
    >
      {{ $t('labels.previous') }}
    </button>
    <span>
      {{ $t('messages.page') }} {{ pageIndex + 1 }} / {{ totalPages }} ({{ totalCount }}
      {{ $t('messages.records') }})
    </span>
    <button
      :disabled="pageIndex + 1 >= totalPages || editIndex !== null"
      @click="$emit('go-to-next-page')"
      class="btn btn-primary"
    >
      {{ $t('labels.next') }}
    </button>
  </div>
</template>

<script>
export default {
  props: {
    pageIndex: {
      type: Number,
      required: true,
    },
    totalPages: {
      type: Number,
      required: true,
    },
    totalCount: {
      type: Number,
      required: true,
    },
    editIndex: {
      type: Number,
      default: null,
    },
  },
}
</script>
