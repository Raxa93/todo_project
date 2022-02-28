

class Todo {
  String taskId;
  String taskDescription;
  String taskDateTime;
  String taskAdditionalNotes;
  String taskCategory;

  Todo({this.taskId, this.taskDescription, this.taskDateTime, this.taskAdditionalNotes, this.taskCategory});

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      taskId: map['taskId'].toString(),
      taskDescription: map['taskDescription'].toString(),
      taskDateTime: map['taskDateTime'],
      taskAdditionalNotes: map['taskAdditionalNotes'].toString(),
      taskCategory: map['taskCategory'].toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'taskId': taskId,
      'taskDescription': taskDescription,
      'taskDateTime': taskDateTime,
      'taskAdditionalNotes': taskAdditionalNotes,
      'taskCategory': taskCategory
    };
  }
}
