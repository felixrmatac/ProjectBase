/**
 * ⚠️ INITIALIZATION REQUIRED
 *
 * Ejecuta ./scripts/generate-db-types.sh tras iniciar Supabase
 * para generar este archivo automáticamente.
 */
export type Database = {
  public: {
    Tables: {};
    Views: {};
    Functions: {};
    Enums: {};
    CompositeTypes: {};
  };
};
