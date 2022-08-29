import 'package:flutter/material.dart';

class FilterState {
  String searchedPhrase;
  bool inProgress;
  bool confirmed;
  bool archived;
  bool byDate;
  late DateTime pickedDay;

  FilterState([
    this.searchedPhrase = '',
    this.inProgress = true,
    this.confirmed = true,
    this.archived = true,
    this.byDate = true,
  ]) {
    pickedDay = DateTime.now();
  }
}
