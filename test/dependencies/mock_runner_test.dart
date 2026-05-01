import 'package:mockito/annotations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@GenerateNiceMocks([
  MockSpec<SupabaseClient>(),
  MockSpec<GoTrueClient>(),
  MockSpec<SupabaseStorageClient>(),
  MockSpec<StorageFileApi>(),
  MockSpec<SupabaseQueryBuilder>(),
  MockSpec<PostgrestFilterBuilder<List<Map<String, dynamic>>>>(
    as: #MockPostgrestListFilterBuilder,
  ),
  MockSpec<PostgrestFilterBuilder<Map<String, dynamic>>>(
    as: #MockPostgrestMapFilterBuilder,
  ),
  MockSpec<
    PostgrestFilterBuilder<PostgrestResponse<List<Map<String, dynamic>>>>
  >(as: #MockPostgrestCountFilterBuilder),
  MockSpec<PostgrestTransformBuilder<List<Map<String, dynamic>>>>(
    as: #MockPostgrestListTransformBuilder,
  ),
  MockSpec<PostgrestTransformBuilder<Map<String, dynamic>>>(
    as: #MockPostgrestMapTransformBuilder,
  ),
])
void main() {}
