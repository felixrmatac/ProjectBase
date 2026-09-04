import { describe, it, expect } from 'vitest';
import { render, screen } from '@testing-library/svelte';
import { createRawSnippet } from 'svelte';
import StudyCard from './StudyCard.svelte';
import RatingButton from './RatingButton.svelte';
import ZenHeader from './ZenHeader.svelte';
import RecallInput from './RecallInput.svelte';

describe('StudyCard', () => {
  it('renders children content', () => {
    const children = createRawSnippet(() => ({
      render: () => `<p>Test content</p>`
    }));
    render(StudyCard, { props: { children } });
    expect(screen.getByText('Test content')).toBeInTheDocument();
  });

  it('applies custom class', () => {
    const { container } = render(StudyCard, { props: { class: 'custom-class' } });
    expect(container.firstChild).toHaveClass('custom-class');
  });
});

describe('RatingButton', () => {
  it('renders label and shortcut', () => {
    render(RatingButton, { props: { rating: 1, label: 'Again', shortcut: '1' } });
    expect(screen.getByText('Again')).toBeInTheDocument();
    expect(screen.getByText('[1]')).toBeInTheDocument();
  });

  it('applies correct color variant for rating 1', () => {
    const { container } = render(RatingButton, {
      props: { rating: 1, label: 'Again', shortcut: '1' }
    });
    expect(container.firstChild).toHaveClass('text-rose-400');
  });

  it('applies correct color variant for rating 4', () => {
    const { container } = render(RatingButton, {
      props: { rating: 4, label: 'Easy', shortcut: '4' }
    });
    expect(container.firstChild).toHaveClass('text-emerald-400');
  });
});

describe('ZenHeader', () => {
  it('renders progress text', () => {
    render(ZenHeader, { props: { current: 3, total: 10 } });
    expect(screen.getByText('Pregunta 3 de 10')).toBeInTheDocument();
  });

  it('calculates progress percentage correctly', () => {
    const { container } = render(ZenHeader, { props: { current: 5, total: 20 } });
    const progressBar = container.querySelector('[class*="bg-sky-400"]');
    expect(progressBar).toHaveStyle('width: 25%');
  });
});

describe('RecallInput', () => {
  it('renders textarea with placeholder', () => {
    render(RecallInput, { props: { placeholder: 'Custom placeholder' } });
    expect(screen.getByPlaceholderText('Custom placeholder')).toBeInTheDocument();
  });

  it('shows loading indicator when loading', () => {
    render(RecallInput, { props: { loading: true } });
    expect(screen.getByRole('textbox')).toBeInTheDocument();
  });

  it('shows keyboard shortcut hint', () => {
    render(RecallInput, {});
    expect(screen.getByText('Cmd/Ctrl + Enter')).toBeInTheDocument();
  });
});
