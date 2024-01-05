class CloudStoreException implements Exception {
  const CloudStoreException();
}

class CouldNotCreateNoteException extends CloudStoreException {}

class CouldNotGetAllNoteException extends CloudStoreException {}

class CouldNotUpdateNoteException extends CloudStoreException {}

class CouldNotDeleteNoteException extends CloudStoreException {}
