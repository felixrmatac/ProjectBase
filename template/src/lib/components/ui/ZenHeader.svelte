<script lang="ts">
  let { current, total }: { current: number; total: number } = $props();

  const progress = $derived(total > 0 ? (current / total) * 100 : 0);
</script>

<header class="flex items-center justify-between mb-6">
  <span class="text-sm text-slate-400">
    Pregunta {current} de {total}
  </span>
  <div class="w-32 h-1 bg-slate-800 rounded-full overflow-hidden">
    <div
      class="h-full bg-sky-400/60 rounded-full transition-all duration-300"
      style="width: {progress}%"
    ></div>
  </div>
</header>
