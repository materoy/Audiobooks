import 'package:equatable/equatable.dart';

class LibrivoxAudiobook extends Equatable {
  const LibrivoxAudiobook(
      {required this.id,
      required this.title,
      required this.description,
      required this.language,
      required this.numSections,
      required this.zipFileUrl,
      required this.totalTimeSeconds,
      required this.authors,
      required this.librivoxUrl,
      required this.projectUrl,
      required this.textSourceUrl});

  final int id;
  final String title;
  final String description;
  final String language;
  final int numSections;
  final String zipFileUrl;
  final int totalTimeSeconds;
  final List<LibrivoxAuthor> authors;
  final String librivoxUrl;
  final String projectUrl;
  final String textSourceUrl;

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        language,
        numSections,
        zipFileUrl,
        totalTimeSeconds,
        authors,
        librivoxUrl,
        projectUrl,
        textSourceUrl
      ];

  factory LibrivoxAudiobook.fromMap(Map<String, dynamic> audiobookMap) {
    return LibrivoxAudiobook(
        id: int.tryParse(audiobookMap['id'])!,
        title: audiobookMap['title'],
        description: audiobookMap['description'],
        language: audiobookMap['language'],
        numSections: int.tryParse(audiobookMap['num_sections'])!,
        zipFileUrl: audiobookMap['url_zip_file'],
        totalTimeSeconds: audiobookMap['totaltimesecs'],
        authors: List.generate(audiobookMap['authors'].length,
            (index) => LibrivoxAuthor.fromMap(audiobookMap['authors'][index])),
        librivoxUrl: audiobookMap['url_librivox'],
        projectUrl: audiobookMap['url_project'],
        textSourceUrl: audiobookMap['url_text_source']);
  }
}

class LibrivoxAuthor extends Equatable {
  const LibrivoxAuthor(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.dob,
      required this.dod});

  final int id;
  final String firstName;
  final String lastName;
  final int dob;
  final int dod;

  @override
  List<Object?> get props => [id, firstName, lastName, dob, dod];

  factory LibrivoxAuthor.fromMap(Map<String, dynamic> authorMap) {
    return LibrivoxAuthor(
      id: int.tryParse(authorMap['id'])!,
      firstName: authorMap['first_name'],
      lastName: authorMap['last_name'],
      dob: int.tryParse(authorMap['dob'])!,
      dod: int.tryParse(authorMap['dod'])!,
    );
  }
}
