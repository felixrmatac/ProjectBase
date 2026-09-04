export interface ReviewInput {
  card_id: string;
  rating: number;
  recall_answer?: string | null;
  current_interval?: number;
  current_ease?: number;
}

export type ValidationResult<T> =
  | { success: true; data: T }
  | { success: false; error: string };

/**
 * Validador de frontera en runtime para datos de repaso de estudio.
 * Cumple con .agents/rules/frontend.md (validación en frontera sin any ni @ts-ignore).
 */
export function validateReviewInput(input: unknown): ValidationResult<ReviewInput> {
  if (!input || typeof input !== 'object') {
    return { success: false, error: 'Input must be a valid object' };
  }

  const candidate = input as Record<string, unknown>;

  if (typeof candidate.card_id !== 'string' || candidate.card_id.trim().length === 0) {
    return { success: false, error: 'card_id must be a non-empty string' };
  }

  if (
    typeof candidate.rating !== 'number' ||
    !Number.isInteger(candidate.rating) ||
    candidate.rating < 1 ||
    candidate.rating > 4
  ) {
    return { success: false, error: 'rating must be an integer between 1 and 4' };
  }

  let recall_answer: string | null = null;
  if (typeof candidate.recall_answer === 'string') {
    recall_answer = candidate.recall_answer;
  } else if (candidate.recall_answer !== undefined && candidate.recall_answer !== null) {
    return { success: false, error: 'recall_answer must be a string or null' };
  }

  const current_interval =
    typeof candidate.current_interval === 'number' && candidate.current_interval > 0
      ? candidate.current_interval
      : 1;

  const current_ease =
    typeof candidate.current_ease === 'number' && candidate.current_ease >= 1.3
      ? candidate.current_ease
      : 2.5;

  return {
    success: true,
    data: {
      card_id: candidate.card_id.trim(),
      rating: candidate.rating,
      recall_answer,
      current_interval,
      current_ease
    }
  };
}
