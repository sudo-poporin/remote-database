/// Resuelve la key efectiva a usar en `Supabase.initialize`.
///
/// Lanza [ArgumentError] si no se provee.
String resolveSupabaseKey({
  String? publishableKey,
}) {
  if (publishableKey == null) {
    throw ArgumentError(
      'Se debe proveer una key: publishableKey/supabasePublishableKey.',
    );
  }
  return publishableKey;
}
