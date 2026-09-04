export interface NextReviewResult {
  nextIntervalDays: number;
  nextEaseFactor: number;
  nextReviewDate: Date;
}

export interface FSRSParams {
  rating: number;
  currentInterval?: number;
  currentEase?: number;
}

const MIN_EASE_FACTOR = 1.3;

/**
 * Lógica pura de cálculo de intervalos FSRS / SM-2 de repetición espaciada.
 * Aislada completamente de la capa de interfaz y base de datos (según .agents/rules/frontend.md).
 */
export function calculateNextReview(
  params: FSRSParams,
  referenceDate: Date = new Date()
): NextReviewResult {
  const { rating, currentInterval = 1, currentEase = 2.5 } = params;

  let nextIntervalDays: number;
  let nextEaseFactor = currentEase;

  switch (rating) {
    case 1: // Again: Reinicio a 1 día y reducción de facilidad
      nextIntervalDays = 1;
      nextEaseFactor = Math.max(MIN_EASE_FACTOR, currentEase - 0.2);
      break;

    case 2: // Hard: Incremento moderado
      nextIntervalDays = Math.max(1, Math.round(currentInterval * 1.2));
      nextEaseFactor = Math.max(MIN_EASE_FACTOR, currentEase - 0.15);
      break;

    case 3: // Good: Multiplicación por facilidad
      nextIntervalDays = Math.max(1, Math.round(currentInterval * currentEase));
      break;

    case 4: // Easy: Bonificación adicional e incremento de facilidad
      nextIntervalDays = Math.max(1, Math.round(currentInterval * currentEase * 1.3));
      nextEaseFactor = currentEase + 0.15;
      break;

    default:
      throw new Error(`Rating inválido: ${rating}. Debe estar entre 1 y 4.`);
  }

  // Precisión a dos decimales y respeto de cota mínima
  nextEaseFactor = Math.max(MIN_EASE_FACTOR, Math.round(nextEaseFactor * 100) / 100);

  const nextReviewDate = new Date(referenceDate);
  nextReviewDate.setDate(nextReviewDate.getDate() + nextIntervalDays);

  return {
    nextIntervalDays,
    nextEaseFactor,
    nextReviewDate
  };
}
