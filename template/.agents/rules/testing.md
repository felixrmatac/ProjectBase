# Protocolo de Testing

- **Frontend y Lógica**: Usa **Vitest** para testear el frontend y la lógica de negocio pura de la aplicación.
- **Base de datos (DB/RLS)**: Usa **pgTAP** para crear tests de la base de datos y de las políticas de RLS. Ubícalos en `supabase/tests/`.
- **Calidad**: Ninguna tarea se da por terminada con tests rotos o tipos de base de datos desincronizados.
