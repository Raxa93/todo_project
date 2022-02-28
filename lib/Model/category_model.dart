class TaskCategory {
  int categoryId;
  String categoryName;
  int categoryColor;
  int categoryIcon;
  int numberOfTask;

  TaskCategory({this.categoryId,this.categoryName, this.categoryColor, this.categoryIcon,this.numberOfTask});

  factory TaskCategory.fromMap(Map<String, dynamic> map) {
    return TaskCategory(
        categoryId : map['categoryId'],
      categoryName: map['categoryName'].toString(),
      categoryColor: map['categoryColor'],
      categoryIcon: map['categoryIcon'],
      numberOfTask: map['numberOfTask']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'categoryName': categoryName,
      'categoryColor': categoryColor,
      'categoryIcon': categoryIcon,
      'numberOfTask' : numberOfTask,
    };
  }
}
