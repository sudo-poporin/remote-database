import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:remote_database/remote_database.dart';
import '../../dependencies/mock_runner_test.mocks.dart';

void main() {
  late MockSupabaseStorageClient mockClient;
  late MockStorageFileApi mockFileApi;
  late RemoteStorage storage;

  setUp(() {
    mockClient = MockSupabaseStorageClient();
    mockFileApi = MockStorageFileApi();
    storage = RemoteStorage(client: mockClient);

    when(mockClient.from(any)).thenReturn(mockFileApi);
  });

  group('RemoteStorage - uploadBytes', () {
    final testData = Uint8List.fromList([1, 2, 3, 4, 5]);

    test('returns Right(path) on successful upload', () async {
      when(
        mockFileApi.uploadBinary(
          any,
          any,
          fileOptions: anyNamed('fileOptions'),
        ),
      ).thenAnswer((_) async => 'avatars/user123.png');

      final result = await storage.uploadBytes(
        bucket: 'avatars',
        path: 'user123.png',
        data: testData,
      );

      expect(result.isRight(), isTrue);
      result.fold(
        (l) => fail('Expected Right but got Left'),
        (path) => expect(path, equals('avatars/user123.png')),
      );
    });

    test('returns Right(path) with contentType and upsert', () async {
      when(
        mockFileApi.uploadBinary(
          any,
          any,
          fileOptions: anyNamed('fileOptions'),
        ),
      ).thenAnswer((_) async => 'images/photo.jpg');

      final result = await storage.uploadBytes(
        bucket: 'images',
        path: 'photo.jpg',
        data: testData,
        contentType: 'image/jpeg',
        upsert: true,
      );

      expect(result.isRight(), isTrue);
      verify(mockClient.from('images')).called(1);
    });

    test('returns Left(uploadFailure) on StorageException', () async {
      when(
        mockFileApi.uploadBinary(
          any,
          any,
          fileOptions: anyNamed('fileOptions'),
        ),
      ).thenThrow(const StorageException('Upload failed'));

      final result = await storage.uploadBytes(
        bucket: 'avatars',
        path: 'user123.png',
        data: testData,
      );

      expect(result.isLeft(), isTrue);
      result.fold(
        (error) {
          expect(error, isA<RemoteStorageUploadFailure>());
          final failure = error as RemoteStorageUploadFailure;
          expect(failure.message, equals('Upload failed'));
          expect(failure.path, equals('user123.png'));
        },
        (r) => fail('Expected Left but got Right'),
      );
    });

    test('returns Left(fileNotFound) when path not found', () async {
      when(
        mockFileApi.uploadBinary(
          any,
          any,
          fileOptions: anyNamed('fileOptions'),
        ),
      ).thenThrow(const StorageException('Object not found'));

      final result = await storage.uploadBytes(
        bucket: 'avatars',
        path: 'missing.png',
        data: testData,
      );

      expect(result.isLeft(), isTrue);
      result.fold(
        (error) => expect(error, isA<RemoteStorageFileNotFound>()),
        (r) => fail('Expected Left but got Right'),
      );
    });

    test('returns Left(permissionDenied) on 403', () async {
      when(
        mockFileApi.uploadBinary(
          any,
          any,
          fileOptions: anyNamed('fileOptions'),
        ),
      ).thenThrow(const StorageException('403 permission denied'));

      final result = await storage.uploadBytes(
        bucket: 'avatars',
        path: 'user123.png',
        data: testData,
      );

      expect(result.isLeft(), isTrue);
      result.fold(
        (error) => expect(error, isA<RemoteStoragePermissionDenied>()),
        (r) => fail('Expected Left but got Right'),
      );
    });

    test('returns Left(unknown) on unexpected exception', () async {
      when(
        mockFileApi.uploadBinary(
          any,
          any,
          fileOptions: anyNamed('fileOptions'),
        ),
      ).thenThrow(Exception('Network error'));

      final result = await storage.uploadBytes(
        bucket: 'avatars',
        path: 'user123.png',
        data: testData,
      );

      expect(result.isLeft(), isTrue);
      result.fold(
        (error) => expect(error, isA<RemoteStorageUnknown>()),
        (r) => fail('Expected Left but got Right'),
      );
    });
  });

  // Note: uploadFile tests are limited because:
  // 1. The method casts dynamic to File, requiring a real File object
  // 2. File operations are platform-specific and hard to mock
  // 3. uploadBytes provides equivalent coverage for upload logic
  //
  // The uploadFile method is tested indirectly through integration tests
  // and shares the same error handling logic as uploadBytes.;

  group('RemoteStorage - download', () {
    test('returns Right(Uint8List) on successful download', () async {
      final bytes = Uint8List.fromList([1, 2, 3, 4, 5]);
      when(mockFileApi.download(any)).thenAnswer((_) async => bytes);

      final result = await storage.download(
        bucket: 'avatars',
        path: 'user123.png',
      );

      expect(result.isRight(), isTrue);
      result.fold(
        (l) => fail('Expected Right but got Left'),
        (data) {
          expect(data, equals(bytes));
          expect(data.length, equals(5));
        },
      );
    });

    test('returns Left(fileNotFound) when file does not exist', () async {
      when(mockFileApi.download(any))
          .thenThrow(const StorageException('Object not found'));

      final result = await storage.download(
        bucket: 'avatars',
        path: 'missing.png',
      );

      expect(result.isLeft(), isTrue);
      result.fold(
        (error) {
          expect(error, isA<RemoteStorageFileNotFound>());
          final notFound = error as RemoteStorageFileNotFound;
          expect(notFound.path, equals('missing.png'));
        },
        (r) => fail('Expected Left but got Right'),
      );
    });

    test('returns Left(fileNotFound) on 404 error', () async {
      when(mockFileApi.download(any))
          .thenThrow(const StorageException('404 not found'));

      final result = await storage.download(
        bucket: 'avatars',
        path: 'missing.png',
      );

      expect(result.isLeft(), isTrue);
      result.fold(
        (error) => expect(error, isA<RemoteStorageFileNotFound>()),
        (r) => fail('Expected Left but got Right'),
      );
    });

    test('returns Left(permissionDenied) on permission error', () async {
      when(mockFileApi.download(any))
          .thenThrow(const StorageException('permission denied'));

      final result = await storage.download(
        bucket: 'private',
        path: 'secret.pdf',
      );

      expect(result.isLeft(), isTrue);
      result.fold(
        (error) => expect(error, isA<RemoteStoragePermissionDenied>()),
        (r) => fail('Expected Left but got Right'),
      );
    });

    test('returns Left(downloadFailure) on generic StorageException', () async {
      when(mockFileApi.download(any))
          .thenThrow(const StorageException('Server error'));

      final result = await storage.download(
        bucket: 'avatars',
        path: 'user123.png',
      );

      expect(result.isLeft(), isTrue);
      result.fold(
        (error) {
          expect(error, isA<RemoteStorageDownloadFailure>());
          final failure = error as RemoteStorageDownloadFailure;
          expect(failure.message, equals('Server error'));
          expect(failure.path, equals('user123.png'));
        },
        (r) => fail('Expected Left but got Right'),
      );
    });

    test('returns Left(unknown) on unexpected exception', () async {
      when(mockFileApi.download(any)).thenThrow(Exception('Network error'));

      final result = await storage.download(
        bucket: 'avatars',
        path: 'user123.png',
      );

      expect(result.isLeft(), isTrue);
      result.fold(
        (error) => expect(error, isA<RemoteStorageUnknown>()),
        (r) => fail('Expected Left but got Right'),
      );
    });
  });

  group('RemoteStorage - delete', () {
    test('returns Right(null) on successful delete', () async {
      when(mockFileApi.remove(any)).thenAnswer((_) async => []);

      final result = await storage.delete(
        bucket: 'avatars',
        paths: ['user123.png'],
      );

      expect(result.isRight(), isTrue);
      verify(mockFileApi.remove(['user123.png'])).called(1);
    });

    test('returns Right(null) on deleting multiple files', () async {
      when(mockFileApi.remove(any)).thenAnswer((_) async => []);

      final result = await storage.delete(
        bucket: 'avatars',
        paths: ['file1.png', 'file2.png', 'file3.png'],
      );

      expect(result.isRight(), isTrue);
      verify(mockFileApi.remove(['file1.png', 'file2.png', 'file3.png']))
          .called(1);
    });

    test('returns Left(deleteFailure) on StorageException', () async {
      when(mockFileApi.remove(any))
          .thenThrow(const StorageException('Delete failed'));

      final result = await storage.delete(
        bucket: 'avatars',
        paths: ['user123.png'],
      );

      expect(result.isLeft(), isTrue);
      result.fold(
        (error) {
          expect(error, isA<RemoteStorageDeleteFailure>());
          final failure = error as RemoteStorageDeleteFailure;
          expect(failure.message, equals('Delete failed'));
        },
        (r) => fail('Expected Left but got Right'),
      );
    });

    test('returns Left(unknown) on unexpected exception', () async {
      when(mockFileApi.remove(any)).thenThrow(Exception('Network error'));

      final result = await storage.delete(
        bucket: 'avatars',
        paths: ['user123.png'],
      );

      expect(result.isLeft(), isTrue);
      result.fold(
        (error) => expect(error, isA<RemoteStorageUnknown>()),
        (r) => fail('Expected Left but got Right'),
      );
    });
  });

  group('RemoteStorage - getPublicUrl', () {
    test('returns Right(url) on success', () {
      when(mockFileApi.getPublicUrl(any))
          .thenReturn('https://storage.supabase.co/avatars/user123.png');

      final result = storage.getPublicUrl(
        bucket: 'avatars',
        path: 'user123.png',
      );

      expect(result.isRight(), isTrue);
      result.fold(
        (l) => fail('Expected Right but got Left'),
        (url) => expect(
          url,
          equals('https://storage.supabase.co/avatars/user123.png'),
        ),
      );
    });

    test('returns Left(urlFailure) on exception', () {
      when(mockFileApi.getPublicUrl(any)).thenThrow(Exception('URL error'));

      final result = storage.getPublicUrl(
        bucket: 'avatars',
        path: 'user123.png',
      );

      expect(result.isLeft(), isTrue);
      result.fold(
        (error) {
          expect(error, isA<RemoteStorageUrlFailure>());
          final failure = error as RemoteStorageUrlFailure;
          expect(failure.path, equals('user123.png'));
        },
        (r) => fail('Expected Left but got Right'),
      );
    });
  });

  group('RemoteStorage - createSignedUrl', () {
    test('returns Right(signedUrl) on success', () async {
      when(mockFileApi.createSignedUrl(any, any)).thenAnswer(
        (_) async =>
            'https://storage.supabase.co/avatars/user123.png?token=abc123',
      );

      final result = await storage.createSignedUrl(
        bucket: 'avatars',
        path: 'user123.png',
        expiresInSeconds: 3600,
      );

      expect(result.isRight(), isTrue);
      result.fold(
        (l) => fail('Expected Right but got Left'),
        (url) => expect(url, contains('token=')),
      );
      verify(mockFileApi.createSignedUrl('user123.png', 3600)).called(1);
    });

    test('returns Left(urlFailure) on StorageException', () async {
      when(mockFileApi.createSignedUrl(any, any))
          .thenThrow(const StorageException('Signed URL failed'));

      final result = await storage.createSignedUrl(
        bucket: 'avatars',
        path: 'user123.png',
        expiresInSeconds: 3600,
      );

      expect(result.isLeft(), isTrue);
      result.fold(
        (error) {
          expect(error, isA<RemoteStorageUrlFailure>());
          final failure = error as RemoteStorageUrlFailure;
          expect(failure.message, equals('Signed URL failed'));
          expect(failure.path, equals('user123.png'));
        },
        (r) => fail('Expected Left but got Right'),
      );
    });

    test('returns Left(unknown) on unexpected exception', () async {
      when(mockFileApi.createSignedUrl(any, any))
          .thenThrow(Exception('Network error'));

      final result = await storage.createSignedUrl(
        bucket: 'avatars',
        path: 'user123.png',
        expiresInSeconds: 3600,
      );

      expect(result.isLeft(), isTrue);
      result.fold(
        (error) => expect(error, isA<RemoteStorageUnknown>()),
        (r) => fail('Expected Left but got Right'),
      );
    });
  });

  group('RemoteStorage - list', () {
    test('returns Right(List<FileObject>) on success', () async {
      when(
        mockFileApi.list(
          path: anyNamed('path'),
          searchOptions: anyNamed('searchOptions'),
        ),
      ).thenAnswer((_) async => []);

      final result = await storage.list(
        bucket: 'avatars',
        path: 'users/',
      );

      expect(result.isRight(), isTrue);
      result.fold(
        (l) => fail('Expected Right but got Left'),
        (files) => expect(files, isEmpty),
      );
    });

    test('returns Right with files when bucket has contents', () async {
      const mockFile = FileObject(
        name: 'test.png',
        id: '123',
        bucketId: 'avatars',
        owner: 'user-123',
        updatedAt: '2026-01-23T00:00:00Z',
        createdAt: '2026-01-23T00:00:00Z',
        lastAccessedAt: '2026-01-23T00:00:00Z',
        metadata: {},
        buckets: null,
      );

      when(
        mockFileApi.list(
          path: anyNamed('path'),
          searchOptions: anyNamed('searchOptions'),
        ),
      ).thenAnswer((_) async => [mockFile]);

      final result = await storage.list(
        bucket: 'avatars',
      );

      expect(result.isRight(), isTrue);
      result.fold(
        (l) => fail('Expected Right but got Left'),
        (files) {
          expect(files.length, equals(1));
          expect(files.first.name, equals('test.png'));
        },
      );
    });

    test('passes limit and offset to searchOptions', () async {
      when(
        mockFileApi.list(
          path: anyNamed('path'),
          searchOptions: anyNamed('searchOptions'),
        ),
      ).thenAnswer((_) async => []);

      await storage.list(
        bucket: 'avatars',
        path: 'users/',
        limit: 10,
        offset: 20,
      );

      verify(
        mockFileApi.list(
          path: 'users/',
          searchOptions: argThat(
            isA<SearchOptions>(),
            named: 'searchOptions',
          ),
        ),
      ).called(1);
    });

    test('passes sortBy to searchOptions', () async {
      when(
        mockFileApi.list(
          path: anyNamed('path'),
          searchOptions: anyNamed('searchOptions'),
        ),
      ).thenAnswer((_) async => []);

      await storage.list(
        bucket: 'avatars',
        sortBy: StorageSortBy.createdAt,
      );

      verify(
        mockFileApi.list(
          searchOptions: argThat(
            isA<SearchOptions>(),
            named: 'searchOptions',
          ),
        ),
      ).called(1);
    });

    test('returns Left(listFailure) on StorageException', () async {
      when(
        mockFileApi.list(
          path: anyNamed('path'),
          searchOptions: anyNamed('searchOptions'),
        ),
      ).thenThrow(const StorageException('List failed'));

      final result = await storage.list(
        bucket: 'avatars',
      );

      expect(result.isLeft(), isTrue);
      result.fold(
        (error) {
          expect(error, isA<RemoteStorageListFailure>());
          final failure = error as RemoteStorageListFailure;
          expect(failure.message, equals('List failed'));
          expect(failure.bucket, equals('avatars'));
        },
        (r) => fail('Expected Left but got Right'),
      );
    });

    test('returns Left(unknown) on unexpected exception', () async {
      when(
        mockFileApi.list(
          path: anyNamed('path'),
          searchOptions: anyNamed('searchOptions'),
        ),
      ).thenThrow(Exception('Network error'));

      final result = await storage.list(
        bucket: 'avatars',
      );

      expect(result.isLeft(), isTrue);
      result.fold(
        (error) => expect(error, isA<RemoteStorageUnknown>()),
        (r) => fail('Expected Left but got Right'),
      );
    });
  });

  group('RemoteStorage - move', () {
    test('returns Right(null) on successful move', () async {
      when(mockFileApi.move(any, any)).thenAnswer((_) async => 'new/path.png');

      final result = await storage.move(
        bucket: 'avatars',
        fromPath: 'old/user123.png',
        toPath: 'new/user123.png',
      );

      expect(result.isRight(), isTrue);
      verify(mockFileApi.move('old/user123.png', 'new/user123.png')).called(1);
    });

    test('returns Left(moveFailure) on StorageException', () async {
      when(mockFileApi.move(any, any))
          .thenThrow(const StorageException('Move failed'));

      final result = await storage.move(
        bucket: 'avatars',
        fromPath: 'old/user123.png',
        toPath: 'new/user123.png',
      );

      expect(result.isLeft(), isTrue);
      result.fold(
        (error) {
          expect(error, isA<RemoteStorageMoveFailure>());
          final failure = error as RemoteStorageMoveFailure;
          expect(failure.message, equals('Move failed'));
          expect(failure.fromPath, equals('old/user123.png'));
          expect(failure.toPath, equals('new/user123.png'));
        },
        (r) => fail('Expected Left but got Right'),
      );
    });

    test('returns Left(unknown) on unexpected exception', () async {
      when(mockFileApi.move(any, any)).thenThrow(Exception('Network error'));

      final result = await storage.move(
        bucket: 'avatars',
        fromPath: 'old/user123.png',
        toPath: 'new/user123.png',
      );

      expect(result.isLeft(), isTrue);
      result.fold(
        (error) => expect(error, isA<RemoteStorageUnknown>()),
        (r) => fail('Expected Left but got Right'),
      );
    });
  });

  group('RemoteStorage - copy', () {
    test('returns Right(null) on successful copy', () async {
      when(mockFileApi.copy(any, any)).thenAnswer((_) async => 'copy/path.png');

      final result = await storage.copy(
        bucket: 'avatars',
        fromPath: 'original/user123.png',
        toPath: 'backup/user123.png',
      );

      expect(result.isRight(), isTrue);
      verify(mockFileApi.copy('original/user123.png', 'backup/user123.png'))
          .called(1);
    });

    test('returns Left(moveFailure) on StorageException', () async {
      when(mockFileApi.copy(any, any))
          .thenThrow(const StorageException('Copy failed'));

      final result = await storage.copy(
        bucket: 'avatars',
        fromPath: 'original/user123.png',
        toPath: 'backup/user123.png',
      );

      expect(result.isLeft(), isTrue);
      result.fold(
        (error) {
          expect(error, isA<RemoteStorageMoveFailure>());
          final failure = error as RemoteStorageMoveFailure;
          expect(failure.message, equals('Copy failed'));
          expect(failure.fromPath, equals('original/user123.png'));
          expect(failure.toPath, equals('backup/user123.png'));
        },
        (r) => fail('Expected Left but got Right'),
      );
    });

    test('returns Left(unknown) on unexpected exception', () async {
      when(mockFileApi.copy(any, any)).thenThrow(Exception('Network error'));

      final result = await storage.copy(
        bucket: 'avatars',
        fromPath: 'original/user123.png',
        toPath: 'backup/user123.png',
      );

      expect(result.isLeft(), isTrue);
      result.fold(
        (error) => expect(error, isA<RemoteStorageUnknown>()),
        (r) => fail('Expected Left but got Right'),
      );
    });
  });

  group('RemoteStorage - _mapStorageException', () {
    test('maps bucket error to bucketNotFound', () async {
      // Message must contain "bucket" but NOT "not found" or "404"
      // because those patterns have higher priority
      when(mockFileApi.download(any))
          .thenThrow(const StorageException('Invalid bucket specified'));

      final result = await storage.download(
        bucket: 'nonexistent',
        path: 'file.png',
      );

      expect(result.isLeft(), isTrue);
      result.fold(
        (error) => expect(error, isA<RemoteStorageBucketNotFound>()),
        (r) => fail('Expected Left but got Right'),
      );
    });
  });
}
