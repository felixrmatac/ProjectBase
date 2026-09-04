import { describe, it, expect, vi } from 'vitest';
import { render, screen, fireEvent } from '@testing-library/svelte';
import StudySession from './StudySession.svelte';

describe('StudySession Component (Zen Flow & Svelte 5 Runes)', () => {
  const mockCards = [
    {
      id: 'card-1',
      question: '¿Qué es el Active Recall?',
      answer: 'Es la práctica de recuperar información de la memoria activamente.'
    },
    {
      id: 'card-2',
      question: '¿Qué es FSRS?',
      answer: 'Free Spaced Repetition Scheduler.'
    }
  ];

  it('renders ZenHeader with initial progress and question card', () => {
    render(StudySession, {
      props: {
        cards: mockCards,
        onComplete: vi.fn(),
        onReview: vi.fn()
      }
    });

    expect(screen.getByText('Pregunta 1 de 2')).toBeInTheDocument();
    expect(screen.getByText('¿Qué es el Active Recall?')).toBeInTheDocument();
  });

  it('shows solution and reveals rating buttons upon clicking reveal', async () => {
    render(StudySession, {
      props: {
        cards: mockCards,
        onComplete: vi.fn(),
        onReview: vi.fn()
      }
    });

    const revealBtn = screen.getByRole('button', { name: /mostrar respuesta/i });
    await fireEvent.click(revealBtn);

    expect(
      screen.getByText('Es la práctica de recuperar información de la memoria activamente.')
    ).toBeInTheDocument();
    expect(screen.getByText('Again')).toBeInTheDocument();
    expect(screen.getByText('Hard')).toBeInTheDocument();
    expect(screen.getByText('Good')).toBeInTheDocument();
    expect(screen.getByText('Easy')).toBeInTheDocument();
  });

  it('invokes onReview and advances to the next card when rating is clicked', async () => {
    const handleReview = vi.fn();
    render(StudySession, {
      props: {
        cards: mockCards,
        onComplete: vi.fn(),
        onReview: handleReview
      }
    });

    // Reveal answer
    const revealBtn = screen.getByRole('button', { name: /mostrar respuesta/i });
    await fireEvent.click(revealBtn);

    // Rate card as Good (3)
    const goodBtn = screen.getByRole('button', { name: /good/i });
    await fireEvent.click(goodBtn);

    expect(handleReview).toHaveBeenCalledWith(
      expect.objectContaining({
        card_id: 'card-1',
        rating: 3
      })
    );

    // Should transition to card 2
    expect(screen.getByText('Pregunta 2 de 2')).toBeInTheDocument();
    expect(screen.getByText('¿Qué es FSRS?')).toBeInTheDocument();
  });
});
