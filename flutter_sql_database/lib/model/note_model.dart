class NoteModel {
  final int? id;
  final bool isImportant;
  final int number;
  final String title;
  final String description;
  final DateTime createdat;

  const NoteModel(
      {this.id,
      required this.isImportant,
      required this.number,
      required this.title,
      required this.description,
      required this.createdat});

// methods to convert to and from JSON.
  Map<String, Object?> toJson() => {
        NoteFields.id: id,
        NoteFields.isImportant: isImportant ? 1 : 0,
        NoteFields.title: title,
        NoteFields.description: description,
        NoteFields.number: number,
        NoteFields.createdat: createdat.toIso8601String(),
      };

  static NoteModel fromJson(Map<String, Object?> json) => NoteModel(
      id: json[NoteFields.id] as int?,
      isImportant: json[NoteFields.isImportant] == 1,
      number: json[NoteFields.number] as int,
      title: json[NoteFields.title] as String,
      description: json[NoteFields.description] as String,
      createdat: DateTime.parse(json[NoteFields.createdat] as String));

  NoteModel copyNote({
    int? id,
    bool? isImportant,
    int? number,
    String? title,
    String? description,
    DateTime? createdat,
  }) =>
      NoteModel(
          id: id ?? this.id,
          isImportant: isImportant ?? this.isImportant,
          number: number ?? this.number,
          title: title ?? this.title,
          description: description ?? this.description,
          createdat: createdat ?? this.createdat);
}


// Table and Fields: The NoteFields class defines the table and field names used in the database.
const String tableNotes = 'notes';

class NoteFields {

  static final List<String> values = [
    id, isImportant, number, title, description, createdat
  ];

  static const String id = '_id';
  static const String isImportant = 'isImportant';
  static const String number = 'number';
  static const String title = 'title';
  static const String description = 'description';
  static const String createdat = 'createdat';
}
