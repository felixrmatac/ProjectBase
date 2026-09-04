<script lang="ts">
  import type { Snippet } from 'svelte';

  let { children, class: className = '' }: { children?: Snippet; class?: string } = $props();
</script>

<div class="bg-slate-900/90 border border-slate-800/60 rounded-2xl p-6 {className}">
  {#if children}
    {@render children()}
  {/if}
</div>
