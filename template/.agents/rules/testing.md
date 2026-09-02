---
id: testing
version: 1.0.0
enforcement: machine-enforced (via Vitest and pgTAP)
---

# Reglas de Testing

- **Frontend y Lógica**: El framework oficial para testear componentes y lógica de negocio es **Vitest**.
- **Base de datos (DB/RLS)**: Las políticas de Row Level Security (RLS) y lógica de base de datos se testean exclusivamente con **pgTAP** en `supabase/tests/`.
