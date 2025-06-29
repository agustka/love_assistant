import 'package:la/domain/wizard/entities/profile.dart';

abstract class IProfileRepository {
  /// Creates a new partner profile
  Future<void> createProfile(Profile profile);
  
  /// Updates an existing partner profile
  Future<void> updateProfile(Profile profile);
  
  /// Retrieves the current partner profile
  Future<Profile?> getProfile();
  
  /// Checks if a profile has been created
  Future<bool> isProfileCreated();
  
  /// Deletes the current profile
  Future<void> deleteProfile();
}
