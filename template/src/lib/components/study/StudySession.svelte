<script lang="ts">
  import ZenHeader from '../ui/ZenHeader.svelte';
  import StudyCard from '../ui/StudyCard.svelte';
  import RecallInput from '../ui/RecallInput.svelte';
  import RatingButton from '../ui/RatingButton.svelte';

  export interface StudyCardItem {
    id: string;
    question: string;
    answer: string;
    ease_factor?: number;
    interval_days?: number;
  }

  export interface ReviewPayload {
    card_id: string;
    rating: 1 | 2 | 3 | 4;
    recall_answer?: string;
  }

  let {
    cards = [],
    onReview,
    onComplete
  }: {
    cards: StudyCardItem[];
    onReview?: (review: ReviewPayload) => void;
    onComplete?: () => void;
  } = $props();

  let currentIndex = $state(0);
  let showAnswer = $state(false);
  let recallText = $state('');
  let isSubmitting = $state(false);

  const currentCard = $derived(cards[currentIndex] ?? null);
  const isFinished = $derived(cards.length === 0 || currentIndex >= cards.length);
  const totalCards = $derived(cards.length);

  function revealSolution() {
    if (!showAnswer) {
      showAnswer = true;
    }
  }

  function handleRate(rating: 1 | 2 | 3 | 4) {
    if (!currentCard || isSubmitting) return;

    isSubmitting = true;

    if (onReview) {
      onReview({
        card_id: currentCard.id,
        rating,
        recall_answer: recallText.trim() ? recallText.trim() : undefined
      });
    }

    const nextIndex = currentIndex + 1;
    if (nextIndex >= cards.length) {
      if (onComplete) onComplete();
    }

    currentIndex = nextIndex;
    showAnswer = false;
    recallText = '';
    isSubmitting = false;
  }

  function handleKeydown(event: KeyboardEvent) {
    // Si la respuesta no se ha revelado y se pulsa Espacio fuera del textarea
    if (!showAnswer && event.code === 'Space' && (event.target as HTMLElement)?.tagName !== 'TEXTAREA') {
      event.preventDefault();
      revealSolution();
      return;
    }

    // Atajos 1-4 para calificar cuando la respuesta es visible
    if (showAnswer) {
      if (event.key === '1') handleRate(1);
      else if (event.key === '2') handleRate(2);
      else if (event.key === '3') handleRate(3);
      else if (event.key === '4') handleRate(4);
    }
  }
</script>

<svelte:window onkeydown={handleKeydown} />

<div class="min-h-screen bg-slate-950 text-slate-100 flex flex-col items-center justify-center p-6 selection:bg-sky-500/30">
  <div class="w-full max-w-xl">
    {#if isFinished}
      <StudyCard class="text-center py-12">
        <h2 class="text-2xl font-medium text-emerald-400 mb-2">¡Sesión Completada!</h2>
        <p class="text-sm text-slate-400">Has repasado todas las tarjetas del ciclo activo de hoy.</p>
      </StudyCard>
    {:else if currentCard}
      <ZenHeader current={currentIndex + 1} total={totalCards} />

      <StudyCard class="mb-6 space-y-6">
        <div>
          <span class="text-xs uppercase tracking-wider text-slate-500 font-semibold block mb-2">
            Pregunta de Evocación
          </span>
          <p class="text-lg text-slate-100 font-medium leading-relaxed">
            {currentCard.question}
          </p>
        </div>

        {#if !showAnswer}
          <div class="space-y-4">
            <RecallInput
              bind:value={recallText}
              placeholder="Escribe lo que recuerdes antes de comprobar..."
              loading={isSubmitting}
            />

            <button
              type="button"
              onclick={revealSolution}
              class="w-full py-3 bg-slate-800 hover:bg-slate-700/80 text-slate-200 rounded-xl text-sm font-medium transition-colors flex items-center justify-center gap-2 border border-slate-700/50"
            >
              <span>Mostrar Respuesta</span>
              <span class="text-xs text-slate-400 bg-slate-900/60 px-2 py-0.5 rounded border border-slate-800">
                [Espacio]
              </span>
            </button>
          </div>
        {:else}
          <div class="pt-4 border-t border-slate-800/80 space-y-4 animate-fadeIn">
            <div>
              <span class="text-xs uppercase tracking-wider text-sky-400/80 font-semibold block mb-2">
                Respuesta Correcta
              </span>
              <p class="text-slate-200 leading-relaxed bg-slate-950/40 p-4 rounded-xl border border-slate-800/40">
                {currentCard.answer}
              </p>
            </div>

            <div>
              <span class="text-xs uppercase tracking-wider text-slate-400 block mb-3 text-center">
                Califica tu esfuerzo de recuerdo (FSRS)
              </span>
              <div class="grid grid-cols-2 sm:grid-cols-4 gap-2">
                <RatingButton rating={1} label="Again" shortcut="1" onclick={() => handleRate(1)} />
                <RatingButton rating={2} label="Hard" shortcut="2" onclick={() => handleRate(2)} />
                <RatingButton rating={3} label="Good" shortcut="3" onclick={() => handleRate(3)} />
                <RatingButton rating={4} label="Easy" shortcut="4" onclick={() => handleRate(4)} />
              </div>
            </div>
          </div>
        {/if}
      </StudyCard>
    {/if}
  </div>
</div>
