class UploadRequestsResponse {
  final String status;
  final List<GroupUploadRequest> groups;

  UploadRequestsResponse({
    required this.status,
    required this.groups,
  });

  factory UploadRequestsResponse.fromJson(Map<String, dynamic> json) {
    return UploadRequestsResponse(
      status: json['status'] ?? '',
      groups: (json['data'] as List<dynamic>)
          .map((group) => GroupUploadRequest.fromJson(group))
          .toList(),
    );
  }
}

class GroupUploadRequest {
  final int id;
  final String name;
  final String image;
  final bool isPublic;
  final List<PendingFileRequest> pendingFiles;

  GroupUploadRequest({
    required this.id,
    required this.name,
    required this.image,
    required this.isPublic,
    required this.pendingFiles,
  });

  factory GroupUploadRequest.fromJson(Map<String, dynamic> json) {
    return GroupUploadRequest(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown Group',
      image: json['image'] ??
          "https://cdn.elearningindustry.com/wp-content/uploads/2020/02/what-to-check-before-an-online-course-purchase.png",
      isPublic: json['isPublic'] ?? false,
      pendingFiles: (json['GroupFiles'] as List<dynamic>)
          .map((file) => PendingFileRequest.fromJson(file))
          .toList(),
    );
  }
}

class PendingFileRequest {
  final int id;
  final FileDetails fileDetails;

  PendingFileRequest({
    required this.id,
    required this.fileDetails,
  });

  factory PendingFileRequest.fromJson(Map<String, dynamic> json) {
    return PendingFileRequest(
      id: json['id'] ?? 0,
      fileDetails: FileDetails.fromJson(json['File']),
    );
  }
}

class FileDetails {
  final int id;
  final String name;
  final String dbName;
  final UploaderDetails uploader;

  FileDetails({
    required this.id,
    required this.name,
    required this.dbName,
    required this.uploader,
  });

  factory FileDetails.fromJson(Map<String, dynamic> json) {
    return FileDetails(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown File',
      dbName: json['dbName'] ?? '',
      uploader: UploaderDetails.fromJson(json['User']),
    );
  }
}

class UploaderDetails {
  final int id;
  final String email;
  final String firstName;
  final String lastName;

  UploaderDetails({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
  });

  factory UploaderDetails.fromJson(Map<String, dynamic> json) {
    return UploaderDetails(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
    );
  }
}
