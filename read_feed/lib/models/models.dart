import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:ReadFeed/widgets/article_widgets/article_item.dart';

class Article {
  final String id;
  final String title;
  final String url;
  final String domain;
  final String image;

  Article({this.domain, this.title, this.id, this.url, this.image});
}


class AppBarModel extends Model {
  Article _selectedArticle;
  bool _isSelected = false;
  
  bool get isSelected => _isSelected;
  Article get selectedArticle => _selectedArticle;

hideOptionsAppbar(){
  _selectedArticle = null;
  _isSelected = !_isSelected;
  notifyListeners();
}

  
  showOptionsAppbar(Article article){
    _isSelected = !_isSelected;
    _selectedArticle = article;
    notifyListeners();
  } 
}

