import 'dart:ui';

enum ExerciseType{PushUps, Squats, DownwardDogPlank, JumpingJack, HighKnees}
class ExerciseDataModel{
  String title;
  String image;
  Color color;
  ExerciseType type;
  ExerciseDataModel(this.title, this.image, this.color, this.type);
}