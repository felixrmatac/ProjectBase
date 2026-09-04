<script lang="ts">
  type Rating = 1 | 2 | 3 | 4;

  let {
    rating,
    label,
    shortcut,
    onclick
  }: {
    rating: Rating;
    label: string;
    shortcut: string;
    onclick?: () => void;
  } = $props();

  const ratingStyles: Record<Rating, string> = {
    1: 'text-rose-400 bg-rose-950/40 border-rose-800/50 hover:bg-rose-900/60',
    2: 'text-amber-400 bg-amber-950/40 border-amber-800/50 hover:bg-amber-900/60',
    3: 'text-sky-400 bg-sky-950/40 border-sky-800/50 hover:bg-sky-900/60',
    4: 'text-emerald-400 bg-emerald-950/40 border-emerald-800/50 hover:bg-emerald-900/60'
  };
</script>

<button
  class="inline-flex items-center gap-2 px-4 py-2 border rounded-xl transition-colors {ratingStyles[rating]}"
  {onclick}
>
  <span class="text-sm font-medium">{label}</span>
  <span class="text-xs opacity-60 bg-black/20 px-1.5 py-0.5 rounded">[{shortcut}]</span>
</button>
