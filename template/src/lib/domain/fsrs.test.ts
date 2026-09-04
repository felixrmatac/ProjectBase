import { describe, it, expect } from 'vitest';
import { calculateNextReview } from './fsrs';
import { validateReviewInput } from './review-schema';

describe('FSRS Spaced Repetition Domain Logic (Pure Logic)', () => {
  describe('calculateNextReview', () => {
    it('should reset interval to 1 day and lower ease factor when rating is 1 (Again)', () => {
      const result = calculateNextReview({
        rating: 1,
        currentInterval: 10,
        currentEase: 2.5
      });

      expect(result.nextIntervalDays).toBe(1);
      expect(result.nextEaseFactor).toBeLessThan(2.5);
      expect(result.nextEaseFactor).toBeGreaterThanOrEqual(1.3);
    });

    it('should increase interval moderately when rating is 2 (Hard)', () => {
      const result = calculateNextReview({
        rating: 2,
        currentInterval: 5,
        currentEase: 2.5
      });

      expect(result.nextIntervalDays).toBe(6); // 5 * 1.2 = 6
      expect(result.nextEaseFactor).toBeLessThan(2.5);
    });

    it('should multiply interval by ease factor when rating is 3 (Good)', () => {
      const result = calculateNextReview({
        rating: 3,
        currentInterval: 4,
        currentEase: 2.5
      });

      expect(result.nextIntervalDays).toBe(10); // 4 * 2.5 = 10
      expect(result.nextEaseFactor).toBe(2.5);
    });

    it('should multiply interval by ease factor and bonus when rating is 4 (Easy)', () => {
      const result = calculateNextReview({
        rating: 4,
        currentInterval: 4,
        currentEase: 2.5
      });

      expect(result.nextIntervalDays).toBe(13); // Math.round(4 * 2.5 * 1.3) = 13
      expect(result.nextEaseFactor).toBeGreaterThan(2.5);
    });

    it('should not allow ease factor to drop below minimum threshold 1.3', () => {
      const result = calculateNextReview({
        rating: 1,
        currentInterval: 1,
        currentEase: 1.35
      });

      expect(result.nextEaseFactor).toBe(1.3);
    });

    it('should calculate accurate nextReviewDate based on nextIntervalDays', () => {
      const now = new Date('2026-09-04T12:00:00Z');
      const result = calculateNextReview(
        {
          rating: 3,
          currentInterval: 2,
          currentEase: 2.5
        },
        now
      );

      // 2 * 2.5 = 5 days -> 2026-09-09
      expect(result.nextIntervalDays).toBe(5);
      expect(result.nextReviewDate.toISOString().slice(0, 10)).toBe('2026-09-09');
    });
  });

  describe('validateReviewInput (Runtime Schema Validation)', () => {
    it('should validate and parse valid review input', () => {
      const valid = {
        card_id: 'card-123',
        rating: 3,
        recall_answer: 'My recalled definition'
      };

      const parsed = validateReviewInput(valid);
      expect(parsed.success).toBe(true);
      if (parsed.success) {
        expect(parsed.data.card_id).toBe('card-123');
        expect(parsed.data.rating).toBe(3);
      }
    });

    it('should reject invalid ratings below 1 or above 4', () => {
      const invalidLow = { card_id: 'card-1', rating: 0 };
      const invalidHigh = { card_id: 'card-1', rating: 5 };

      expect(validateReviewInput(invalidLow).success).toBe(false);
      expect(validateReviewInput(invalidHigh).success).toBe(false);
    });

    it('should reject empty card_id', () => {
      const invalidEmpty = { card_id: '   ', rating: 2 };
      expect(validateReviewInput(invalidEmpty).success).toBe(false);
    });
  });
});
