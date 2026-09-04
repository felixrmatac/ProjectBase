<script lang="ts">
  let {
    value = $bindable(''),
    placeholder = 'Escribe tu respuesta...',
    disabled = false,
    loading = false
  }: {
    value?: string;
    placeholder?: string;
    disabled?: boolean;
    loading?: boolean;
  } = $props();

  function handleKeydown(e: KeyboardEvent) {
    if ((e.metaKey || e.ctrlKey) && e.key === 'Enter') {
      e.preventDefault();
    }
  }
</script>

<div class="relative">
  <textarea
    bind:value
    {placeholder}
    {disabled}
    onkeydown={handleKeydown}
    rows="4"
    class="w-full bg-slate-900/50 border border-slate-800/60 rounded-xl p-4 text-slate-200 placeholder:text-slate-500 focus:outline-none focus:border-sky-800/50 resize-none disabled:opacity-50 disabled:cursor-not-allowed"
  ></textarea>
  <div class="absolute bottom-3 right-3 flex items-center gap-2">
    {#if loading}
      <div class="w-4 h-4 border-2 border-sky-400/40 border-t-sky-400 rounded-full animate-spin"></div>
    {/if}
    <span class="text-xs text-slate-500 bg-slate-800/50 px-2 py-1 rounded">
      Cmd/Ctrl + Enter
    </span>
  </div>
</div>
